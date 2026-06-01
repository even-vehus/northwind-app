-- Data for table: Companies
-- Row count: 13

IF NOT EXISTS (SELECT 1 FROM [Companies])
BEGIN
    SET IDENTITY_INSERT [Companies] ON;
    INSERT INTO [Companies] ([CompanyID], [CompanyName], [CompanyTypeID], [BusinessPhone], [Address], [City], [StateAbbrev], [Zip], [Website], [Notes], [StandardTaxStatusID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Adatum Corporation', 1, N'123-555-1212', N'123 Oak Street', N'Redmond', N'WA', N'90001', N'#http://www.adatum.com/#', N'<div><font size=4 color="#70AD47"><strong>This </strong></font><font size=4>is an <strong>RTF </strong></font><font
size=4 color="#2E75B5"><strong>test</strong></font></div>', 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Adventure Works Cycles', 1, N'234-555-1212 x123', N'234 Elm Street', N'Tacoma', N'WA', N'90002-2222', N'#http://www.adventure-works.com/#', NULL, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'Best For You Organics Company', 1, NULL, N'345 Mesquite Lane', N'Mesa', N'AZ', N'90003', N'http://www.bestforyouorganics.com', NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Contoso, Inc.', 1, NULL, N'456 Queen Palm Avenue', N'Ft Lauderdale', N'FL', N'90004', N'http://www.contoso.com/', NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'Woodgrove Bank', 1, N'505-555-1212 (cell)', N'567 Green Avenue', N'St. Louis', N'MO', N'90005', NULL, NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'Wide World Importers', 1, N'600-555-1212', N'6001 Purple Street', N'Atlanta', N'GA', N'90006', NULL, NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, N'Tailwind Traders', 1, N'711-555-1212', N'70 N Blue Water Lane', N'Richmond', N'VA', N'90007', NULL, NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, N'Proseware, Inc.', 1, N'8012221212ext22022', N'801 Ironwood Rd', N'Manchester', N'NH', N'90008', NULL, NULL, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, N'Green Shipping Co', 2, N'800-555-1212', N'9000 Green Street', N'Green Bay', N'WI', N'90009', NULL, NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, N'Blue Shipping Co', 2, N'800-555-1313', N'100 Blue Street', N'Columbus', N'OH', N'90010', NULL, NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, N'Yellow Vendor Co', 3, NULL, N'111 Yellow Brick Road', N'New York', N'NY', N'90011', NULL, NULL, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, N'Brown Vendor Co', 3, NULL, N'222 Brown Street', N'Brownsville', N'TX', N'78520', NULL, NULL, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, N'Northwind Traders', 4, NULL, N'One Portals Way', N'Twin Points', N'WA', N'12345', N'www.northwindtraders.com#http://www.northwindtraders.com/#', NULL, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Companies] OFF;
END