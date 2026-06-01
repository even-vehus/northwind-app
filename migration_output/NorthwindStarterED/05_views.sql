-- Saved Queries exported as Views
-- Source: Access saved SELECT/UNION queries
-- Access SQL automatically converted to T-SQL.
-- Views referencing Access form controls are commented out below.

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboCompanyType] AS
SELECT CompanyTypes.CompanyTypeID, CompanyTypes.CompanyType
FROM CompanyTypes;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboCustomers] AS
SELECT Companies.CompanyID, Companies.CompanyName
FROM Companies
WHERE (((Companies.CompanyTypeID)=1));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboOrderDetailStatus] AS
SELECT OrderDetailStatus.OrderDetailStatusID, OrderDetailStatus.OrderDetailStatusName
FROM OrderDetailStatus;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboOrderStatus] AS
SELECT OrderStatus.OrderStatusID, OrderStatus.OrderStatusName
FROM OrderStatus;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboProductCategory] AS
SELECT ProductCategories.ProductCategoryID, ProductCategories.ProductCategoryName
FROM ProductCategories;
GO

-- SKIPPED: qrycboProducts
-- Reason: references Access form controls — cannot be a SQL view.
-- Convert manually to a stored procedure or parameterised query.
-- Original Access SQL:
/*
SELECT Products.ProductID, Products.ProductName, Products.UnitPrice, Products.ProductCategoryID
FROM Products
WHERE (((Products.ProductCategoryID)=[Form]![cboProductCategories]))
ORDER BY Products.ProductName;
*/

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboProducts_All] AS
SELECT Products.ProductID, Products.ProductName, Products.UnitPrice, Products.ProductCategoryID
FROM Products;
GO

