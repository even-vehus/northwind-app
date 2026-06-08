# CLAUDE.md — Northwind App

## Project Context

This is **one app in a large-scale Access-to-web migration project**. The broader programme migrates 50–1000 Microsoft Access databases to modern web apps. Each database gets its own repo (like this one). The data extraction tooling lives in a separate repo (`access-to-sql-migration`); its output is committed here under `migration_output/`.

The source database is `NorthwindStarterED.accdb` — an educational/starter version of the classic Northwind database (companies, orders, products, employees, purchase orders).

---

## Tech Stack

### Backend
- **ASP.NET Core 10** Web API — minimal Program.cs (no Startup class)
- **EF Core** with `Microsoft.Identity.Web` for auth
- **Microsoft Fabric SQL** as the database (Azure SQL-compatible, uses `Authentication=Active Directory Default`)
- **OpenAPI** via `AddOpenApi()` — NOT Swashbuckle
- Solution: `Northwind.Api` / `Northwind.Domain` / `Northwind.Infrastructure` / `Northwind.Tests`

### Frontend
- **React 19 + Vite + TypeScript**
- **MUI v9** — Grid uses `size` prop (e.g. `size={{ xs: 12, sm: 6 }}`), NOT the old `xs`/`sm` props
- **TanStack Query v5** for server state
- **React Router v7**
- **React Hook Form v7 + Zod v4 + @hookform/resolvers v5**
- **MSAL** (`@azure/msal-browser` v5, `@azure/msal-react` v5) for Entra ID auth

### Dev Ports
- Backend: `http://localhost:5298`
- Frontend: `http://localhost:5174`

---

## Running Locally

```powershell
# Backend (in backend/Northwind.Api/)
az login    # needed for DefaultAzureCredential → Fabric SQL
dotnet run

# Frontend (in Northwind/)
npm run dev
```

---

## Authentication

- **Frontend**: MSAL browser popup/redirect against Entra ID
- **Backend**: `Microsoft.Identity.Web` validates JWT Bearer tokens
- **Dev shortcut**: When `AzureAd:ClientId` is absent from config, both `DefaultPolicy` and `FallbackPolicy` are set to `RequireAssertion(_ => true)` — auth is fully bypassed in dev

---

## Database

- Target: Microsoft Fabric SQL
- Connection string (in `appsettings.Development.json`):
  ```
  Data Source=<fabric-host>,1433;Initial Catalog=<catalog>;...;Authentication=Active Directory Default
  ```
- All 29 source tables already exist in the target DB
- In-memory fallback is used automatically when no connection string is found

### CORS
`appsettings.json` → `"AllowedOrigins": ["http://localhost:5173", "http://localhost:5174"]`

---

## Migration Artifacts (read-only reference)

```
migration_output/NorthwindStarterED/
  01_create_tables.sql      All 29 tables with exact column names
  02_foreign_keys.sql
  03_indexes.sql
  04_insert_data.sql        Seed data
  05_views.sql              Access saved queries → T-SQL views
  06_action_queries.sql     Access action queries
  forms_vba.json            All 40 forms + 15 reports + VBA module source
  data_inserts/             Per-table seed SQL
```

`forms_vba.json` structure:
```json
{
  "forms":      [ { "name": "frmOrderList", "vba_source": "..." }, ... ],
  "reports":    [ { "name": "rptInvoice",   ... }, ... ],
  "vba_modules": [ { "name": "modInventory", "source": "..." }, ... ]
}
```

---

## Project Structure

```
backend/
  Northwind.Api/
    Controllers/      One file per resource
    Dtos/Dtos.cs      All DTOs in a single file (records)
    Program.cs
  Northwind.Domain/Entities/   Domain entities
  Northwind.Infrastructure/Data/
    NorthwindDbContext.cs
    Configurations/EntityConfigurations.cs   All EF configs in one file

Northwind/src/
  api/
    types.ts          All TS interfaces
    endpoints.ts      Axios API objects (companiesApi, ordersApi, reportsApi, …)
    hooks.ts          All TanStack Query hooks
  components/Layout.tsx
  pages/              One file per route
  auth/               MSAL config + token helper
```

---

## What Is Built

### Backend Controllers
| Controller | Route | Key operations |
|---|---|---|
| CompaniesController | `api/companies` | CRUD, types lookup, company lookup, shipper orders, vendor POs |
| ContactsController | `api/contacts` | CRUD |
| ProductsController | `api/products` | CRUD, categories, vendors sub-resource, stock-takes sub-resource |
| OrdersController | `api/orders` | CRUD + line items sub-resource |
| EmployeesController | `api/employees` | CRUD, lookup, privileges sub-resource |
| PurchaseOrdersController | `api/purchase-orders` | CRUD + line items sub-resource |
| AdminController | `api/admin` | System settings, all lookup tables |
| ReportsController | `api/reports` | 6 report endpoints + invoice |

### Domain Entities (29-table coverage)
All 19 meaningful tables are mapped. The 10 skipped tables are Access UI artefacts (`USysRibbons`, `MRU`, `NorthwindFeatures`, `Welcome`, `Learn`, `Strings`, `Titles`, `States`, `UserSettings`, `Catalog_TableOfContents`) with no web equivalent.

