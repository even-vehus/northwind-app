-- Data for table: PurchaseOrderStatus
-- Row count: 5

IF NOT EXISTS (SELECT 1 FROM [PurchaseOrderStatus])
BEGIN
    SET IDENTITY_INSERT [PurchaseOrderStatus] ON;
    INSERT INTO [PurchaseOrderStatus] ([StatusID], [StatusName], [SortOrder], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Approved', 30, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Closed', 50, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'New', 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Submitted', 20, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'Received', 40, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [PurchaseOrderStatus] OFF;
END