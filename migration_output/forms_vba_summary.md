# Forms & VBA Extraction Summary

## Complexity

- **Tier**: complex
- **Score**: 21
- **VBA lines**: 9059
- **Event procedures**: 107

## Forms (40)

| Form | Record Source | Controls | Events |
|------|--------------|----------|--------|
| frmReports | — | 22 | 7 |
| frmNorthwindFeatures | NorthwindFeatures | 9 | 1 |
| frmAbout | — | 11 | 1 |
| sfrmProductDetail_Orders | qryProductOrders | 15 | 1 |
| frmSelectVendorDialog | — | 9 | 3 |
| frmPurchaseOrderList | qryPurchaseOrderList | 25 | 2 |
| frmOrderList | qryOrderList | 27 | 4 |
| frmCompanyList | qryCompanyList | 25 | 6 |
| sfrmProductCategories | qryProductCategories | 18 | 4 |
| frmStartup | — | 9 | 0 |
| frmEmployeeList | qryEmployees | 20 | 3 |
| frmEmployeeTitles | Titles | 3 | 0 |
| frmProductList | qryProductList | 18 | 3 |
| sfrmOrderLineItems | qryOrderLineItems | 21 | 6 |
| sfrmPurchaseOrderLineItems | qryPurchaseOrderLineItems | 12 | 2 |
| sfrmCompanyDetail_VendorPurchaseOrders | qryVendorPurchaseOrderList | 15 | 0 |
| sfrmProductDetail_StockTake | qryStockTake | 5 | 2 |
| frmPurchaseOrderDetails | qryPurchaseOrder | 35 | 9 |
| frmOrderDetails | qryOrder | 33 | 10 |
| sfrmProductDetail_Vendors | qryProductVendors | 8 | 1 |
| sfrmAdmin_Strings | qryStrings | 7 | 0 |
| frmCredentials | qryEmployeeLogin | 16 | 2 |
| sfrmAdmin_DeleteTestData | — | 4 | 1 |
| frmProductDetail | qryProductDetail | 31 | 7 |
| sfrmAdmin_ResetDates | qrySystemSettings | 4 | 1 |
| sfrmProductDetail_PurchaseOrders | qryProductPurchaseOrder | 9 | 1 |
| sfrmCompanyDetail_CustomerOrders | qryCustomerOrderList | 13 | 0 |
| frmLearn | — | 14 | 0 |
| _Design | — | 19 | 0 |
| sfrmCompanyDetail_ShipperOrders | qryShipperOrderList | 13 | 0 |
| sfrmCompanyDetail_Contacts | qryContacts | 24 | 2 |
| sfrmAdmin_InternetOrders | qrySystemSettings | 6 | 2 |
| frmLogin | — | 12 | 2 |
| sfrmEmployee_Privileges | qryEmployeePrivileges | 9 | 0 |
| sfrmOrders_MostRecent_ByEmployee | qryOrders_MostRecent | 13 | 1 |
| frmGenericDialog | — | 7 | 2 |
| frmAdmin | — | 22 | 8 |
| frmCompanyDetail | qryCompanies | 29 | 11 |
| sfrmAdmin_SystemSettings | qrySystemSettings | 11 | 0 |
| frmWelcome | Welcome | 14 | 1 |

## Reports (15)

| Report | Record Source | Controls |
|--------|--------------|----------|
| rptLearn | — | 32 |
| rptProductCatalog | qryrptProductCatalog | 29 |
| rptInvoice | qryInvoice | 28 |
| srptGastronomic | — | 2 |
| rptEmployeeEmailList | qryrptEmployeeEmailList | 11 |
| rptSalesByProductQuarterly | qryrptSalesByProduct_ByQuarter | 17 |
| srptOrderForm | SELECT CompanyTypes.CompanyType, Companies.CompanyID, Companies.CompanyName, Com | 50 |
| rptSalesByEmployee | qryrptSalesByEmployee | 17 |
| srptCatalog_TableOfContents | Catalog_TableOfContents | 3 |
| rptSalesByProduct | qryrptSalesByProduct_ByMonth | 17 |
| rptEmployeePhoneList | qryrptEmployeePhoneList | 14 |
| rptRelationshipsWindow | — | 1 |
| _Design | — | 2 |
| srptQuality | — | 2 |
| srptShipVia | qryShippers | 3 |

## VBA Modules (66)

