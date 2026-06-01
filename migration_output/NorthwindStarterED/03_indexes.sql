-- Indexes

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'TocPage' AND object_id = OBJECT_ID(N'[Catalog_TableOfContents]')
)
    CREATE INDEX [TocPage]
      ON [Catalog_TableOfContents] ([TocPage]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CustomerName' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE UNIQUE INDEX [CustomerName]
      ON [Companies] ([CompanyName], [CompanyTypeID])
  WHERE [CompanyName] IS NOT NULL AND [CompanyTypeID] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompanyTypesCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [CompanyTypesCompanies]
      ON [Companies] ([CompanyTypeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_CompanyTypesCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [New_CompanyTypesCompanies]
      ON [Companies] ([CompanyTypeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_CompanyTypesCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [New_New_CompanyTypesCompanies]
      ON [Companies] ([CompanyTypeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_StatesCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [New_New_StatesCompanies]
      ON [Companies] ([StateAbbrev]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_TaxStatusCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [New_New_TaxStatusCompanies]
      ON [Companies] ([StandardTaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_StatesCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [New_StatesCompanies]
      ON [Companies] ([StateAbbrev]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_TaxStatusCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [New_TaxStatusCompanies]
      ON [Companies] ([StandardTaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatesCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [StatesCompanies]
      ON [Companies] ([StateAbbrev]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'TaxStatusCompanies' AND object_id = OBJECT_ID(N'[Companies]')
)
    CREATE INDEX [TaxStatusCompanies]
      ON [Companies] ([StandardTaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompanyType' AND object_id = OBJECT_ID(N'[CompanyTypes]')
)
    CREATE UNIQUE INDEX [CompanyType]
      ON [CompanyTypes] ([CompanyType])
  WHERE [CompanyType] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'uidxCompanyFNLN' AND object_id = OBJECT_ID(N'[Contacts]')
)
    CREATE UNIQUE INDEX [uidxCompanyFNLN]
      ON [Contacts] ([CompanyID], [FirstName], [LastName])
  WHERE [CompanyID] IS NOT NULL AND [FirstName] IS NOT NULL AND [LastName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'uidxCompanyLNFN' AND object_id = OBJECT_ID(N'[Contacts]')
)
    CREATE UNIQUE INDEX [uidxCompanyLNFN]
      ON [Contacts] ([CompanyID], [LastName], [FirstName])
  WHERE [CompanyID] IS NOT NULL AND [LastName] IS NOT NULL AND [FirstName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompaniesContacts' AND object_id = OBJECT_ID(N'[Contacts]')
)
    CREATE INDEX [CompaniesContacts]
      ON [Contacts] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_CompaniesContacts' AND object_id = OBJECT_ID(N'[Contacts]')
)
    CREATE INDEX [New_CompaniesContacts]
      ON [Contacts] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_CompaniesContacts' AND object_id = OBJECT_ID(N'[Contacts]')
)
    CREATE INDEX [New_New_CompaniesContacts]
      ON [Contacts] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'UniqueIdx' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE UNIQUE INDEX [UniqueIdx]
      ON [EmployeePrivileges] ([EmployeePrivilegeID], [PrivilegeID])
  WHERE [PrivilegeID] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'EmployeesEmployeePrivileges' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [EmployeesEmployeePrivileges]
      ON [EmployeePrivileges] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_EmployeesEmployeePrivileges' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [New_EmployeesEmployeePrivileges]
      ON [EmployeePrivileges] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_EmployeesEmployeePrivileges' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [New_New_EmployeesEmployeePrivileges]
      ON [EmployeePrivileges] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_PrivilegesEmployeePrivileges' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [New_New_PrivilegesEmployeePrivileges]
      ON [EmployeePrivileges] ([PrivilegeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_PrivilegesEmployeePrivileges' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [New_PrivilegesEmployeePrivileges]
      ON [EmployeePrivileges] ([PrivilegeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'PrivilegeID' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [PrivilegeID]
      ON [EmployeePrivileges] ([PrivilegeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'PrivilegesEmployeePrivileges' AND object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    CREATE INDEX [PrivilegesEmployeePrivileges]
      ON [EmployeePrivileges] ([PrivilegeID]);

-- SKIPPED index [Attachments_5A5F6AB72C76468882E4A1BDF472D06A] on [Employees]: column(s) ['Attachments'] have LOB/MAX type, not valid as index key in T-SQL

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'uidxFNLN' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE UNIQUE INDEX [uidxFNLN]
      ON [Employees] ([FirstName], [LastName])
  WHERE [FirstName] IS NOT NULL AND [LastName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'uidxLNFN' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE UNIQUE INDEX [uidxLNFN]
      ON [Employees] ([LastName], [FirstName])
  WHERE [LastName] IS NOT NULL AND [FirstName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'WindowsUserName' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE UNIQUE INDEX [WindowsUserName]
      ON [Employees] ([WindowsUserName])
  WHERE [WindowsUserName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'EmployeesEmployees' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE INDEX [EmployeesEmployees]
      ON [Employees] ([SupervisorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_EmployeesEmployees' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE INDEX [New_EmployeesEmployees]
      ON [Employees] ([SupervisorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_EmployeesEmployees' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE INDEX [New_New_EmployeesEmployees]
      ON [Employees] ([SupervisorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_SalutationsEmployees' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE INDEX [New_New_SalutationsEmployees]
      ON [Employees] ([Title]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_SalutationsEmployees' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE INDEX [New_SalutationsEmployees]
      ON [Employees] ([Title]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SalutationsEmployees' AND object_id = OBJECT_ID(N'[Employees]')
)
    CREATE INDEX [SalutationsEmployees]
      ON [Employees] ([Title]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SectionNo' AND object_id = OBJECT_ID(N'[Learn]')
)
    CREATE UNIQUE INDEX [SectionNo]
      ON [Learn] ([SectionNo])
  WHERE [SectionNo] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SortIdx' AND object_id = OBJECT_ID(N'[MRU]')
)
    CREATE UNIQUE INDEX [SortIdx]
      ON [MRU] ([EmployeeID], [DateAdded])
  WHERE [EmployeeID] IS NOT NULL AND [DateAdded] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'UniqueIdx' AND object_id = OBJECT_ID(N'[MRU]')
)
    CREATE UNIQUE INDEX [UniqueIdx]
      ON [MRU] ([EmployeeID], [TableName], [PKValue])
  WHERE [EmployeeID] IS NOT NULL AND [TableName] IS NOT NULL AND [PKValue] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'EmployeesMRU' AND object_id = OBJECT_ID(N'[MRU]')
)
    CREATE INDEX [EmployeesMRU]
      ON [MRU] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_EmployeesMRU' AND object_id = OBJECT_ID(N'[MRU]')
)
    CREATE INDEX [New_EmployeesMRU]
      ON [MRU] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_EmployeesMRU' AND object_id = OBJECT_ID(N'[MRU]')
)
    CREATE INDEX [New_New_EmployeesMRU]
      ON [MRU] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'uidxOrderID_ProductID' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE UNIQUE INDEX [uidxOrderID_ProductID]
      ON [OrderDetails] ([OrderID], [ProductID])
  WHERE [OrderID] IS NOT NULL AND [ProductID] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_OrderDetailsStatusOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [New_New_OrderDetailsStatusOrderDetails]
      ON [OrderDetails] ([OrderDetailStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_OrdersOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [New_New_OrdersOrderDetails]
      ON [OrderDetails] ([OrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_ProductsOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [New_New_ProductsOrderDetails]
      ON [OrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_OrderDetailsStatusOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [New_OrderDetailsStatusOrderDetails]
      ON [OrderDetails] ([OrderDetailStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_OrdersOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [New_OrdersOrderDetails]
      ON [OrderDetails] ([OrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_ProductsOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [New_ProductsOrderDetails]
      ON [OrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'OrderDetailsStatusOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [OrderDetailsStatusOrderDetails]
      ON [OrderDetails] ([OrderDetailStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'OrdersOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [OrdersOrderDetails]
      ON [OrderDetails] ([OrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductID' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [ProductID]
      ON [OrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductsOrderDetails' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [ProductsOrderDetails]
      ON [OrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatusID' AND object_id = OBJECT_ID(N'[OrderDetails]')
)
    CREATE INDEX [StatusID]
      ON [OrderDetails] ([OrderDetailStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SortOrder' AND object_id = OBJECT_ID(N'[OrderDetailStatus]')
)
    CREATE UNIQUE INDEX [SortOrder]
      ON [OrderDetailStatus] ([SortOrder])
  WHERE [SortOrder] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatusName' AND object_id = OBJECT_ID(N'[OrderDetailStatus]')
)
    CREATE UNIQUE INDEX [StatusName]
      ON [OrderDetailStatus] ([OrderDetailStatusName])
  WHERE [OrderDetailStatusName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompaniesOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [CompaniesOrders]
      ON [Orders] ([CustomerID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompaniesOrders1' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [CompaniesOrders1]
      ON [Orders] ([ShipperID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'EmployeesOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [EmployeesOrders]
      ON [Orders] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_CompaniesOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_CompaniesOrders]
      ON [Orders] ([CustomerID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_CompaniesOrders1' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_CompaniesOrders1]
      ON [Orders] ([ShipperID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_EmployeesOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_EmployeesOrders]
      ON [Orders] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_CompaniesOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_New_CompaniesOrders]
      ON [Orders] ([CustomerID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_CompaniesOrders1' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_New_CompaniesOrders1]
      ON [Orders] ([ShipperID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_EmployeesOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_New_EmployeesOrders]
      ON [Orders] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_OrdersStatusOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_New_OrdersStatusOrders]
      ON [Orders] ([OrderStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_TaxStatusOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_New_TaxStatusOrders]
      ON [Orders] ([TaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_OrdersStatusOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_OrdersStatusOrders]
      ON [Orders] ([OrderStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_TaxStatusOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [New_TaxStatusOrders]
      ON [Orders] ([TaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'OrderDate' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [OrderDate]
      ON [Orders] ([OrderDate]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'OrdersStatusOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [OrdersStatusOrders]
      ON [Orders] ([OrderStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'TaxStatusOrders' AND object_id = OBJECT_ID(N'[Orders]')
)
    CREATE INDEX [TaxStatusOrders]
      ON [Orders] ([TaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SortOrder' AND object_id = OBJECT_ID(N'[OrderStatus]')
)
    CREATE UNIQUE INDEX [SortOrder]
      ON [OrderStatus] ([SortOrder])
  WHERE [SortOrder] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatusCode' AND object_id = OBJECT_ID(N'[OrderStatus]')
)
    CREATE UNIQUE INDEX [StatusCode]
      ON [OrderStatus] ([OrderStatusCode])
  WHERE [OrderStatusCode] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatusName' AND object_id = OBJECT_ID(N'[OrderStatus]')
)
    CREATE UNIQUE INDEX [StatusName]
      ON [OrderStatus] ([OrderStatusName])
  WHERE [OrderStatusName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'PrivilegeName' AND object_id = OBJECT_ID(N'[Privileges]')
)
    CREATE UNIQUE INDEX [PrivilegeName]
      ON [Privileges] ([PrivilegeName])
  WHERE [PrivilegeName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductCategory' AND object_id = OBJECT_ID(N'[ProductCategories]')
)
    CREATE UNIQUE INDEX [ProductCategory]
      ON [ProductCategories] ([ProductCategoryName])
  WHERE [ProductCategoryName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductCategoryCode' AND object_id = OBJECT_ID(N'[ProductCategories]')
)
    CREATE UNIQUE INDEX [ProductCategoryCode]
      ON [ProductCategories] ([ProductCategoryCode])
  WHERE [ProductCategoryCode] IS NOT NULL;

-- SKIPPED index [ProductCategoryImage_F6818764AA5B4B19AB7CBDCA5E637AA4] on [ProductCategories]: column(s) ['ProductCategoryImage'] have LOB/MAX type, not valid as index key in T-SQL

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductCode' AND object_id = OBJECT_ID(N'[Products]')
)
    CREATE UNIQUE INDEX [ProductCode]
      ON [Products] ([ProductCode])
  WHERE [ProductCode] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductName' AND object_id = OBJECT_ID(N'[Products]')
)
    CREATE UNIQUE INDEX [ProductName]
      ON [Products] ([ProductName])
  WHERE [ProductName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_ProductCategories_NEWProducts' AND object_id = OBJECT_ID(N'[Products]')
)
    CREATE INDEX [New_New_ProductCategories_NEWProducts]
      ON [Products] ([ProductCategoryID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_ProductCategories_NEWProducts' AND object_id = OBJECT_ID(N'[Products]')
)
    CREATE INDEX [New_ProductCategories_NEWProducts]
      ON [Products] ([ProductCategoryID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductCategories_NEWProducts' AND object_id = OBJECT_ID(N'[Products]')
)
    CREATE INDEX [ProductCategories_NEWProducts]
      ON [Products] ([ProductCategoryID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'UniqueIdx' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE UNIQUE INDEX [UniqueIdx]
      ON [ProductVendors] ([ProductID], [VendorID])
  WHERE [ProductID] IS NOT NULL AND [VendorID] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompaniesProductVendors' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [CompaniesProductVendors]
      ON [ProductVendors] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_CompaniesProductVendors' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [New_CompaniesProductVendors]
      ON [ProductVendors] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_CompaniesProductVendors' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [New_New_CompaniesProductVendors]
      ON [ProductVendors] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_ProductsProductVendors' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [New_New_ProductsProductVendors]
      ON [ProductVendors] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_ProductsProductVendors' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [New_ProductsProductVendors]
      ON [ProductVendors] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductsProductVendors' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [ProductsProductVendors]
      ON [ProductVendors] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'VendorID' AND object_id = OBJECT_ID(N'[ProductVendors]')
)
    CREATE INDEX [VendorID]
      ON [ProductVendors] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'uidxPurchaseOrderID_ProductID' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE UNIQUE INDEX [uidxPurchaseOrderID_ProductID]
      ON [PurchaseOrderDetails] ([PurchaseOrderID], [ProductID])
  WHERE [PurchaseOrderID] IS NOT NULL AND [ProductID] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_ProductsPurchaseOrderDetails' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE INDEX [New_New_ProductsPurchaseOrderDetails]
      ON [PurchaseOrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_PurchaseOrdersPurchaseOrderDetails' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE INDEX [New_New_PurchaseOrdersPurchaseOrderDetails]
      ON [PurchaseOrderDetails] ([PurchaseOrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_ProductsPurchaseOrderDetails' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE INDEX [New_ProductsPurchaseOrderDetails]
      ON [PurchaseOrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_PurchaseOrdersPurchaseOrderDetails' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE INDEX [New_PurchaseOrdersPurchaseOrderDetails]
      ON [PurchaseOrderDetails] ([PurchaseOrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductsPurchaseOrderDetails' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE INDEX [ProductsPurchaseOrderDetails]
      ON [PurchaseOrderDetails] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'PurchaseOrdersPurchaseOrderDetails' AND object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    CREATE INDEX [PurchaseOrdersPurchaseOrderDetails]
      ON [PurchaseOrderDetails] ([PurchaseOrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'CompaniesPurchaseOrders' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [CompaniesPurchaseOrders]
      ON [PurchaseOrders] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'EmployeesPurchaseOrders1' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [EmployeesPurchaseOrders1]
      ON [PurchaseOrders] ([ApprovedByID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'EmployeesPurchaseOrders2' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [EmployeesPurchaseOrders2]
      ON [PurchaseOrders] ([SubmittedByID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_CompaniesPurchaseOrders' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_CompaniesPurchaseOrders]
      ON [PurchaseOrders] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_EmployeesPurchaseOrders1' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_EmployeesPurchaseOrders1]
      ON [PurchaseOrders] ([ApprovedByID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_EmployeesPurchaseOrders2' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_EmployeesPurchaseOrders2]
      ON [PurchaseOrders] ([SubmittedByID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_CompaniesPurchaseOrders' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_New_CompaniesPurchaseOrders]
      ON [PurchaseOrders] ([VendorID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_EmployeesPurchaseOrders1' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_New_EmployeesPurchaseOrders1]
      ON [PurchaseOrders] ([ApprovedByID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_EmployeesPurchaseOrders2' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_New_EmployeesPurchaseOrders2]
      ON [PurchaseOrders] ([SubmittedByID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_PurchaseOrdersStatusPurchaseOrders' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_New_PurchaseOrdersStatusPurchaseOrders]
      ON [PurchaseOrders] ([StatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_PurchaseOrdersStatusPurchaseOrders' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [New_PurchaseOrdersStatusPurchaseOrders]
      ON [PurchaseOrders] ([StatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'PurchaseOrdersStatusPurchaseOrders' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [PurchaseOrdersStatusPurchaseOrders]
      ON [PurchaseOrders] ([StatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatusCode' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [StatusCode]
      ON [PurchaseOrders] ([StatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SubmittedDate' AND object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    CREATE INDEX [SubmittedDate]
      ON [PurchaseOrders] ([SubmittedDate]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SortOrder' AND object_id = OBJECT_ID(N'[PurchaseOrderStatus]')
)
    CREATE UNIQUE INDEX [SortOrder]
      ON [PurchaseOrderStatus] ([SortOrder])
  WHERE [SortOrder] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StatusName' AND object_id = OBJECT_ID(N'[PurchaseOrderStatus]')
)
    CREATE UNIQUE INDEX [StatusName]
      ON [PurchaseOrderStatus] ([StatusName])
  WHERE [StatusName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'StateName' AND object_id = OBJECT_ID(N'[States]')
)
    CREATE UNIQUE INDEX [StateName]
      ON [States] ([StateName])
  WHERE [StateName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_New_ProductsStockTake' AND object_id = OBJECT_ID(N'[StockTake]')
)
    CREATE INDEX [New_New_ProductsStockTake]
      ON [StockTake] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'New_ProductsStockTake' AND object_id = OBJECT_ID(N'[StockTake]')
)
    CREATE INDEX [New_ProductsStockTake]
      ON [StockTake] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'ProductsStockTake' AND object_id = OBJECT_ID(N'[StockTake]')
)
    CREATE INDEX [ProductsStockTake]
      ON [StockTake] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SettingName' AND object_id = OBJECT_ID(N'[SystemSettings]')
)
    CREATE UNIQUE INDEX [SettingName]
      ON [SystemSettings] ([SettingName])
  WHERE [SettingName] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'TaxStatus' AND object_id = OBJECT_ID(N'[TaxStatus]')
)
    CREATE UNIQUE INDEX [TaxStatus]
      ON [TaxStatus] ([TaxStatus])
  WHERE [TaxStatus] IS NOT NULL;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'SettingName' AND object_id = OBJECT_ID(N'[UserSettings]')
)
    CREATE UNIQUE INDEX [SettingName]
      ON [UserSettings] ([SettingName])
  WHERE [SettingName] IS NOT NULL;