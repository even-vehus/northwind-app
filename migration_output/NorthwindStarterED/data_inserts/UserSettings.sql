-- Data for table: UserSettings
-- Row count: 1

IF NOT EXISTS (SELECT 1 FROM [UserSettings])
BEGIN
    SET IDENTITY_INSERT [UserSettings] ON;
    INSERT INTO [UserSettings] ([SettingID], [SettingName], [SettingValue], [Notes])
    VALUES
        (2, N'AutoLogin', N'0', N'[boolean]');
    SET IDENTITY_INSERT [UserSettings] OFF;
END