-- Data for table: Contacts
-- Row count: 6

IF NOT EXISTS (SELECT 1 FROM [Contacts])
BEGIN
    SET IDENTITY_INSERT [Contacts] ON;
    INSERT INTO [Contacts] ([ContactID], [CompanyID], [LastName], [FirstName], [EmailAddress], [JobTitle], [PrimaryPhone], [SecondaryPhone], [Notes], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (9, 1, N'Chauvin', N'Alexandre', N'test@test.com', N'Senior Buyer', N'1234567890x1234', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, 3, N'Eden', N'Bouchard', NULL, N'Dry Goods Rep', NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, 5, N'Fuster', N'Adriana', NULL, N'Sales Manager', NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, 6, N'Gagnon', N'Alex', NULL, N'Senior Buyer', NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, 7, N'Albert', N'Sasha', NULL, N'Vendor Relations', NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, 8, N'Monte', N'Ariana', NULL, N'Senior Buyer', NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Contacts] OFF;
END