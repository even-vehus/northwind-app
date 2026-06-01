# Database Schema Summary

**Source:** NorthwindStarterED.accdb  
**Generated:** 2026-05-29 10:38  

## Tables (29)

### Catalog_TableOfContents (16 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| TocTitle | NVARCHAR | NVARCHAR(255) | x | x |
| TocPage | LONG | INT |  | x |

### Companies (13 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| CompanyID | LONG | INT | x |  |
| CompanyName | NVARCHAR | NVARCHAR(50) |  | x |
| CompanyTypeID | LONG | INT |  | x |
| BusinessPhone | NVARCHAR | NVARCHAR(20) |  | x |
| Address | NVARCHAR | NVARCHAR(255) |  | x |
| City | NVARCHAR | NVARCHAR(255) |  | x |
| StateAbbrev | NVARCHAR | NVARCHAR(2) |  | x |
| Zip | NVARCHAR | NVARCHAR(10) |  | x |
| Website | NVARCHAR | NVARCHAR(MAX) |  | x |
| Notes | NVARCHAR | NVARCHAR(MAX) |  | x |
| StandardTaxStatusID | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- CompanyTypeID -> CompanyTypes.CompanyTypeID
- StateAbbrev -> States.StateAbbrev
- StandardTaxStatusID -> TaxStatus.TaxStatusID

### CompanyTypes (4 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| CompanyTypeID | LONG | INT | x |  |
| CompanyType | NVARCHAR | NVARCHAR(50) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### Contacts (6 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ContactID | LONG | INT | x |  |
| CompanyID | LONG | INT |  | x |
| LastName | NVARCHAR | NVARCHAR(30) |  | x |
| FirstName | NVARCHAR | NVARCHAR(20) |  | x |
| EmailAddress | NVARCHAR | NVARCHAR(255) |  | x |
| JobTitle | NVARCHAR | NVARCHAR(50) |  | x |
| PrimaryPhone | NVARCHAR | NVARCHAR(20) |  | x |
| SecondaryPhone | NVARCHAR | NVARCHAR(20) |  | x |
| Notes | NVARCHAR | NVARCHAR(MAX) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- CompanyID -> Companies.CompanyID

### EmployeePrivileges (3 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| EmployeePrivilegeID | LONG | INT | x |  |
| EmployeeID | LONG | INT |  | x |
| PrivilegeID | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- EmployeeID -> Employees.EmployeeID
- PrivilegeID -> Privileges.PrivilegeID

### Employees (10 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| EmployeeID | LONG | INT | x |  |
| FirstName | NVARCHAR | NVARCHAR(20) |  | x |
| LastName | NVARCHAR | NVARCHAR(30) |  | x |
| EmailAddress | NVARCHAR | NVARCHAR(255) |  | x |
| JobTitle | NVARCHAR | NVARCHAR(50) |  | x |
| PrimaryPhone | NVARCHAR | NVARCHAR(20) |  | x |
| SecondaryPhone | NVARCHAR | NVARCHAR(20) |  | x |
| Title | NVARCHAR | NVARCHAR(20) |  | x |
| Notes | NVARCHAR | NVARCHAR(MAX) |  | x |
| Attachments | NVARCHAR | NVARCHAR(MAX) |  | x |
| SupervisorID | LONG | INT |  | x |
| WindowsUserName | NVARCHAR | NVARCHAR(50) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- SupervisorID -> Employees.EmployeeID
- Title -> Titles.Title

### Learn (15 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ID | LONG | INT | x |  |
| SectionNo | LONG | INT |  | x |
| SectionText | NVARCHAR | NVARCHAR(MAX) |  | x |

### MRU (0 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| MRU_ID | LONG | INT | x |  |
| EmployeeID | LONG | INT |  | x |
| TableName | NVARCHAR | NVARCHAR(50) |  | x |
| PKValue | LONG | INT |  | x |
| DateAdded | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- EmployeeID -> Employees.EmployeeID

