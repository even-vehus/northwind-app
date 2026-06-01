-- Data for table: TaxStatus
-- Row count: 2

IF NOT EXISTS (SELECT 1 FROM [TaxStatus])
BEGIN
    INSERT INTO [TaxStatus] ([TaxStatusID], [TaxStatus], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (0, N'Tax Exempt', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (1, N'Taxable', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
END