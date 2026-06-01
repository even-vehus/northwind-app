-- Data for table: CompanyTypes
-- Row count: 4

IF NOT EXISTS (SELECT 1 FROM [CompanyTypes])
BEGIN
    SET IDENTITY_INSERT [CompanyTypes] ON;
    INSERT INTO [CompanyTypes] ([CompanyTypeID], [CompanyType], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Customer', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Shipper', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'Vendor', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Northwind', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [CompanyTypes] OFF;
END