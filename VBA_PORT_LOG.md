# VBA Port Log & Plan

Tracks porting the Access VBA **business logic** to the C# backend. UI-only VBA (form
plumbing, control highlighting, ribbon callbacks, startup) is **not** ported — its concerns
are handled by React + MUI + React Hook Form/Zod.

Source of truth: `migration_output/NorthwindStarterED/forms_vba.json`. Status seed values
confirmed from `csv_data/{OrderStatus,OrderDetailStatus,PurchaseOrderStatus}.csv`.

## Status enums (DB IDs — match seed data exactly)

| OrderStatus | OrderDetailStatus | PurchaseOrderStatus |
|---|---|---|
| 3 New, 2 Invoiced, 4 Shipped, 5 Paid, 1 Closed | 3 New, 1 Allocated, 4 NoStock, 5 OnOrder, 2 Invoiced, 6 Shipped | 3 New, 4 Submitted, 1 Approved, 5 Received, 2 Closed |

## What's business logic vs. UI-only

| VBA module | Lines | Disposition |
|---|---|---|
| `modInventory` | 391 | **PORT** — inventory engine (availability, allocation, reorder) |
| `Form_frmOrderDetails` | 732 | **PORT** the status-transition rules (rest is UI) |
| `Form_frmPurchaseOrderDetails` | 631 | **PORT** the PO workflow + receiving (rest is UI) |
| `Form_frmCompanyDetail` | 713 | **PORT** the delete / type-change guard (rest is UI) |
| `modOrders` | 227 | PARTIAL — order-create defaults + allocation triggers; rest is form plumbing / dev seeders |
| `modPurchaseOrders` | 190 | PARTIAL — `AddPurchaseOrderDetail` merge rule, `ReorderProduct`; rest is form plumbing |
| `modValidation` | 171 | SKIP — Access control-highlighting; covered by Zod + DB NOT NULL |
| `modGlobal`, `modStrings`, `modMath`, `modDAO`, `modFiles`, `modForms`, `modRibbonCallback`, `modStartup`, `modSecurity`, `modDebug`, `clsErrorHandler`, `modTableDataMacros`, `modReportParameters` | — | SKIP — utilities / Access runtime / UI |

## Architecture decision

Add a service layer in **`Northwind.Infrastructure/Services/`** (services take
`NorthwindDbContext`, registered in DI, called from controllers). Status enums live in
**`Northwind.Domain`**. Workflow guards throw a `BusinessRuleException` mapped to **HTTP 409**
with the message text (sourced from the Access `Strings` table). The in-memory DB fallback +
seed data make the inventory math unit-testable deterministically.

---

## Phase 0 — Foundations  🟡 partial
- ✅ `OrderStatusId` / `OrderDetailStatusId` / `PurchaseOrderStatusId` enums in `Northwind.Domain/Enums` (values = seed IDs above).
- ✅ `Northwind.Infrastructure/Services/` folder + DI registration.
- ⬜ `BusinessRuleException` + exception→409 mapping and `Strings` message constants — deferred to Phase 2 (first needed for workflow guards).

## Phase 1 — Inventory engine (`modInventory`)  ✅ DONE
`InventoryService` (`Northwind.Infrastructure/Services/InventoryService.cs`) implements all
modInventory calculations + `AllocateInventory`. Exposed via `GET api/products/{id}/inventory`
→ `ProductInventoryDto`. 5 unit tests in `Northwind.Tests/InventoryServiceTests.cs` (in-memory,
seed-data scenarios) pass; endpoint verified against live Fabric SQL.

**Bug fixed en route:** `OrderDetailConfiguration` never mapped `OrderDetail.StatusId` (EF
defaulted the column to `StatusId`; real column is `OrderDetailStatusID`) and the entity carried
three phantom properties with no DB column (`DateAllocated`, `PurchaseOrderId`, `InventoryId`) —
now mapped/ignored in `EntityConfigurations.cs`. This was latent: any full-entity load of
`OrderDetail` against SQL would have failed.

