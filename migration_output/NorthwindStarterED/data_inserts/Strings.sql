-- Data for table: Strings
-- Row count: 49

IF NOT EXISTS (SELECT 1 FROM [Strings])
BEGIN
    SET IDENTITY_INSERT [Strings] ON;
    INSERT INTO [Strings] ([StringID], [StringData], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Hello {0}. This is {1}.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Please enter a number between {0} and {1}.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Only orders with status of Paid can be closed.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'OK to close this order?', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'An order can only be deleted before it is Shipped or Closed.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, N'Are you sure you want to permanently delete this {0}?', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, N'Record cannot be saved because not all required fields have been filled out. They are highlighted for your review.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, N'The order cannot be shipped until all Shipping related fields are filled out.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, N'Only orders with status of Invoiced can be shipped.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, N'There is no data for this report. Please try different criteria.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, N'{0} is not in the list of employees. If you want to add {0} as a supervisor, you must first add them as an employee.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, N'{0} {1} <br />
     {2}.<br /><br />', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, N'Confirm deletion of {0}.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, N'{0} is not a valid US phone number. Phone numbers must be formatted as either "(222) 333-444" or "555-6666"', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, N'The example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious.  No association with any real company, organization, product, domain name, email address, logo, person, places, or events is intended or should be inferred.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, N'The order cannot be invoiced until all line items have a status of Allocated. Allocation happens automatically when a PO is received with sufficient quantity.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, N'You are already on a new record.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, N'You don''t have the {0} privilege so you cannot perform this action. If you feel this is an error, discuss it with your supervisor. (TIP: login as Andrew Cencini, or give yourself rights in System Admin > Privileges)', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, N'The purchase order can only be submitted if it is in the New status.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, N'The purchase order can only be approved if it is in the Submitted status.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, N'Changing vendor will remove all purchase line items. OK to continue?', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, N'Has the entire purchase order been received, and are you ready to post to inventory? Orders waiting for these products will be updated.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, N'The purchase order can only be received if it is in the Approved status.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, N'The purchase order can only be closed if it is in the Received status.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, N'Shipping Fee and Payment Method are required before closing the purchase order.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, N'A purchase order can only be deleted when its Status is New or Submitted.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, N'This quantity is less than the Minimum Re-Order Quantity of {0}. That is not allowed.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, N'This quantity will result in an inventory level less than the Target Level of {0}. That is allowed but undesirable. Consider ordering at least {1} more.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, N'The new status has been set.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, N'Was the order paid today?', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, N'{0} ''{1}'' cannot be deleted because it has a related {2} record.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, N'An order must have at least one line item.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, N'You cannot change the Company Type if the Company has Orders/Purchase Orders.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, N'The order cannot be paid until all Payment related fields are filled out.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, N'You can''t {0} if the Company has<br />     Customer Orders ({1}) <br />     Shipper Orders ({2}) <br />     Vendor Purchase Orders ({3}) <br />     {4}  <br />', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, N'If you delete the Company any <br />     Contacts ({0}) <br />     and/or Vendor Products ({1}) will be deleted.<br /><br />    Is this OK?', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, N'This option is not available on a new order.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, N'If there are no recent orders, you may want to use Recent Dates on the System Admin form to move the dates of existing records forward.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, N'This Northwind Dev Edition template is brought to you by the "Northwind Working Group", a community team of volunteers who spent a year designing, implementing, documenting, and testing this application, and its companion Northwind Starter Edition.

The core working group members are Dawn Taylor, George Hepworth, George Young, Kim Young, and Tom van Stiphout. Michael Aldridge led the effort at Microsoft.

Many people contributed to the success of this project, including focus group members, alpha testers, former and current Access MVPs, videographers, help text editors, accessibility testers, intellectual property lawyers, and many others. It really takes a whole community.

Please share your feedback with the team. We will be watching the Access Tech Community forum, as well as other forums where Access developers hang out.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, N'The form {0} is already open. Please close the form before opening a new {0}.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, N'Tour the Gastronomic World with Northwind Traders!', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (44, N'When Northwind Traders buyers set out to search for the Wonders of the Gastronomic World they found a lot more than seven of them. And here they are--tastefully presented in our Fall Catalog.

The beverages and confections we''re featuring this fall are sure to please even the most discerning palates.

For thirst quenchers, try exotic chai, a hearty beer, or revitalizing coffee.

And for a taste of something sweet, try our brownie and cake mixes, or our rich, dark chocolate.

Our sales representatives are ready to take your orders now. For your convenience, we''ve included details on ordering on the last page of this catalog.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (45, N'Commitment to Quality', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (46, N'Northwind Traders is committed to bringing you products of the highest quality from all over the world. If at any time you are not completely satisfied with any of our products, you may return them to us for a full refund.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (47, N'How to order:
To place your order, fill out this order form and return it to us. For fast personal service,
call us at 1-206-555-1417. If you prefer to order by fax, prepare your order as you would
for a mail-in, and then fax us at 1-206-555-5938.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (48, N'You have changed the data and not saved it.  Do you want to save it now? Selecting No will undo your changes.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (49, N'Only orders with status of Shipped can be paid.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (50, N'Only orders with status of New can be invoiced.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (51, N'Please first complete the Order at the top of this form, before entering Order Line Items.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Strings] OFF;
END