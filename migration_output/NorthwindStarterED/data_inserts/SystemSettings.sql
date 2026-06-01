-- Data for table: SystemSettings
-- Row count: 5

IF NOT EXISTS (SELECT 1 FROM [SystemSettings])
BEGIN
    SET IDENTITY_INSERT [SystemSettings] ON;
    INSERT INTO [SystemSettings] ([SettingID], [SettingName], [SettingValue], [Notes])
    VALUES
        (1, N'TaxRate', N'85', N'[percent] Rate charged to taxable customers by Northwind Traders. Divide by 1000 to get Single value.'),
        (4, N'LastResetDate', N'2023-03-30', N'[date]'),
        (5, N'ShowWelcome', N'-1', N'[boolean] Show the Welcome Screen'),
        (6, N'TaxRate_Vendors', N'90', N'[percent] Rate paid by Northwind Traders to its vendors. Divide by 1000 to get Single value.'),
        (7, N'FirstTimeProcessingSuccess', N'0', N'[boolean] Did we successfully complete first-time run functionality?');
    SET IDENTITY_INSERT [SystemSettings] OFF;
END