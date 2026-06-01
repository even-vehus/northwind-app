# VBA Module Port Log

Tracks the status of porting each VBA module from NorthwindStarterED.accdb to C#.

| Module | Lines | Classification | C# Target | Status | Notes |
|--------|-------|----------------|-----------|--------|-------|
| modValidation | 171 | domain | ValidationService | ⬜ todo | |
| modCompanies | 28 | domain | CompanyService | ⬜ todo | |
| modMath | 51 | domain | MathHelper | ⬜ todo | |
| modStrings | 221 | domain | StringHelper | ⬜ todo | |
| modInventory | 391 | domain | InventoryService | ⬜ todo | |
| modOrders | 227 | domain | OrderService | ⬜ todo | |
| modPurchaseOrders | 190 | domain | PurchaseOrderService | ⬜ todo | |
| modSecurity | 21 | domain | SecurityService | ⬜ todo | |
| clsErrorHandler | 141 | domain | ErrorHandler | ⬜ todo | |
| modTableDataMacros | 69 | domain | TableDataService | ⬜ todo | |
| modReportParameters | 47 | domain | ReportParameterService | ⬜ todo | |
| modDAO | 88 | infrastructure | — | ⏭ skip | Replaced by EF Core |
| modFiles | 46 | infrastructure | — | ⏭ skip | Replaced by .NET file APIs |
| modDebug | 34 | infrastructure | — | ⏭ skip | Replaced by ILogger |
| modForms | 100 | ui_glue | — | ⏭ skip | React state |
| modRibbonCallback | 454 | ui_glue | — | ⏭ skip | No ribbon in web |
| modStartup | 195 | ui_glue | — | ⏭ skip | App startup handled by Program.cs |
| modGlobal | 483 | ui_glue | — | ⏭ skip | Globals → DI services |
| Form_* | varies | ui_glue | — | ⏭ skip | React pages |

**Status key:** ⬜ todo · 🔄 in-progress · ✅ done · ⏭ skip

VBA source available in: `<migration-repo>/migration_output/NorthwindStarterED/forms_vba.json` (field `vba_modules[].source`)