| Module | Type | Lines | API Decl | External Refs |
|--------|------|-------|----------|---------------|
| modForms | StandardModule | 100 | No | — |
| modCompanies | StandardModule | 28 | No | — |
| modFiles | StandardModule | 46 | No | — |
| modSecurity | StandardModule | 21 | No | — |
| clsErrorHandler | ClassModule | 141 | No | — |
| modPurchaseOrders | StandardModule | 190 | No | — |
| modTableDataMacros | StandardModule | 69 | No | — |
| modStrings | StandardModule | 221 | No | — |
| modGlobal | StandardModule | 483 | No | — |
| modRibbonCallback | StandardModule | 454 | No | — |
| modMath | StandardModule | 51 | No | — |
| modValidation | StandardModule | 171 | No | — |
| modDAO | StandardModule | 88 | No | — |
| modReportParameters | StandardModule | 47 | No | — |
| modDebug | StandardModule | 34 | No | — |
| modInventory | StandardModule | 391 | No | — |
| modStartup | StandardModule | 195 | No | — |
| modOrders | StandardModule | 227 | No | — |
| Form_frmReports | Document | 182 | No | — |
| Form_sfrmProductDetail_Orders | Document | 15 | No | — |
| Form_frmPurchaseOrderList | Document | 44 | No | — |
| Form_frmAbout | Document | 15 | No | — |
| Form_frmEmployeeTitles | Document | 20 | No | — |
| Form_frmSelectVendorDialog | Document | 77 | No | — |
| Form_sfrmOrderLineItems | Document | 294 | No | — |
| Form_frmProductList | Document | 72 | No | — |
| Form_sfrmCompanyDetail_VendorPurchaseOrders | Document | 28 | No | — |
| Form_sfrmProductDetail_StockTake | Document | 132 | No | — |
| Form_sfrmPurchaseOrderLineItems | Document | 121 | No | — |
| Form_frmOrderList | Document | 107 | No | — |
| Form_frmPurchaseOrderDetails | Document | 631 | No | — |
| Form_sfrmProductDetail_Vendors | Document | 37 | No | — |
| Form_sfrmAdmin_DeleteTestData | Document | 85 | No | — |
| Form_sfrmAdmin_Strings | Document | 28 | No | — |
| Form_frmProductDetail | Document | 636 | No | — |
| Form_frmCompanyList | Document | 233 | No | — |
| Form_sfrmProductCategories | Document | 158 | No | — |
| Form_sfrmCompanyDetail_CustomerOrders | Document | 28 | No | — |
| Form_frmNorthwindFeatures | Document | 36 | No | — |
| Form__Design | Document | 2 | No | — |
| Form_frmCredentials | Document | 88 | No | — |
| Form_sfrmAdmin_ResetDates | Document | 17 | No | — |
| Form_sfrmCompanyDetail_ShipperOrders | Document | 28 | No | — |
| Form_sfrmProductDetail_PurchaseOrders | Document | 17 | No | — |
| Form_sfrmOrders_MostRecent_ByEmployee | Document | 15 | No | — |
| Form_frmEmployeeList | Document | 283 | No | — |
| Form_frmGenericDialog | Document | 119 | No | — |
| Form_sfrmCompanyDetail_Contacts | Document | 66 | No | — |
| Form_sfrmAdmin_InternetOrders | Document | 45 | No | — |
| Form_frmLogin | Document | 114 | No | — |
| Form_frmAdmin | Document | 201 | No | — |
| Form_sfrmEmployee_Privileges | Document | 66 | No | — |
| Form_frmCompanyDetail | Document | 713 | No | — |
| Form_sfrmAdmin_SystemSettings | Document | 28 | No | — |
| Form_frmOrderDetails | Document | 732 | No | — |
| Form_frmWelcome | Document | 42 | No | — |
| Report_rptLearn | Document | 41 | No | — |
| Report_rptProductCatalog | Document | 110 | No | — |
| Report_rptInvoice | Document | 41 | No | — |
| Report_rptEmployeeEmailList | Document | 42 | No | — |
| Report_rptSalesByProductQuarterly | Document | 55 | No | — |
| Report_rptSalesByEmployee | Document | 79 | No | — |
| Report_rptSalesByProduct | Document | 55 | No | — |
| Report_rptRelationshipsWindow | Document | 41 | No | — |
| Report__Design | Document | 41 | No | — |
| Report_rptEmployeePhoneList | Document | 42 | No | — |

## Macros (1)

- AutoExec