### NorthwindFeatures (39 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| NorthwindFeaturesID | LONG | INT | x |  |
| ItemName | NVARCHAR | NVARCHAR(255) |  | x |
| Description | NVARCHAR | NVARCHAR(255) |  | x |
| Navigation | NVARCHAR | NVARCHAR(255) |  | x |
| LearnMore | NVARCHAR | NVARCHAR(MAX) |  | x |
| HelpKeywords | NVARCHAR | NVARCHAR(255) |  | x |
| OpenMethod | LONG | INT |  | x |

### OrderDetails (130 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| OrderDetailID | LONG | INT | x |  |
| OrderID | LONG | INT |  | x |
| ProductID | LONG | INT |  | x |
| Quantity | LONG | INT |  | x |
| UnitPrice | DECIMAL | DECIMAL(19,4) |  | x |
| Discount | DOUBLE | FLOAT |  | x |
| OrderDetailStatusID | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- OrderDetailStatusID -> OrderDetailStatus.OrderDetailStatusID
- OrderID -> Orders.OrderID
- ProductID -> Products.ProductID

### OrderDetailStatus (6 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| OrderDetailStatusID | LONG | INT | x |  |
| OrderDetailStatusName | NVARCHAR | NVARCHAR(50) |  | x |
| SortOrder | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### Orders (52 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| OrderID | LONG | INT | x |  |
| EmployeeID | LONG | INT |  | x |
| CustomerID | LONG | INT |  | x |
| OrderDate | DATETIME | DATETIME2 |  | x |
| InvoiceDate | DATETIME | DATETIME2 |  | x |
| ShippedDate | DATETIME | DATETIME2 |  | x |
| ShipperID | LONG | INT |  | x |
| ShippingFee | DECIMAL | DECIMAL(19,4) |  | x |
| TaxRate | DOUBLE | FLOAT |  | x |
| TaxStatusID | LONG | INT |  | x |
| PaymentMethod | NVARCHAR | NVARCHAR(50) |  | x |
| PaidDate | DATETIME | DATETIME2 |  | x |
| Notes | NVARCHAR | NVARCHAR(MAX) |  | x |
| OrderStatusID | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- CustomerID -> Companies.CompanyID
- ShipperID -> Companies.CompanyID
- EmployeeID -> Employees.EmployeeID
- OrderStatusID -> OrderStatus.OrderStatusID
- TaxStatusID -> TaxStatus.TaxStatusID

### OrderStatus (5 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| OrderStatusID | LONG | INT | x |  |
| OrderStatusCode | NVARCHAR | NVARCHAR(5) |  | x |
| OrderStatusName | NVARCHAR | NVARCHAR(50) |  | x |
| SortOrder | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### Privileges (1 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| PrivilegeID | LONG | INT | x |  |
| PrivilegeName | NVARCHAR | NVARCHAR(50) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### ProductCategories (16 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ProductCategoryID | LONG | INT | x |  |
| ProductCategoryName | NVARCHAR | NVARCHAR(255) |  | x |
| ProductCategoryCode | NVARCHAR | NVARCHAR(3) |  | x |
| ProductCategoryDesc | NVARCHAR | NVARCHAR(255) |  | x |
| ProductCategoryImage | NVARCHAR | NVARCHAR(MAX) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### Products (43 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ProductID | LONG | INT | x |  |
| ProductCode | NVARCHAR | NVARCHAR(20) |  | x |
| ProductName | NVARCHAR | NVARCHAR(50) |  | x |
| ProductDescription | NVARCHAR | NVARCHAR(MAX) |  | x |
| StandardUnitCost | DECIMAL | DECIMAL(19,4) |  | x |
| UnitPrice | DECIMAL | DECIMAL(19,4) |  | x |
| ReorderLevel | LONG | INT |  | x |
| TargetLevel | LONG | INT |  | x |
| QuantityPerUnit | NVARCHAR | NVARCHAR(50) |  | x |
| Discontinued | BIT | BIT |  |  |
| MinimumReorderQuantity | LONG | INT |  | x |
| ProductCategoryID | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- ProductCategoryID -> ProductCategories.ProductCategoryID

