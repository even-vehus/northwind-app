-- Data for table: OrderDetailStatus
-- Row count: 6

IF NOT EXISTS (SELECT 1 FROM [OrderDetailStatus])
BEGIN
    SET IDENTITY_INSERT [OrderDetailStatus] ON;
    INSERT INTO [OrderDetailStatus] ([OrderDetailStatusID], [OrderDetailStatusName], [SortOrder], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Allocated', 40, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Invoiced', 50, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'New', 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'No Stock', 20, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'On Order', 30, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'Shipped', 60, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [OrderDetailStatus] OFF;
END