-- SKIPPED: qrycboProducts_PO
-- Reason: references Access form controls — cannot be a SQL view.
-- Convert manually to a stored procedure or parameterised query.
-- Original Access SQL:
/*
SELECT Products.ProductID, Products.ProductName, Products.StandardUnitCost
FROM Products INNER JOIN ProductVendors ON Products.ProductID = ProductVendors.ProductID
WHERE (((ProductVendors.VendorID)=[Parent]![VendorID]))
ORDER BY Products.ProductName;
*/

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboShippers] AS
SELECT Companies.CompanyID, Companies.CompanyName
FROM Companies
WHERE (((Companies.CompanyTypeID)=2));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboStates] AS
SELECT States.StateAbbrev, States.StateName
FROM States;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboTaxStatus] AS
SELECT TaxStatus.TaxStatusID, TaxStatus.TaxStatus
FROM TaxStatus;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboVendors] AS
SELECT Companies.CompanyID, Companies.CompanyName
FROM Companies
WHERE (((Companies.CompanyTypeID)=3));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryCompanies] AS
SELECT Companies.*, [Address]  +  Space(2)  +  [City]  +  ', '  +  [StateAbbrev]  +  Space(2)  +  [Zip] AS BusinessAddress
FROM Companies;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryCompanyList] AS
SELECT Companies.CompanyID, Companies.CompanyName, CompanyTypes.CompanyType, Companies.BusinessPhone, Companies.Address, Companies.City, Companies.StateAbbrev, Companies.Zip, Companies.Website, Companies.Notes, TaxStatus.TaxStatus, Companies.AddedBy, Companies.AddedOn, Companies.ModifiedBy, Companies.ModifiedOn, [Address]  +  Space(2)  +  [City]  +  ', '  +  [StateAbbrev]  +  Space(2)  +  [Zip] AS BusinessAddress, Companies.CompanyTypeID, Companies.StandardTaxStatusID
FROM TaxStatus INNER JOIN (CompanyTypes INNER JOIN Companies ON CompanyTypes.CompanyTypeID = Companies.CompanyTypeID) ON TaxStatus.TaxStatusID = Companies.StandardTaxStatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryContacts] AS
SELECT Contacts.*
FROM Contacts;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryCustomers] AS
SELECT Companies.*
FROM Companies
WHERE (((Companies.CompanyTypeID)=1));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryEmployeePrivileges] AS
SELECT EmployeePrivileges.*
FROM Employees INNER JOIN EmployeePrivileges ON Employees.EmployeeID = EmployeePrivileges.EmployeeID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryEmployees] AS
SELECT Employees.*, [FirstName]  +  ' '  +  [LastName] AS FullNameFNLN, [LastName]  +  ', '  +  [FirstName] AS FullNameLNFN
FROM Employees;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryMaxStockTakeDate] AS
SELECT StockTake.ProductID, Max(StockTake.StockTakeDate) AS MaxOfStockTakeDate
FROM StockTake
GROUP BY StockTake.ProductID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryMRU] AS
SELECT MRU.*
FROM MRU
WHERE (((MRU.EmployeeID)=Get_UserID()));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrder] AS
SELECT Orders.*, OrderStatus.OrderStatusName
FROM OrderStatus INNER JOIN Orders ON OrderStatus.OrderStatusID = Orders.OrderStatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrderLineItems] AS
SELECT OrderDetails.*, Products.ProductName, Products.ProductCategoryID, ProductCategories.ProductCategoryName
FROM (ProductCategories INNER JOIN Products ON ProductCategories.ProductCategoryID = Products.ProductCategoryID) INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrderList_DetailStatus_Lowest] AS
SELECT OrderDetails.OrderID, Min(OrderDetailStatus.SortOrder) AS MinOfSortOrder
FROM OrderDetailStatus INNER JOIN OrderDetails ON OrderDetailStatus.OrderDetailStatusID = OrderDetails.OrderDetailStatusID
GROUP BY OrderDetails.OrderID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrderTotal] AS
SELECT Orders.OrderID, Sum([Quantity]*(1-[Discount])*[UnitPrice]) AS OrderTotal
FROM Orders LEFT JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.OrderID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryPOProducts_ByStatus] AS
SELECT PurchaseOrders.StatusID, PurchaseOrderDetails.ProductID, Sum(PurchaseOrderDetails.Quantity) AS Quantity
FROM PurchaseOrders INNER JOIN PurchaseOrderDetails ON PurchaseOrders.PurchaseOrderID = PurchaseOrderDetails.PurchaseOrderID
GROUP BY PurchaseOrders.StatusID, PurchaseOrderDetails.ProductID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryPrivileges] AS
SELECT Privileges.PrivilegeID, Privileges.PrivilegeName
FROM [Privileges];
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductCategories] AS
SELECT ProductCategories.ProductCategoryID, ProductCategories.ProductCategoryName, ProductCategories.ProductCategoryCode, ProductCategories.ProductCategoryDesc, ProductCategories.ProductCategoryImage, ProductCategories.AddedBy, ProductCategories.AddedOn, ProductCategories.ModifiedBy, ProductCategories.ModifiedOn
FROM ProductCategories;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductDetail] AS
SELECT Products.ProductID, Products.ProductCode, Products.ProductName, Products.ProductDescription, Products.StandardUnitCost, Products.UnitPrice, Products.ReorderLevel, Products.TargetLevel, Products.QuantityPerUnit, Products.Discontinued, Products.MinimumReorderQuantity, Products.ProductCategoryID, Products.AddedBy, Products.AddedOn, Products.ModifiedBy, Products.ModifiedOn
FROM Products;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductList] AS
SELECT Products.ProductID, ProductCategories.ProductCategoryName, Products.ProductCode, Products.ProductName, Products.ProductDescription, Products.StandardUnitCost, ProductNoStock([Products].[ProductID]) AS NoStock, ProductAllocated([Products].[ProductID]) AS Allocated, ProductToSell([Products].[ProductID]) AS ToSell, ProductOnOrder([Products].[ProductID]) AS QuantityOnOrder, Products.MinimumReorderQuantity, Products.UnitPrice, Products.ReorderLevel, Products.TargetLevel, Products.QuantityPerUnit, Products.Discontinued, Products.ProductCategoryID, Products.AddedBy, Products.AddedOn, Products.ModifiedBy, Products.ModifiedOn
FROM ProductCategories INNER JOIN Products ON ProductCategories.ProductCategoryID = Products.ProductCategoryID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductList_Export] AS
SELECT Products.ProductID AS [Product ID], Products.ProductCode AS [Product Code], Products.ProductName AS Product, CDbl(ProductAllocated([Products].[ProductID])) AS [Allocated Inventory], ProductToSell([Products].[ProductID]) AS [Inventory To Sell], ProductOnOrder([Products].[ProductID]) AS [Qty On Order], Products.ReorderLevel AS [Reorder Level], Products.TargetLevel AS [Target Level], Products.MinimumReorderQuantity AS [Min Reorder Qty], Products.Discontinued
FROM Products;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductOrders] AS
SELECT OrderDetails.OrderID, OrderDetails.ProductID, Orders.OrderDate, OrderDetails.Quantity, OrderDetails.UnitPrice, [OrderDetails].[Quantity]*[OrderDetails].[UnitPrice] AS ExtendedPrice, OrderStatus.OrderStatusName AS OrderStatus, OrderDetailStatus.OrderDetailStatusName AS ProductStatus
FROM Products INNER JOIN (OrderStatus INNER JOIN (Orders INNER JOIN (OrderDetailStatus INNER JOIN OrderDetails ON OrderDetailStatus.OrderDetailStatusID = OrderDetails.OrderDetailStatusID) ON Orders.OrderID = OrderDetails.OrderID) ON OrderStatus.OrderStatusID = Orders.OrderStatusID) ON Products.ProductID = OrderDetails.ProductID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductPurchaseOrder] AS
SELECT Products.ProductID, PurchaseOrderDetails.PurchaseOrderID, PurchaseOrderStatus.StatusID, PurchaseOrderStatus.StatusName, PurchaseOrderStatus.SortOrder, PurchaseOrderDetails.Quantity, PurchaseOrderDetails.UnitCost, [Quantity]*[UnitCost] AS ExtendedCost, Companies.CompanyName, PurchaseOrders.SubmittedDate, PurchaseOrderDetails.ReceivedDate
FROM PurchaseOrderStatus RIGHT JOIN ((Companies INNER JOIN PurchaseOrders ON Companies.CompanyID = PurchaseOrders.VendorID) INNER JOIN (Products INNER JOIN PurchaseOrderDetails ON Products.ProductID = PurchaseOrderDetails.ProductID) ON PurchaseOrders.PurchaseOrderID = PurchaseOrderDetails.PurchaseOrderID) ON PurchaseOrderStatus.StatusID = PurchaseOrders.StatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryProductVendors] AS
SELECT ProductVendors.ProductVendorID, ProductVendors.ProductID, ProductVendors.VendorID, ProductVendors.AddedBy, ProductVendors.AddedOn, ProductVendors.ModifiedBy, ProductVendors.ModifiedOn
FROM ProductVendors;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryPurchaseOrderCost] AS
SELECT PurchaseOrders.PurchaseOrderID, Sum([Quantity]*[UnitCost]) AS ExtendedCost
FROM PurchaseOrders LEFT JOIN PurchaseOrderDetails ON PurchaseOrders.PurchaseOrderID = PurchaseOrderDetails.PurchaseOrderID
GROUP BY PurchaseOrders.PurchaseOrderID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryPurchaseOrderLineItems] AS
SELECT PurchaseOrderDetails.*
FROM PurchaseOrderDetails;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryrptEmployeeEmailList] AS
SELECT Employees.EmployeeID, [Employees].[FirstName]  +  ' '  +  [Employees].[LastName] AS FullNameFNLN, Employees.EmailAddress
FROM Employees;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryrptEmployeePhoneList] AS
SELECT Employees.EmployeeID, [employees].[FirstName]  +  ' '  +  [employees].[LastName] AS FullNameFNLN, Employees.PrimaryPhone, Employees.SecondaryPhone, Left([FirstName],1) AS EmailGroup
FROM Employees;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryrptSalesByProduct_ByMonth] AS
SELECT Products.ProductName, Products.ProductID, FORMAT([OrderDate], 'MMM-yyyy') AS MonthYear, FORMAT([OrderDate], 'yyyy-MM') AS MonthYearSort, Sum([OrderDetails].[Quantity]*(1-[OrderDetails].[Discount])*[OrderDetails].[UnitPrice]) AS OrderTotal
FROM Products INNER JOIN (Orders INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID) ON Products.ProductID = OrderDetails.ProductID
WHERE (((Orders.OrderDate) Between reportParameterStartDate() And reportParameterEndDate()))
GROUP BY Products.ProductName, Products.ProductID, FORMAT([OrderDate], 'MMM-yyyy'), FORMAT([OrderDate], 'yyyy-MM');
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryrptSalesByProduct_ByQuarter] AS
SELECT Products.ProductName, Products.ProductID, (CAST(DATEPART(quarter, [OrderDate]) AS VARCHAR) + '-' + FORMAT([OrderDate], 'yyyy')) AS QuarterYear, Sum([OrderDetails].[Quantity]*(1-[OrderDetails].[Discount])*[OrderDetails].[UnitPrice]) AS OrderTotal
FROM Products INNER JOIN (Orders INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID) ON Products.ProductID = OrderDetails.ProductID
WHERE (((Orders.OrderDate) Between reportParameterStartDate() And reportParameterEndDate()))
GROUP BY Products.ProductName, Products.ProductID, (CAST(DATEPART(quarter, [OrderDate]) AS VARCHAR) + '-' + FORMAT([OrderDate], 'yyyy'));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrySales_SalesRep] AS
SELECT Sum([Quantity]*[UnitPrice]) AS OrderTotal, Employees.FullNameFNLN AS Expr1
FROM (Employees INNER JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID) INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE (((Year([OrderDate]))=Year(CAST(GETDATE() AS DATE))))
GROUP BY Employees.FullNameFNLN;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryShippers] AS
SELECT Companies.*
FROM Companies
WHERE (((Companies.CompanyTypeID)=2));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryStockTake] AS
SELECT StockTake.StockTakeID, StockTake.StockTakeDate, StockTake.ProductID, StockTake.QuantityOnHand, StockTake.ExpectedQuantity
FROM StockTake;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryStrings] AS
SELECT Strings.StringID, Strings.StringData
FROM Strings;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrySystemSettings] AS
SELECT SystemSettings.*
FROM SystemSettings;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryTitle] AS
SELECT Titles.Title
FROM Titles;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryTotalSalesByProduct] AS
SELECT OrderDetails.ProductID, Sum([Quantity]*(1-[Discount])*[UnitPrice]) AS TotalSales
FROM OrderDetails
GROUP BY OrderDetails.ProductID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryVendors] AS
SELECT Companies.*
FROM Companies
WHERE (((Companies.CompanyTypeID)=3));
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qrycboEmployees] AS
SELECT qryEmployees.EmployeeID, qryEmployees.FullNameFNLN
FROM qryEmployees;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryEmployeeLogin] AS
SELECT qryEmployees.EmployeeID, qryEmployees.FirstName, qryEmployees.LastName, qryEmployees.EmailAddress, qryEmployees.JobTitle, qryEmployees.WindowsUserName, qryEmployees.FullNameFNLN AS FullName
FROM qryEmployees;
GO

