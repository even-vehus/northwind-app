-- Foreign Key Constraints

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_CompanyTypesCompanies' AND parent_object_id = OBJECT_ID(N'[Companies]')
)
    ALTER TABLE [Companies]
      ADD CONSTRAINT [New_New_CompanyTypesCompanies]
      FOREIGN KEY ([CompanyTypeID])
      REFERENCES [CompanyTypes] ([CompanyTypeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_StatesCompanies' AND parent_object_id = OBJECT_ID(N'[Companies]')
)
    ALTER TABLE [Companies]
      ADD CONSTRAINT [New_New_StatesCompanies]
      FOREIGN KEY ([StateAbbrev])
      REFERENCES [States] ([StateAbbrev]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_TaxStatusCompanies' AND parent_object_id = OBJECT_ID(N'[Companies]')
)
    ALTER TABLE [Companies]
      ADD CONSTRAINT [New_New_TaxStatusCompanies]
      FOREIGN KEY ([StandardTaxStatusID])
      REFERENCES [TaxStatus] ([TaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_CompaniesContacts' AND parent_object_id = OBJECT_ID(N'[Contacts]')
)
    ALTER TABLE [Contacts]
      ADD CONSTRAINT [New_New_CompaniesContacts]
      FOREIGN KEY ([CompanyID])
      REFERENCES [Companies] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_EmployeesEmployeePrivileges' AND parent_object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    ALTER TABLE [EmployeePrivileges]
      ADD CONSTRAINT [New_New_EmployeesEmployeePrivileges]
      FOREIGN KEY ([EmployeeID])
      REFERENCES [Employees] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_PrivilegesEmployeePrivileges' AND parent_object_id = OBJECT_ID(N'[EmployeePrivileges]')
)
    ALTER TABLE [EmployeePrivileges]
      ADD CONSTRAINT [New_New_PrivilegesEmployeePrivileges]
      FOREIGN KEY ([PrivilegeID])
      REFERENCES [Privileges] ([PrivilegeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_EmployeesEmployees' AND parent_object_id = OBJECT_ID(N'[Employees]')
)
    ALTER TABLE [Employees]
      ADD CONSTRAINT [New_New_EmployeesEmployees]
      FOREIGN KEY ([SupervisorID])
      REFERENCES [Employees] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_SalutationsEmployees' AND parent_object_id = OBJECT_ID(N'[Employees]')
)
    ALTER TABLE [Employees]
      ADD CONSTRAINT [New_New_SalutationsEmployees]
      FOREIGN KEY ([Title])
      REFERENCES [Titles] ([Title]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_EmployeesMRU' AND parent_object_id = OBJECT_ID(N'[MRU]')
)
    ALTER TABLE [MRU]
      ADD CONSTRAINT [New_New_EmployeesMRU]
      FOREIGN KEY ([EmployeeID])
      REFERENCES [Employees] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_OrderDetailsStatusOrderDetails' AND parent_object_id = OBJECT_ID(N'[OrderDetails]')
)
    ALTER TABLE [OrderDetails]
      ADD CONSTRAINT [New_New_OrderDetailsStatusOrderDetails]
      FOREIGN KEY ([OrderDetailStatusID])
      REFERENCES [OrderDetailStatus] ([OrderDetailStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_OrdersOrderDetails' AND parent_object_id = OBJECT_ID(N'[OrderDetails]')
)
    ALTER TABLE [OrderDetails]
      ADD CONSTRAINT [New_New_OrdersOrderDetails]
      FOREIGN KEY ([OrderID])
      REFERENCES [Orders] ([OrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_ProductsOrderDetails' AND parent_object_id = OBJECT_ID(N'[OrderDetails]')
)
    ALTER TABLE [OrderDetails]
      ADD CONSTRAINT [New_New_ProductsOrderDetails]
      FOREIGN KEY ([ProductID])
      REFERENCES [Products] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_CompaniesOrders' AND parent_object_id = OBJECT_ID(N'[Orders]')
)
    ALTER TABLE [Orders]
      ADD CONSTRAINT [New_New_CompaniesOrders]
      FOREIGN KEY ([CustomerID])
      REFERENCES [Companies] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_CompaniesOrders1' AND parent_object_id = OBJECT_ID(N'[Orders]')
)
    ALTER TABLE [Orders]
      ADD CONSTRAINT [New_New_CompaniesOrders1]
      FOREIGN KEY ([ShipperID])
      REFERENCES [Companies] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_EmployeesOrders' AND parent_object_id = OBJECT_ID(N'[Orders]')
)
    ALTER TABLE [Orders]
      ADD CONSTRAINT [New_New_EmployeesOrders]
      FOREIGN KEY ([EmployeeID])
      REFERENCES [Employees] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_OrdersStatusOrders' AND parent_object_id = OBJECT_ID(N'[Orders]')
)
    ALTER TABLE [Orders]
      ADD CONSTRAINT [New_New_OrdersStatusOrders]
      FOREIGN KEY ([OrderStatusID])
      REFERENCES [OrderStatus] ([OrderStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_TaxStatusOrders' AND parent_object_id = OBJECT_ID(N'[Orders]')
)
    ALTER TABLE [Orders]
      ADD CONSTRAINT [New_New_TaxStatusOrders]
      FOREIGN KEY ([TaxStatusID])
      REFERENCES [TaxStatus] ([TaxStatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_ProductCategories_NEWProducts' AND parent_object_id = OBJECT_ID(N'[Products]')
)
    ALTER TABLE [Products]
      ADD CONSTRAINT [New_New_ProductCategories_NEWProducts]
      FOREIGN KEY ([ProductCategoryID])
      REFERENCES [ProductCategories] ([ProductCategoryID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_CompaniesProductVendors' AND parent_object_id = OBJECT_ID(N'[ProductVendors]')
)
    ALTER TABLE [ProductVendors]
      ADD CONSTRAINT [New_New_CompaniesProductVendors]
      FOREIGN KEY ([VendorID])
      REFERENCES [Companies] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_ProductsProductVendors' AND parent_object_id = OBJECT_ID(N'[ProductVendors]')
)
    ALTER TABLE [ProductVendors]
      ADD CONSTRAINT [New_New_ProductsProductVendors]
      FOREIGN KEY ([ProductID])
      REFERENCES [Products] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_ProductsPurchaseOrderDetails' AND parent_object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    ALTER TABLE [PurchaseOrderDetails]
      ADD CONSTRAINT [New_New_ProductsPurchaseOrderDetails]
      FOREIGN KEY ([ProductID])
      REFERENCES [Products] ([ProductID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_PurchaseOrdersPurchaseOrderDetails' AND parent_object_id = OBJECT_ID(N'[PurchaseOrderDetails]')
)
    ALTER TABLE [PurchaseOrderDetails]
      ADD CONSTRAINT [New_New_PurchaseOrdersPurchaseOrderDetails]
      FOREIGN KEY ([PurchaseOrderID])
      REFERENCES [PurchaseOrders] ([PurchaseOrderID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_CompaniesPurchaseOrders' AND parent_object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    ALTER TABLE [PurchaseOrders]
      ADD CONSTRAINT [New_New_CompaniesPurchaseOrders]
      FOREIGN KEY ([VendorID])
      REFERENCES [Companies] ([CompanyID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_EmployeesPurchaseOrders1' AND parent_object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    ALTER TABLE [PurchaseOrders]
      ADD CONSTRAINT [New_New_EmployeesPurchaseOrders1]
      FOREIGN KEY ([ApprovedByID])
      REFERENCES [Employees] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_EmployeesPurchaseOrders2' AND parent_object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    ALTER TABLE [PurchaseOrders]
      ADD CONSTRAINT [New_New_EmployeesPurchaseOrders2]
      FOREIGN KEY ([SubmittedByID])
      REFERENCES [Employees] ([EmployeeID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_PurchaseOrdersStatusPurchaseOrders' AND parent_object_id = OBJECT_ID(N'[PurchaseOrders]')
)
    ALTER TABLE [PurchaseOrders]
      ADD CONSTRAINT [New_New_PurchaseOrdersStatusPurchaseOrders]
      FOREIGN KEY ([StatusID])
      REFERENCES [PurchaseOrderStatus] ([StatusID]);

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'New_New_ProductsStockTake' AND parent_object_id = OBJECT_ID(N'[StockTake]')
)
    ALTER TABLE [StockTake]
      ADD CONSTRAINT [New_New_ProductsStockTake]
      FOREIGN KEY ([ProductID])
      REFERENCES [Products] ([ProductID]);