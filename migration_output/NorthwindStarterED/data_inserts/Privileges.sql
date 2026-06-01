-- Data for table: Privileges
-- Row count: 1

IF NOT EXISTS (SELECT 1 FROM [Privileges])
BEGIN
    SET IDENTITY_INSERT [Privileges] ON;
    INSERT INTO [Privileges] ([PrivilegeID], [PrivilegeName], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Purchase Approvals', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Privileges] OFF;
END