-- SKIPPED: qryEmployeeSupervisor
-- Reason: references Access form controls — cannot be a SQL view.
-- Convert manually to a stored procedure or parameterised query.
-- Original Access SQL:
/*
SELECT qryEmployees.EmployeeID, qryEmployees.fullnamefnln AS Supervisor
FROM qryEmployees
WHERE (((qryEmployees.EmployeeID)<>[Forms]![frmEmployeeList]![EmployeeID]));
*/

-- Query type: SELECT
CREATE OR ALTER VIEW [qryInvoice] AS
SELECT qryCustomers.CompanyName, qryCustomers.Address, qryCustomers.City, qryCustomers.StateAbbrev, qryCustomers.Zip, Orders.*, qryEmployees.FullNameFNLN AS SalesPerson, OrderDetails.ProductID, OrderDetails.Quantity, OrderDetails.UnitPrice, OrderDetails.Discount, Products.ProductCode, Products.ProductName
FROM Products INNER JOIN ((qryEmployees INNER JOIN (qryCustomers INNER JOIN Orders ON qryCustomers.CompanyID = Orders.CustomerID) ON qryEmployees.EmployeeID = Orders.EmployeeID) INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID) ON Products.ProductID = OrderDetails.ProductID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryPurchaseOrder] AS
SELECT PurchaseOrders.*, PurchaseOrderStatus.StatusName, qryEmployees.FullNameFNLN AS SubmittedBy, qryEmployees_1.FullNameFNLN AS ApprovedBy
FROM PurchaseOrderStatus INNER JOIN ((PurchaseOrders LEFT JOIN qryEmployees ON PurchaseOrders.SubmittedByID = qryEmployees.EmployeeID) LEFT JOIN qryEmployees AS qryEmployees_1 ON PurchaseOrders.ApprovedByID = qryEmployees_1.EmployeeID) ON PurchaseOrderStatus.StatusID = PurchaseOrders.StatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrderList_DetailStatus] AS
SELECT qryOrderList_DetailStatus_Lowest.OrderID, OrderDetailStatus.OrderDetailStatusName
FROM qryOrderList_DetailStatus_Lowest INNER JOIN OrderDetailStatus ON qryOrderList_DetailStatus_Lowest.MinOfSortOrder = OrderDetailStatus.SortOrder;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryrptSalesByEmployee] AS
SELECT Orders.EmployeeID, Sum(qryOrderTotal.OrderTotal) AS OrderTotal, [Employees].[FirstName]  +  ' '  +  [Employees].[LastName] AS FullNameFNLN, FORMAT([OrderDate], 'MMM-yyyy') AS MonthYear, FORMAT([OrderDate], 'yyyy-MM') AS MonthYearSort
FROM Employees INNER JOIN (qryOrderTotal INNER JOIN Orders ON qryOrderTotal.OrderID = Orders.OrderID) ON Employees.EmployeeID = Orders.EmployeeID
WHERE (((Orders.OrderDate) Between reportParameterStartDate() And reportParameterEndDate()))
GROUP BY Orders.EmployeeID, [Employees].[FirstName]  +  ' '  +  [Employees].[LastName], FORMAT([OrderDate], 'MMM-yyyy'), FORMAT([OrderDate], 'yyyy-MM');
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryrptProductCatalog] AS
SELECT ProductCategories.ProductCategoryID, ProductCategories.ProductCategoryName, ProductCategories.ProductCategoryCode, Products.ProductName, Products.ProductID, Products.QuantityPerUnit, Products.UnitPrice, qryTotalSalesByProduct.TotalSales, ProductCategories.ProductCategoryDesc, ProductCategories.ProductCategoryImage
FROM ProductCategories INNER JOIN (Products LEFT JOIN qryTotalSalesByProduct ON Products.ProductID = qryTotalSalesByProduct.ProductID) ON ProductCategories.ProductCategoryID = Products.ProductCategoryID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryCustomerOrderList] AS
SELECT Orders.OrderID, Orders.EmployeeID, Orders.CustomerID AS myCompanyID, Orders.OrderDate, Orders.ShippedDate, Orders.ShipperID, Orders.ShippingFee, Orders.TaxRate, Orders.TaxStatusID, Orders.PaymentMethod, Orders.PaidDate, Orders.Notes, Orders.OrderStatusID, Orders.AddedBy, Orders.AddedOn, Orders.ModifiedBy, Orders.ModifiedOn, qrycboEmployees.FullNameFNLN AS EmployeeName, qrycboShippers.CompanyName AS ShipperName, qryOrderTotal.OrderTotal, qrycboOrderStatus.OrderStatusName
FROM (((Orders INNER JOIN qrycboEmployees ON Orders.EmployeeID = qrycboEmployees.EmployeeID) LEFT JOIN qrycboShippers ON Orders.ShipperID = qrycboShippers.CompanyID) LEFT JOIN qryOrderTotal ON Orders.OrderID = qryOrderTotal.OrderID) INNER JOIN qrycboOrderStatus ON Orders.OrderStatusID = qrycboOrderStatus.OrderStatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryPurchaseOrderList] AS
SELECT PurchaseOrders.PurchaseOrderID, PurchaseOrderStatus.StatusName, qrycboVendors.CompanyName, Nz([qryPurchaseOrderCost].[ExtendedCost])+Nz([PurchaseOrders].[ShippingFee])+Nz([PurchaseOrders].[TaxAmount]) AS TotalCost, [qrycboEmployees-Submitted].FullNameFNLN AS Submitter, PurchaseOrders.SubmittedDate, [qrycboEmployees-Approved].FullNameFNLN AS Approver, PurchaseOrders.ApprovedDate, PurchaseOrders.PaymentDate
FROM PurchaseOrderStatus INNER JOIN (qrycboEmployees AS [qrycboEmployees-Approved] RIGHT JOIN (qrycboEmployees AS [qrycboEmployees-Submitted] RIGHT JOIN ((qrycboVendors INNER JOIN PurchaseOrders ON qrycboVendors.CompanyID = PurchaseOrders.VendorID) INNER JOIN qryPurchaseOrderCost ON PurchaseOrders.PurchaseOrderID = qryPurchaseOrderCost.PurchaseOrderID) ON [qrycboEmployees-Submitted].EmployeeID = PurchaseOrders.SubmittedByID) ON [qrycboEmployees-Approved].EmployeeID = PurchaseOrders.ApprovedByID) ON PurchaseOrderStatus.StatusID = PurchaseOrders.StatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryShipperOrderList] AS
SELECT Orders.OrderID, qrycboEmployees.FullNameFNLN AS EmployeeFNLN, Orders.OrderDate, qryOrderTotal.OrderTotal, OrderStatus.OrderStatusName, Orders.CustomerID, Orders.ShipperID AS myCompanyID, qrycboCustomers.CompanyName AS CustomerName
FROM OrderStatus INNER JOIN (((Orders INNER JOIN qrycboEmployees ON Orders.EmployeeID = qrycboEmployees.EmployeeID) INNER JOIN qryOrderTotal ON Orders.OrderID = qryOrderTotal.OrderID) INNER JOIN qrycboCustomers ON Orders.CustomerID = qrycboCustomers.CompanyID) ON OrderStatus.OrderStatusID = Orders.OrderStatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryVendorPurchaseOrderList] AS
SELECT PurchaseOrders.VendorID AS myCompanyID, PurchaseOrders.PurchaseOrderID, PurchaseOrders.SubmittedByID, PurchaseOrders.SubmittedDate, PurchaseOrders.ApprovedByID, PurchaseOrders.ApprovedDate, PurchaseOrders.StatusID, PurchaseOrders.ReceivedDate, PurchaseOrders.ShippingFee, PurchaseOrders.TaxAmount, PurchaseOrders.PaymentDate, PurchaseOrders.PaymentAmount, PurchaseOrders.PaymentMethod, PurchaseOrders.Notes, PurchaseOrders.AddedBy, PurchaseOrders.AddedOn, PurchaseOrders.ModifiedBy, PurchaseOrders.ModifiedOn, SumbittedBy.FullNameFNLN AS SubmittedBy, ApprovedBy.FullNameFNLN AS ApprovedBy, PurchaseOrderStatus.StatusName, qryPurchaseOrderCost.ExtendedCost
FROM PurchaseOrderStatus INNER JOIN (((PurchaseOrders INNER JOIN qrycboEmployees AS SumbittedBy ON PurchaseOrders.SubmittedByID = SumbittedBy.EmployeeID) LEFT JOIN qrycboEmployees AS ApprovedBy ON PurchaseOrders.ApprovedByID = ApprovedBy.EmployeeID) LEFT JOIN qryPurchaseOrderCost ON PurchaseOrders.PurchaseOrderID = qryPurchaseOrderCost.PurchaseOrderID) ON PurchaseOrderStatus.StatusID = PurchaseOrders.StatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrderList] AS
SELECT Orders.*, qrycboEmployees.FullNameFNLN, qryCustomers.CompanyName, qryOrderTotal.OrderTotal, OrderStatus.OrderStatusName, qryOrderList_DetailStatus.OrderDetailStatusName, CAST([OrderDate] AS DATE) AS OrderDateOnly
FROM OrderStatus INNER JOIN ((qrycboEmployees INNER JOIN ((qryCustomers INNER JOIN Orders ON qryCustomers.CompanyID = Orders.CustomerID) INNER JOIN qryOrderTotal ON Orders.OrderID = qryOrderTotal.OrderID) ON qrycboEmployees.EmployeeID = Orders.EmployeeID) LEFT JOIN qryOrderList_DetailStatus ON Orders.OrderID = qryOrderList_DetailStatus.OrderID) ON OrderStatus.OrderStatusID = Orders.OrderStatusID;
GO

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrders_MostRecent] AS
SELECT TOP 20 qryOrderList.*
FROM qryOrderList;
GO

-- SKIPPED: qryOrders_MostRecent_Customer
-- Reason: references Access form controls — cannot be a SQL view.
-- Convert manually to a stored procedure or parameterised query.
-- Original Access SQL:
/*
SELECT qryOrderList.*
FROM qryOrderList
WHERE (((qryOrderList.CustomerID)=[Parent]![Parent]![CustomerID]))
ORDER BY qryOrderList.OrderDate DESC;
*/

-- SKIPPED: qryOrders_MostRecent_Employee
-- Reason: references Access form controls — cannot be a SQL view.
-- Convert manually to a stored procedure or parameterised query.
-- Original Access SQL:
/*
SELECT qryOrderList.*
FROM qryOrderList
WHERE (((qryOrderList.EmployeeID)=[Parent].[EmployeeID]))
ORDER BY qryOrderList.OrderDate DESC;
*/

-- Query type: SELECT
CREATE OR ALTER VIEW [qryOrders_MostRecent_ModifiedOn] AS
SELECT qryOrderList.*
FROM qryOrderList;
GO

