-- Data for table: Employees
-- Row count: 10

IF NOT EXISTS (SELECT 1 FROM [Employees])
BEGIN
    SET IDENTITY_INSERT [Employees] ON;
    INSERT INTO [Employees] ([EmployeeID], [FirstName], [LastName], [EmailAddress], [JobTitle], [PrimaryPhone], [SecondaryPhone], [Title], [Notes], [Attachments], [SupervisorID], [WindowsUserName], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Nancy', N'Freehafer', N'nancy@northwindtraders.com', N'Sales Representative', N'123-555-0100', N'123-555-0200', N'Ms.', NULL, N'NancyF.jpg', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Andrew', N'Cencini', N'andrew@northwindtraders.com', N'Vice President, Sales', N'123-555-0101', NULL, N'Mr.', N'Joined the company as a sales representative, was promoted to sales manager and was then named vice president of sales.', N'AndrewC.jpg', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'Jan', N'Kotas', N'jan@northwindtraders.com', N'Sales Representative', N'123-555-0102', NULL, NULL, N'Was hired as a sales associate and was promoted to sales representative.', N'JanK.jpg', 2, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Mariya', N'Sergienko', N'mariya@northwindtraders.com', N'Sales Representative', N'123-555-0103', NULL, NULL, NULL, N'MariyaS.jpg', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'Steven', N'Thorpe', N'steven@northwindtraders.com', N'Sales Manager', N'123-555-0104', NULL, NULL, N'Joined the company as a sales representative and was promoted to sales manager.  Fluent in French.', N'StevenT.jpg', 3, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'Michael', N'Neipper', N'michael@northwindtraders.com', N'Sales Representative', N'123-555-0105', NULL, NULL, N'Fluent in Japanese and can read and write French, Portuguese, and Spanish.', N'MichaelN.jpg', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, N'Robert', N'Zare', N'robert@northwindtraders.com', N'Sales Representative', N'123-555-0106', NULL, NULL, NULL, N'RobertZ.jpg', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, N'Laura', N'Giussani', N'laura@northwindtraders.com', N'Sales Coordinator', N'123-555-0107', NULL, NULL, N'Reads and writes French.', N'LauraG.jpg', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, N'Anne', N'Hellung-Larsen', N'anne@northwindtraders.com', N'Sales Representative', N'123-555-0108', NULL, NULL, N'Fluent in French and German.', N'AnneH.jpg', 2, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, N'Internet', N'Sales', NULL, N'Internet Bot', NULL, NULL, NULL, NULL, N'', NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Employees] OFF;
END