### ProductVendors (47 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ProductVendorID | LONG | INT | x |  |
| ProductID | LONG | INT |  | x |
| VendorID | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- VendorID -> Companies.CompanyID
- ProductID -> Products.ProductID

### PurchaseOrderDetails (43 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| PurchaseOrderDetailID | LONG | INT | x |  |
| PurchaseOrderID | LONG | INT |  | x |
| ProductID | LONG | INT |  | x |
| Quantity | LONG | INT |  | x |
| UnitCost | DECIMAL | DECIMAL(19,4) |  | x |
| ReceivedDate | DATETIME | DATETIME2 |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- ProductID -> Products.ProductID
- PurchaseOrderID -> PurchaseOrders.PurchaseOrderID

### PurchaseOrders (2 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| PurchaseOrderID | LONG | INT | x |  |
| VendorID | LONG | INT |  | x |
| SubmittedByID | LONG | INT |  | x |
| SubmittedDate | DATETIME | DATETIME2 |  | x |
| ApprovedByID | LONG | INT |  | x |
| ApprovedDate | DATETIME | DATETIME2 |  | x |
| StatusID | LONG | INT |  | x |
| ReceivedDate | DATETIME | DATETIME2 |  | x |
| ShippingFee | DECIMAL | DECIMAL(19,4) |  | x |
| TaxAmount | DECIMAL | DECIMAL(19,4) |  | x |
| PaymentDate | DATETIME | DATETIME2 |  | x |
| PaymentAmount | DECIMAL | DECIMAL(19,4) |  | x |
| PaymentMethod | NVARCHAR | NVARCHAR(50) |  | x |
| Notes | NVARCHAR | NVARCHAR(MAX) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- VendorID -> Companies.CompanyID
- ApprovedByID -> Employees.EmployeeID
- SubmittedByID -> Employees.EmployeeID
- StatusID -> PurchaseOrderStatus.StatusID

### PurchaseOrderStatus (5 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| StatusID | LONG | INT | x |  |
| StatusName | NVARCHAR | NVARCHAR(50) |  | x |
| SortOrder | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### States (51 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| StateAbbrev | NVARCHAR | NVARCHAR(2) | x | x |
| StateName | NVARCHAR | NVARCHAR(50) |  | x |

### StockTake (43 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| StockTakeID | LONG | INT | x |  |
| StockTakeDate | DATETIME | DATETIME2 |  | x |
| ProductID | LONG | INT |  | x |
| QuantityOnHand | LONG | INT |  | x |
| ExpectedQuantity | LONG | INT |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

**Foreign Keys:**

- ProductID -> Products.ProductID

### Strings (49 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| StringID | LONG | INT | x |  |
| StringData | NVARCHAR | NVARCHAR(MAX) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### SystemSettings (5 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| SettingID | LONG | INT | x |  |
| SettingName | NVARCHAR | NVARCHAR(50) |  | x |
| SettingValue | NVARCHAR | NVARCHAR(255) |  | x |
| Notes | NVARCHAR | NVARCHAR(255) |  | x |

### TaxStatus (2 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| TaxStatusID | LONG | INT | x | x |
| TaxStatus | NVARCHAR | NVARCHAR(50) |  | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### Titles (3 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| Title | NVARCHAR | NVARCHAR(20) | x | x |
| AddedBy | NVARCHAR | NVARCHAR(255) |  | x |
| AddedOn | DATETIME | DATETIME2 |  | x |
| ModifiedBy | NVARCHAR | NVARCHAR(255) |  | x |
| ModifiedOn | DATETIME | DATETIME2 |  | x |

