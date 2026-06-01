-- Data for table: PurchaseOrders
-- Row count: 2

IF NOT EXISTS (SELECT 1 FROM [PurchaseOrders])
BEGIN
    SET IDENTITY_INSERT [PurchaseOrders] ON;
    INSERT INTO [PurchaseOrders] ([PurchaseOrderID], [VendorID], [SubmittedByID], [SubmittedDate], [ApprovedByID], [ApprovedDate], [StatusID], [ReceivedDate], [ShippingFee], [TaxAmount], [PaymentDate], [PaymentAmount], [PaymentMethod], [Notes], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 12, 2, '2024-08-20 08:00:00.000', 2, '2024-08-20 08:05:00.000', 2, '2024-08-20 08:00:00.000', 100.0000, 5009.9900, '2024-08-20 09:00:00.000', 60776.4900, N'Credit Card', NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 12, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [PurchaseOrders] OFF;
END