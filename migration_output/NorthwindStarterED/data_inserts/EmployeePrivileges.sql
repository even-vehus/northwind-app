-- Data for table: EmployeePrivileges
-- Row count: 3

IF NOT EXISTS (SELECT 1 FROM [EmployeePrivileges])
BEGIN
    SET IDENTITY_INSERT [EmployeePrivileges] ON;
    INSERT INTO [EmployeePrivileges] ([EmployeePrivilegeID], [EmployeeID], [PrivilegeID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 2, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 9, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, 10, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [EmployeePrivileges] OFF;
END