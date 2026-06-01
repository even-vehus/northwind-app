-- Microsoft Fabric SQL Migration Script
-- Generated: 2026-05-29T10:38:46.525090
-- Source: NorthwindStarterED.accdb
-- Target: Microsoft Fabric SQL Database (T-SQL)

-- Table: Catalog_TableOfContents (16 rows)
IF OBJECT_ID(N'[Catalog_TableOfContents]', N'U') IS NULL
BEGIN
CREATE TABLE [Catalog_TableOfContents] (
    [TocTitle] NVARCHAR(255),
    [TocPage] INT,
    CONSTRAINT [PK_Catalog_TableOfContents] PRIMARY KEY ([TocTitle])
);
END

-- Table: Companies (13 rows)
IF OBJECT_ID(N'[Companies]', N'U') IS NULL
BEGIN
CREATE TABLE [Companies] (
    [CompanyID] INT IDENTITY(1,1),
    [CompanyName] NVARCHAR(50),
    [CompanyTypeID] INT,
    [BusinessPhone] NVARCHAR(20),
    [Address] NVARCHAR(255),
    [City] NVARCHAR(255),
    [StateAbbrev] NVARCHAR(2),
    [Zip] NVARCHAR(10),
    [Website] NVARCHAR(MAX),
    [Notes] NVARCHAR(MAX),
    [StandardTaxStatusID] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Companies] PRIMARY KEY ([CompanyID])
);
END

-- Table: CompanyTypes (4 rows)
IF OBJECT_ID(N'[CompanyTypes]', N'U') IS NULL
BEGIN
CREATE TABLE [CompanyTypes] (
    [CompanyTypeID] INT IDENTITY(1,1),
    [CompanyType] NVARCHAR(50),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_CompanyTypes] PRIMARY KEY ([CompanyTypeID])
);
END

-- Table: Contacts (6 rows)
IF OBJECT_ID(N'[Contacts]', N'U') IS NULL
BEGIN
CREATE TABLE [Contacts] (
    [ContactID] INT IDENTITY(1,1),
    [CompanyID] INT,
    [LastName] NVARCHAR(30),
    [FirstName] NVARCHAR(20),
    [EmailAddress] NVARCHAR(255),
    [JobTitle] NVARCHAR(50),
    [PrimaryPhone] NVARCHAR(20),
    [SecondaryPhone] NVARCHAR(20),
    [Notes] NVARCHAR(MAX),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Contacts] PRIMARY KEY ([ContactID])
);
END

-- Table: EmployeePrivileges (3 rows)
IF OBJECT_ID(N'[EmployeePrivileges]', N'U') IS NULL
BEGIN
CREATE TABLE [EmployeePrivileges] (
    [EmployeePrivilegeID] INT IDENTITY(1,1),
    [EmployeeID] INT,
    [PrivilegeID] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_EmployeePrivileges] PRIMARY KEY ([EmployeePrivilegeID])
);
END

-- Table: Employees (10 rows)
IF OBJECT_ID(N'[Employees]', N'U') IS NULL
BEGIN
CREATE TABLE [Employees] (
    [EmployeeID] INT IDENTITY(1,1),
    [FirstName] NVARCHAR(20),
    [LastName] NVARCHAR(30),
    [EmailAddress] NVARCHAR(255),
    [JobTitle] NVARCHAR(50),
    [PrimaryPhone] NVARCHAR(20),
    [SecondaryPhone] NVARCHAR(20),
    [Title] NVARCHAR(20),
    [Notes] NVARCHAR(MAX),
    [Attachments] NVARCHAR(MAX),
    [SupervisorID] INT,
    [WindowsUserName] NVARCHAR(50),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Employees] PRIMARY KEY ([EmployeeID])
);
END

-- Table: Learn (15 rows)
IF OBJECT_ID(N'[Learn]', N'U') IS NULL
BEGIN
CREATE TABLE [Learn] (
    [ID] INT IDENTITY(1,1),
    [SectionNo] INT,
    [SectionText] NVARCHAR(MAX),
    CONSTRAINT [PK_Learn] PRIMARY KEY ([ID])
);
END

-- Table: MRU (0 rows)
IF OBJECT_ID(N'[MRU]', N'U') IS NULL
BEGIN
CREATE TABLE [MRU] (
    [MRU_ID] INT IDENTITY(1,1),
    [EmployeeID] INT,
    [TableName] NVARCHAR(50),
    [PKValue] INT,
    [DateAdded] DATETIME2,
    CONSTRAINT [PK_MRU] PRIMARY KEY ([MRU_ID])
);
END

-- Table: NorthwindFeatures (39 rows)
IF OBJECT_ID(N'[NorthwindFeatures]', N'U') IS NULL
BEGIN
CREATE TABLE [NorthwindFeatures] (
    [NorthwindFeaturesID] INT IDENTITY(1,1),
    [ItemName] NVARCHAR(255),
    [Description] NVARCHAR(255),
    [Navigation] NVARCHAR(255),
    [LearnMore] NVARCHAR(MAX),
    [HelpKeywords] NVARCHAR(255),
    [OpenMethod] INT,
    CONSTRAINT [PK_NorthwindFeatures] PRIMARY KEY ([NorthwindFeaturesID])
);
END

