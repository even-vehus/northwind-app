---
name: entity-mapping-bug-patterns
description: Recurring latent EF-mapping bugs in this generated app and how to spot them
metadata:
  type: project
---

This app was scaffolded with several **latent EF Core ↔ SQL mapping bugs** that only surface when a specific endpoint runs against the real Fabric SQL DB (the in-memory dev provider hides them). When a page "can't read/write" data, suspect one of these:

1. **Entity property mapped to the wrong/nonexistent column.** e.g. `OrderDetail.StatusId` had no `HasColumnName`, so EF emitted `StatusId` but the column is `OrderDetailStatusID`. Also phantom properties with no column (`OrderDetail.DateAllocated/PurchaseOrderId/InventoryId`) → must be `Ignore()`d.
2. **`decimal` property over an `INT` column** → `InvalidCastException: Int32 → Decimal` on full-entity load. `OrderDetail.Quantity` was the case; fixed to `int`. Check other quantity columns.
3. **Free-text form field over a lookup-FK column** → FK-violation 500 on save. `Employees.Title` → `Titles` (valid: blank, `Mr.`, `Ms.`) was the case; fixed with a lookup dropdown. **`Companies.StateAbbrev` → `States` is the same pattern and is NOT yet fixed.**

**How to apply:** verify against the real schema in `migration_output/.../01_create_tables.sql` and `schema_summary.md`, and test the actual endpoint against live SQL (not just the in-memory tests). See [[frontend-typecheck-gotcha]] for the related "tests/build pass but it's still broken" trap. Business-logic port progress is tracked in `VBA_PORT_LOG.md`.