**⚠️ Carry-over for Phase 2/3:** `OrderDetail.Quantity` is `decimal` in the entity but `INT` in the
DB. `GetInventory` is safe (uses `SUM` projections), but `AllocateInventory` does a full-entity
load — verify decimal↔INT materialization against SQL when it gets wired to an endpoint (tests use
the in-memory provider, which ignores column types).

### (was) Phase 1 detail — implemented as above
`InventoryService`:
- `ProductLastStockTake(productId)` → (date, qty). **Side rule:** if no StockTake exists, create one (qty 0, date = product `AddedOn`).
- `ProductSold(productId, asOf)` = Σ OrderDetails.Quantity where Order.InvoiceDate ≥ asOf.
- `ProductBought(productId, asOf)` = Σ PurchaseOrderDetails.Quantity where ReceivedDate ≥ asOf.
- `ProductAvailable` = lastStockTakeQty + bought − sold *(Allen Browne formula)*.
- `ProductAllocated / ProductNoStock` = Σ qty by OrderDetailStatus.
- `ProductOnOrder` = Σ qty on **Approved** POs.
- `ProductToSell` = available − allocated.
- `ProductReorderQuantity` = max(MinimumReorderQuantity, (NoStock + TargetLevel) − (ToSell + OnOrder)).
- `AllocateInventory(productId)` — **the state machine.** Order detail lines in status (Allocated, NoStock, OnOrder), oldest order first: qty ≤ available → Allocated; else qty ≤ available+onOrder → OnOrder; else NoStock.
- Endpoint: `GET api/products/{id}/inventory` for the Product detail page. Unit tests vs. seed data.

## Phase 2 — Order workflow (`frmOrderDetails`)  ⬜ todo
`OrderWorkflowService` transitions (each guarded; cascade line-item status):
- **Invoice**: only if New; needs ≥1 line **and all lines Allocated**; Order→Invoiced, lines→Invoiced.
- **Ship**: only if Invoiced; needs shipping fields filled; Order→Shipped, lines→Shipped.
- **Pay**: only if Shipped; needs paid fields filled; Order→Paid.
- **Close**: only if Paid; Order→Closed.
- **Create** default status = New; setting Customer sets TaxStatus from `Companies.StandardTaxStatusID`.
- **Delete guard**: only if New or Invoiced; on delete, re-run `AllocateInventory` per product (release allocations).
- Trigger `AllocateInventory(product)` when a line item is added/changed.
- Endpoints: `POST api/orders/{id}/{invoice|ship|pay|close}`.

## Phase 3 — Purchase Order workflow (`frmPurchaseOrderDetails`, `modPurchaseOrders`)  ⬜ todo
`PurchaseOrderWorkflowService`:
- **Submit**: only if New → Submitted.
- **Approve**: only if Submitted → Approved (requires "Approve PO" privilege — stub while auth bypassed).
- **Receive**: only if Approved → Received; set `ReceivedDate = now` on PO **and all line items** (critical for inventory); then `AllocateInventory` for each product on the PO.
- **Close**: only if Received → Closed; requires ShippingFee + PaymentMethod.
- **Delete guard**: only if New or Submitted.
- `AddPurchaseOrderDetail`: if a line for the product exists, **add to its quantity**; else insert.
- `ReorderProduct(product, vendor, qty, cost)`: create PO (New) + add line.
- Endpoints: `POST api/purchase-orders/{id}/{submit|approve|receive|close}`.

## Phase 4 — Delete guards / referential rules  ⬜ todo
- **Company**: cannot delete or change type if it has Customer Orders, Shipper Orders, or Vendor POs (count > 0), or is an active vendor with products. If only Contacts / Product-Vendor links exist, allow with cascade + confirmation.
- Order delete guard (New/Invoiced) and PO delete guard (New/Submitted) — enforce server-side in Phase 2/3.

## Phase 5 — Frontend wiring  ⬜ todo
- Order/PO detail: status-transition action buttons (Invoice/Ship/Pay/Close, Submit/Approve/Receive/Close) with 409-error surfacing.
- Product detail: show inventory figures (Available, Allocated, On Order, To Sell) + reorder suggestion with a "Create PO" action.

---

## Suggested order
**Phase 1 first** (self-contained, unit-testable, unblocks reorder + order allocation), then Phase 2, 3, 4, 5.