-- Table: OrderDetails (130 rows)
IF OBJECT_ID(N'[OrderDetails]', N'U') IS NULL
BEGIN
CREATE TABLE [OrderDetails] (
    [OrderDetailID] INT IDENTITY(1,1),
    [OrderID] INT,
    [ProductID] INT,
    [Quantity] INT,
    [UnitPrice] DECIMAL(19,4),
    [Discount] FLOAT,
    [OrderDetailStatusID] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_OrderDetails] PRIMARY KEY ([OrderDetailID])
);
END

-- Table: OrderDetailStatus (6 rows)
IF OBJECT_ID(N'[OrderDetailStatus]', N'U') IS NULL
BEGIN
CREATE TABLE [OrderDetailStatus] (
    [OrderDetailStatusID] INT IDENTITY(1,1),
    [OrderDetailStatusName] NVARCHAR(50),
    [SortOrder] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_OrderDetailStatus] PRIMARY KEY ([OrderDetailStatusID])
);
END

-- Table: Orders (52 rows)
IF OBJECT_ID(N'[Orders]', N'U') IS NULL
BEGIN
CREATE TABLE [Orders] (
    [OrderID] INT IDENTITY(1,1),
    [EmployeeID] INT,
    [CustomerID] INT,
    [OrderDate] DATETIME2,
    [InvoiceDate] DATETIME2,
    [ShippedDate] DATETIME2,
    [ShipperID] INT,
    [ShippingFee] DECIMAL(19,4),
    [TaxRate] FLOAT,
    [TaxStatusID] INT,
    [PaymentMethod] NVARCHAR(50),
    [PaidDate] DATETIME2,
    [Notes] NVARCHAR(MAX),
    [OrderStatusID] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderID])
);
END

-- Table: OrderStatus (5 rows)
IF OBJECT_ID(N'[OrderStatus]', N'U') IS NULL
BEGIN
CREATE TABLE [OrderStatus] (
    [OrderStatusID] INT IDENTITY(1,1),
    [OrderStatusCode] NVARCHAR(5),
    [OrderStatusName] NVARCHAR(50),
    [SortOrder] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_OrderStatus] PRIMARY KEY ([OrderStatusID])
);
END

-- Table: Privileges (1 rows)
IF OBJECT_ID(N'[Privileges]', N'U') IS NULL
BEGIN
CREATE TABLE [Privileges] (
    [PrivilegeID] INT IDENTITY(1,1),
    [PrivilegeName] NVARCHAR(50),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Privileges] PRIMARY KEY ([PrivilegeID])
);
END

-- Table: ProductCategories (16 rows)
IF OBJECT_ID(N'[ProductCategories]', N'U') IS NULL
BEGIN
CREATE TABLE [ProductCategories] (
    [ProductCategoryID] INT IDENTITY(1,1),
    [ProductCategoryName] NVARCHAR(255),
    [ProductCategoryCode] NVARCHAR(3),
    [ProductCategoryDesc] NVARCHAR(255),
    [ProductCategoryImage] NVARCHAR(MAX),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_ProductCategories] PRIMARY KEY ([ProductCategoryID])
);
END

-- Table: Products (43 rows)
IF OBJECT_ID(N'[Products]', N'U') IS NULL
BEGIN
CREATE TABLE [Products] (
    [ProductID] INT IDENTITY(1,1),
    [ProductCode] NVARCHAR(20),
    [ProductName] NVARCHAR(50),
    [ProductDescription] NVARCHAR(MAX),
    [StandardUnitCost] DECIMAL(19,4),
    [UnitPrice] DECIMAL(19,4),
    [ReorderLevel] INT,
    [TargetLevel] INT,
    [QuantityPerUnit] NVARCHAR(50),
    [Discontinued] BIT NOT NULL,
    [MinimumReorderQuantity] INT,
    [ProductCategoryID] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Products] PRIMARY KEY ([ProductID])
);
END

-- Table: ProductVendors (47 rows)
IF OBJECT_ID(N'[ProductVendors]', N'U') IS NULL
BEGIN
CREATE TABLE [ProductVendors] (
    [ProductVendorID] INT IDENTITY(1,1),
    [ProductID] INT,
    [VendorID] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_ProductVendors] PRIMARY KEY ([ProductVendorID])
);
END

-- Table: PurchaseOrderDetails (43 rows)
IF OBJECT_ID(N'[PurchaseOrderDetails]', N'U') IS NULL
BEGIN
CREATE TABLE [PurchaseOrderDetails] (
    [PurchaseOrderDetailID] INT IDENTITY(1,1),
    [PurchaseOrderID] INT,
    [ProductID] INT,
    [Quantity] INT,
    [UnitCost] DECIMAL(19,4),
    [ReceivedDate] DATETIME2,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_PurchaseOrderDetails] PRIMARY KEY ([PurchaseOrderDetailID])
);
END