### Frontend Pages & Routes
| Route | Page | Notes |
|---|---|---|
| `/` | DashboardPage | Landing page — KPIs, order pipeline, recent orders (`GET api/dashboard/summary`) |
| `/companies` | CompaniesPage | Search + paged list |
| `/companies/:id` | CompanyDetailPage | Edit/view + Contacts tab + Orders tab + Shipper Orders tab + Vendor POs tab |
| `/contacts` | ContactsPage | Search + paged list |
| `/products` | ProductsPage | Search + category filter + paged list |
| `/products/:id` | ProductDetailPage | Edit/view + Vendors tab + Stock Takes tab |
| `/orders` | OrdersPage | Status filter + paged list |
| `/orders/:id` | OrderDetailPage | Edit/view + line items + Invoice button |
| `/orders/:id/invoice` | InvoicePage | Print-ready invoice |
| `/employees` | EmployeesPage | Search + paged list |
| `/employees/:id` | EmployeeDetailPage | Edit/view + Privileges tab |
| `/purchase-orders` | PurchaseOrdersPage | Status filter + paged list |
| `/purchase-orders/:id` | PurchaseOrderDetailPage | Edit/view + line items |
| `/reports` | ReportsPage | Card grid landing |
| `/reports/sales-by-employee` | SalesByEmployeePage | Year filter |
| `/reports/sales-by-product` | SalesByProductPage | Year filter |
| `/reports/sales-by-product-quarterly` | SalesByProductQuarterlyPage | Pivot table |
| `/reports/employee-directory` | EmployeeDirectoryPage | Email + phone |
| `/reports/product-catalog` | ProductCatalogPage | Grouped by category |
| `/reports/customer-list` | CustomerListPage | |
| `/admin` | AdminPage | System settings inline edit |

---

## What Is Still Missing

### Forms — all high-priority business forms now implemented ✅
The four previously-missing forms are done: Product detail → Orders tab (`sfrmProductDetail_Orders`),
Product detail → Purchase Orders tab (`sfrmProductDetail_PurchaseOrders`), Product Categories page
(`sfrmProductCategories`), and Employee detail → Recent Orders tab (`sfrmOrders_MostRecent_ByEmployee`).

Still missing (low value):
- **`frmEmployeeTitles`** — CRUD page for the Titles lookup. The read-only lookup + dropdown exists
  (`GET api/employees/titles`); no management page.
- **Admin/dev utilities** — `sfrmAdmin_DeleteTestData`, `sfrmAdmin_ResetDates`, `sfrmAdmin_InternetOrders`
  (`modOrders.CreateRandomOrders`), `sfrmAdmin_Strings`. Deliberately not ported.
- **Privilege enforcement** — Employee Privileges are viewable/assignable but not *enforced* (auth bypassed
  in dev; the PO "Approve" privilege check is stubbed). Wire up when real Entra auth is enabled.
- **Per-field locking by status** — Access `LockControls` greyed fields by status; web relies on workflow
  guards instead (safe, but the edit form is less restrictive).

### Reports — all implemented ✅
- `srptOrderForm` → `PurchaseOrderFormPage` (`/purchase-orders/:id/print`)
- `srptQuality` and `srptShipVia` are **sub-reports of `rptProductCatalog`**, not standalone reports. Folded into `ProductCatalogPage`: `srptQuality` = the static "Commitment to Quality" blurb (verbatim from Strings 45/46); `srptShipVia` = the "How to Order — Ship Via" shipper list (Companies where `CompanyTypeID = 2`, via `GET api/companies/lookup?companyTypeId=2`).

Reports intentionally skipped: `rptLearn`, `rptRelationshipsWindow`, `srptGastronomic`, `srptCatalog_TableOfContents` (Access-specific, no web equivalent — `srptGastronomic` is a static catalog blurb like `srptQuality`)

### VBA business logic — ported ✅ (see `VBA_PORT_LOG.md`)
The meaningful domain logic is now in `Northwind.Infrastructure/Services/` with 42 unit tests:
- `modInventory` → `InventoryService` (availability, allocation state machine, reorder calc)
- `modOrders` / `frmOrderDetails` → `OrderWorkflowService` (New→Invoiced→Shipped→Paid→Closed + guards)
- `modPurchaseOrders` / `frmPurchaseOrderDetails` → `PurchaseOrderWorkflowService` (New→Submitted→Approved→Received→Closed, receive re-allocates, reorder + merge)
- `frmCompanyDetail` → `CompanyGuardService` (delete / type-change referential guards)
- `modValidation` was Access control-highlighting — N/A (covered by Zod + DB constraints).
- Guard violations surface as HTTP 409 (`BusinessRuleException` → `BusinessRuleExceptionFilter`) with the original Strings-table wording.
- Not ported (dev/demo utilities): `modOrders.CreateRandomOrders`, `modOrders.SetDatesToCurrent`.

---

## Key Patterns / Gotchas

- **MUI Grid v9**: always `size={{ xs: 12 }}`, never `xs={12}`
- **Edit toggle pattern**: `editing` boolean state; view grid collapses to form on edit
- **Paged API**: all list endpoints return `PagedResult<T>` with `items`, `totalCount`, `page`, `pageSize`
- **Lookup endpoints**: lightweight arrays (not paged) used for dropdowns — see `lookupsApi` in `endpoints.ts` and `AdminController` for lookup routes
- **Auth bypass in dev**: no `[Authorize]` needed — `FallbackPolicy = allow all` when no ClientId
- **EF column name mapping**: DB uses `CompanyID` (uppercase D); entity uses `CompanyId` — mapped explicitly in `EntityConfigurations.cs`
- **Sub-resource pattern**: nested routes like `api/products/{id}/vendors` return arrays (not paged)
- **DTOs**: all in `Northwind.Api/Dtos/Dtos.cs` as C# records — one file