### UserSettings (1 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| SettingID | LONG | INT | x |  |
| SettingName | NVARCHAR | NVARCHAR(50) |  | x |
| SettingValue | NVARCHAR | NVARCHAR(255) |  | x |
| Notes | NVARCHAR | NVARCHAR(255) |  | x |

### USysRibbons (1 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ID | LONG | INT | x |  |
| RibbonName | NVARCHAR | NVARCHAR(255) |  | x |
| RibbonXML | NVARCHAR | NVARCHAR(MAX) |  | x |

### Welcome (1 rows)

| Column | Type (Access) | T-SQL Type | PK | Nullable |
|--------|--------------|------------|----|---------|
| ID | LONG | INT | x |  |
| Welcome | NVARCHAR | NVARCHAR(MAX) |  | x |
| Learn | NVARCHAR | NVARCHAR(MAX) |  | x |
| DataMacro | NVARCHAR | NVARCHAR(MAX) |  | x |

## Queries (65)

| Name | Type |
|------|------|
| qrycboCompanyType | SELECT |
| qrycboCustomers | SELECT |
| qrycboEmployees | SELECT |
| qrycboOrderDetailStatus | SELECT |
| qrycboOrderStatus | SELECT |
| qrycboProductCategories | PASS-THROUGH |
| qrycboProductCategory | SELECT |
| qrycboProducts | SELECT |
| qrycboProducts_All | SELECT |
| qrycboProducts_PO | SELECT |
| qrycboShippers | SELECT |
| qrycboStates | SELECT |
| qrycboTaxStatus | SELECT |
| qrycboVendors | SELECT |
| qryCompanies | SELECT |
| qryCompanyList | SELECT |
| qryContacts | SELECT |
| qryCustomerOrderList | SELECT |
| qryCustomers | SELECT |
| qryEmployeeLogin | SELECT |
| qryEmployeePrivileges | SELECT |
| qryEmployees | SELECT |
| qryEmployeeSupervisor | SELECT |
| qryInvoice | SELECT |
| qryMaxStockTakeDate | SELECT |
| qryMRU | SELECT |
| qryOrder | SELECT |
| qryOrderLineItems | SELECT |
| qryOrderList | SELECT |
| qryOrderList_DetailStatus | SELECT |
| qryOrderList_DetailStatus_Lowest | SELECT |
| qryOrders_MostRecent | SELECT |
| qryOrders_MostRecent_Customer | SELECT |
| qryOrders_MostRecent_Employee | SELECT |
| qryOrders_MostRecent_ModifiedOn | SELECT |
| qryOrderTotal | SELECT |
| qryPOProducts_ByStatus | SELECT |
| qryPrivileges | SELECT |
| qryProductCategories | SELECT |
| qryProductDetail | SELECT |
| qryProductList | SELECT |
| qryProductList_Export | SELECT |
| qryProductOrders | SELECT |
| qryProductPurchaseOrder | SELECT |
| qryProductVendors | SELECT |
| qryPurchaseOrder | SELECT |
| qryPurchaseOrderCost | SELECT |
| qryPurchaseOrderLineItems | SELECT |
| qryPurchaseOrderList | SELECT |
| qryrptEmployeeEmailList | SELECT |
| qryrptEmployeePhoneList | SELECT |
| qryrptProductCatalog | SELECT |
| qryrptSalesByEmployee | SELECT |
| qryrptSalesByProduct_ByMonth | SELECT |
| qryrptSalesByProduct_ByQuarter | SELECT |
| qrySales_SalesRep | SELECT |
| qryShipperOrderList | SELECT |
| qryShippers | SELECT |
| qryStockTake | SELECT |
| qryStrings | SELECT |
| qrySystemSettings | SELECT |
| qryTitle | SELECT |
| qryTotalSalesByProduct | SELECT |
| qryVendorPurchaseOrderList | SELECT |
| qryVendors | SELECT |