-- Table: PurchaseOrders (2 rows)
IF OBJECT_ID(N'[PurchaseOrders]', N'U') IS NULL
BEGIN
CREATE TABLE [PurchaseOrders] (
    [PurchaseOrderID] INT IDENTITY(1,1),
    [VendorID] INT,
    [SubmittedByID] INT,
    [SubmittedDate] DATETIME2,
    [ApprovedByID] INT,
    [ApprovedDate] DATETIME2,
    [StatusID] INT,
    [ReceivedDate] DATETIME2,
    [ShippingFee] DECIMAL(19,4),
    [TaxAmount] DECIMAL(19,4),
    [PaymentDate] DATETIME2,
    [PaymentAmount] DECIMAL(19,4),
    [PaymentMethod] NVARCHAR(50),
    [Notes] NVARCHAR(MAX),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_PurchaseOrders] PRIMARY KEY ([PurchaseOrderID])
);
END

-- Table: PurchaseOrderStatus (5 rows)
IF OBJECT_ID(N'[PurchaseOrderStatus]', N'U') IS NULL
BEGIN
CREATE TABLE [PurchaseOrderStatus] (
    [StatusID] INT IDENTITY(1,1),
    [StatusName] NVARCHAR(50),
    [SortOrder] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_PurchaseOrderStatus] PRIMARY KEY ([StatusID])
);
END

-- Table: States (51 rows)
IF OBJECT_ID(N'[States]', N'U') IS NULL
BEGIN
CREATE TABLE [States] (
    [StateAbbrev] NVARCHAR(2),
    [StateName] NVARCHAR(50),
    CONSTRAINT [PK_States] PRIMARY KEY ([StateAbbrev])
);
END

-- Table: StockTake (43 rows)
IF OBJECT_ID(N'[StockTake]', N'U') IS NULL
BEGIN
CREATE TABLE [StockTake] (
    [StockTakeID] INT IDENTITY(1,1),
    [StockTakeDate] DATETIME2,
    [ProductID] INT,
    [QuantityOnHand] INT,
    [ExpectedQuantity] INT,
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_StockTake] PRIMARY KEY ([StockTakeID])
);
END

-- Table: Strings (49 rows)
IF OBJECT_ID(N'[Strings]', N'U') IS NULL
BEGIN
CREATE TABLE [Strings] (
    [StringID] INT IDENTITY(1,1),
    [StringData] NVARCHAR(MAX),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Strings] PRIMARY KEY ([StringID])
);
END

-- Table: SystemSettings (5 rows)
IF OBJECT_ID(N'[SystemSettings]', N'U') IS NULL
BEGIN
CREATE TABLE [SystemSettings] (
    [SettingID] INT IDENTITY(1,1),
    [SettingName] NVARCHAR(50),
    [SettingValue] NVARCHAR(255),
    [Notes] NVARCHAR(255),
    CONSTRAINT [PK_SystemSettings] PRIMARY KEY ([SettingID])
);
END

-- Table: TaxStatus (2 rows)
IF OBJECT_ID(N'[TaxStatus]', N'U') IS NULL
BEGIN
CREATE TABLE [TaxStatus] (
    [TaxStatusID] INT,
    [TaxStatus] NVARCHAR(50),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_TaxStatus] PRIMARY KEY ([TaxStatusID])
);
END

-- Table: Titles (3 rows)
IF OBJECT_ID(N'[Titles]', N'U') IS NULL
BEGIN
CREATE TABLE [Titles] (
    [Title] NVARCHAR(20),
    [AddedBy] NVARCHAR(255),
    [AddedOn] DATETIME2,
    [ModifiedBy] NVARCHAR(255),
    [ModifiedOn] DATETIME2,
    CONSTRAINT [PK_Titles] PRIMARY KEY ([Title])
);
END

-- Table: UserSettings (1 rows)
IF OBJECT_ID(N'[UserSettings]', N'U') IS NULL
BEGIN
CREATE TABLE [UserSettings] (
    [SettingID] INT IDENTITY(1,1),
    [SettingName] NVARCHAR(50),
    [SettingValue] NVARCHAR(255),
    [Notes] NVARCHAR(255),
    CONSTRAINT [PK_UserSettings] PRIMARY KEY ([SettingID])
);
END

-- Table: USysRibbons (1 rows)
IF OBJECT_ID(N'[USysRibbons]', N'U') IS NULL
BEGIN
CREATE TABLE [USysRibbons] (
    [ID] INT IDENTITY(1,1),
    [RibbonName] NVARCHAR(255),
    [RibbonXML] NVARCHAR(MAX),
    CONSTRAINT [PK_USysRibbons] PRIMARY KEY ([ID])
);
END

-- Table: Welcome (1 rows)
IF OBJECT_ID(N'[Welcome]', N'U') IS NULL
BEGIN
CREATE TABLE [Welcome] (
    [ID] INT IDENTITY(1,1),
    [Welcome] NVARCHAR(MAX),
    [Learn] NVARCHAR(MAX),
    [DataMacro] NVARCHAR(MAX),
    CONSTRAINT [PK_Welcome] PRIMARY KEY ([ID])
);
END
