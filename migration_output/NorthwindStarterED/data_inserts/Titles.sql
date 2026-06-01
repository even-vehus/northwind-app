-- Data for table: Titles
-- Row count: 3

IF NOT EXISTS (SELECT 1 FROM [Titles])
BEGIN
    INSERT INTO [Titles] ([Title], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (N'', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (N'Mr.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (N'Ms.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
END