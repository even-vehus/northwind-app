-- Data for table: OrderStatus
-- Row count: 5

IF NOT EXISTS (SELECT 1 FROM [OrderStatus])
BEGIN
    SET IDENTITY_INSERT [OrderStatus] ON;
    INSERT INTO [OrderStatus] ([OrderStatusID], [OrderStatusCode], [OrderStatusName], [SortOrder], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'CLO', N'Closed', 40, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'INV', N'Invoiced', 20, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'NEW', N'New', 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'SHI', N'Shipped', 30, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'PAY', N'Paid', 35, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [OrderStatus] OFF;
END