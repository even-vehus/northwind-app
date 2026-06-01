-- Data for table: NorthwindFeatures
-- Row count: 39

IF NOT EXISTS (SELECT 1 FROM [NorthwindFeatures])
BEGIN
    SET IDENTITY_INSERT [NorthwindFeatures] ON;
    INSERT INTO [NorthwindFeatures] ([NorthwindFeaturesID], [ItemName], [Description], [Navigation], [LearnMore], [HelpKeywords], [OpenMethod])
    VALUES
        (2, N'List form - Multiple items', N'Fixed width columns. A.k.a. Continuous forms', N'Orders
Employees
Products', N'Create a form in Access#https://support.microsoft.com/office/create-a-form-in-access-5d550a3d-92e1-4f38-9772-7e7e21e80c6b#', N'Create form', 1),
        (3, N'List form - Datasheet', N'Reorder and Resize columns', N'Products > Click hyperlink > Orders for [product]
Customers (technically a Split Form, but acts the same way', N'Create a form using a datasheet in Access#https://support.microsoft.com/office/create-a-form-using-the-datasheet-tool-d0cfef2d-1ffb-4300-8ab3-7bcef4b4ef6d#', N'Working with datasheets', 1),
        (4, N'Single record form', NULL, N'Add Order. 
Products > Click hyperlink', N'Create a form in Access#https://support.microsoft.com/office/create-a-form-in-access-5d550a3d-92e1-4f38-9772-7e7e21e80c6b#', N'Create form', 1),
        (5, N'List form - Split form', N'Combination of Datasheet and Single Record form.', N'Customer List
Feature Matrix', N'Create a split form in Access#https://support.microsoft.com/office/create-a-split-form-e8eb0efb-2fa6-4315-9d4b-86e79a1fbe1e#', N'Create Split Form', 1),
        (6, N'Resizable form', NULL, N'Orders > Click hyperlink', N'#https://learn.microsoft.com/office/vba/api/access.form.borderstyle#', N'Form Borderstyle Property', 1),
        (7, N'Popup form', N'Form can float anywhere', N'Add Employee. Assign Employee Privileges pops up.', N'Pop-up Forms#https://learn.microsoft.com/office/vba/api/access.form.popup#', N'Form.Popup', 1),
        (8, N'Modal form', N'User cannot select outside of this form', N'Add Employee. Assign Employee Privileges pop-up is  modal.', NULL, N'Modal Property', 1),
        (9, N'Totals calculations', NULL, N'Orders
Orders > Click hyperlink', NULL, N'Totals', 1),
        (10, N'Navigate using hyperlink', N'Check the VBA procedure for the Click event of the item in design view', N'Orders
Customers
Employees
Product', N'Form DisplayAsHyperlink property#https://learn.microsoft.com/office/vba/api/access.textbox.displayashyperlink#', NULL, 2),
        (11, N'Open form with filter', N'Can use WhereCondition or OpenArgs argument of OpenForm', N'All hyperlink navigation forms', NULL, N'Filter Forms', 1),
        (12, N'Navigate form to another record', NULL, N'Products > Click hyperlink > Go to Product', N'Find a record by selecting a value from a list#https://support.microsoft.com/office/enable-users-to-find-a-record-by-selecting-a-value-from-a-list-e3ed7711-433a-4931-9cab-b0f71a90c329#', N'Find a record by selecting a value from a list', 1),
        (13, N'Apply predefined filter', NULL, N'Orders
Orders > Click hyperlink > Recent Orders', N'Apply Filter to Forms#https://support.microsoft.com/office/filter-property-18be7152-a700-4f34-9768-74da413766a5#', N'Filter Forms', 1),
        (14, N'Attachments', N'Files that are associated with a record', N'Employees > Click hyperlink > Employee picture', N'Attach files and graphics to records#https://support.microsoft.com/article/d40a09ad-a753-4a14-9161-7f15baad6dbd#', N'Attach Fields', 1),
        (15, N'Editable value list', N'Dropdown allowing user to edit list items', N'Employees > Click hyperlink > Title', NULL, N'Editable Value Lists', 1),
        (16, N'Split form Splitter bar', NULL, N'Customer List; the splitter bar is just above the grid column headers. Grab it and pull it down.', NULL, N'Split Form', 1),
        (17, N'Show/Hide columns in a datasheet view', NULL, N'Customer List', NULL, N'Working with Datasheets', 1),
        (18, N'Reorder and resize columns', N'All Datasheet views can do this.', N'Customer List', NULL, N'Working with Datasheets', 1),
        (19, N'Open a web page', NULL, N'Customers > Click hyperlink > Website', NULL, N'Create or delete a Hyperlink field', 1),
        (20, N'Open a map to an address', NULL, N'Customers > Click hyperlink > Click to Map', NULL, NULL, NULL),
        (21, N'Phone number formatting', N'Input mask can allow for extra text', N'Customers > Click hyperlink > Business Phone', N'Use Input Masks to control data entry formats#https://support.microsoft.com/office/control-data-entry-formats-with-input-masks-e125997a-7791-49e5-8672-4a47832de8da#', N'Input Mask', 1),
        (22, N'Formatting of text', N'Called "Rich Text" in Access', N'Employees > Click hyperlink > Notes
Products > Product Description field', N'Formatting Rich Text#https://support.microsoft.com/office/enable-or-disable-full-rich-text-formatting-in-a-rich-text-box-d3c71c1d-8c88-41e9-9ee5-2ca6a3d0ea67#', N'Rich Text', 1),
        (23, N'Photo', NULL, N'Employees > Click hyperlink > Employee picture', N'Attach Fields and Graphics to Records in your Database#https://support.microsoft.com/office/attach-files-and-graphics-to-the-records-in-your-database-d40a09ad-a753-4a14-9161-7f15baad6dbd#', N'Attach Fields', 1),
        (24, N'Create Email', NULL, N'Employees > Click hyperlink > Email  Address', N'Follow a Hyperlink in Access#https://learn.microsoft.com/office/vba/api/Access.Application.FollowHyperlink#', N'Create or delete a Hyperlink field', 1),
        (25, N'Export data', N'To Excel or other formats', N'Products > Export to File', N'Introduction to importing, linking and exporting data in Access#https://support.microsoft.com/office/introduction-to-importing-linking-and-exporting-data-in-access-08422593-42dd-4e73-bdf1-4c21fc3aa1b0#', NULL, 1),
        (26, N'Create orders programmatically', NULL, N'Admin > Internet Orders', NULL, NULL, NULL),
        (27, N'Reset all dates programmatically', N'So you''re working with current data', N'Admin > Reset Dates', NULL, NULL, NULL),
        (28, N'Charts and Graphs', N'These are called "Modern Chart"', N'Reports > Sales Reports', N'Introducing new and modern chart types in Access#https://techcommunity.microsoft.com/t5/access-blog/introducing-new-and-modern-chart-types/ba-p/193479#', N'New and Modern  Charts', 1),
        (29, N'Automatic resizing of controls', N'This is called "Control Anchoring"', N'Orders > Click hyperlink > resize vertically', N'Make controls stretch, shrink or move as you resize a form#https://support.microsoft.com/office/make-controls-stretch-shrink-or-move-as-you-resize-a-form-51fd88e0-43d3-4070-a298-18ba273f4cf8#', N'Stretch Controls', 1),
        (30, N'Automatic tracking of Create and Modified user and date', N'Data Macros are created in table design view.', N'Open any table in Design view > Create Data Macros > Before Change', N'Create a data macro#https://support.microsoft.com/office/create-a-data-macro-b1b94bca-4f17-47ad-a66d-f296ef834200#', N'Data Macros in Access', 1),
        (31, N'Things to help you on your journey', N'Links and comments you might find helpful', N'Link to Things you should know Developer Edition', NULL, NULL, NULL),
        (32, N'Error Handling', N'Global Error Handler in VBA', N'Link to Things you should know Developer Edition', NULL, NULL, NULL),
        (33, N'Create custom ribbon', NULL, N'n/a', N'Create Custom Ribbon#https://support.microsoft.com/article/45e110b9-531c-46ed-ab3a-4e25bc9413de#', NULL, 2),
        (34, N'Access Glossary', N'Common terminology used by Access', N'n/a', N'Access Glossary#https://support.microsoft.com/article/29ab26b7-1f36-4da4-9e75-479f8e6e3c35#', NULL, 2),
        (35, N'Data Macros', N'Adding data macros in a desktop database', N'n/a', N'Data Macros#https://support.microsoft.com/article/74a736ec-9bff-4ad1-b27b-dbe63c07784c#', NULL, 2),
        (36, N'Run macro at startup', N'Create a macro that runs when you open a database', N'n/a', N'Run macro at startup#https://support.microsoft.com/article/98ba1508-dcc6-4e0f-9698-a4755e548124#', NULL, 2),
        (37, N'Filter Property', NULL, N'Companies > click a radio button in the header > Show Filter', N'Filter Property#https://support.microsoft.com/article/18be7152-a700-4f34-9768-74da413766a5#', NULL, 2),
        (38, N'Navigation Pane', N'Use the Navigation Pane', N'n/a', N'Navigation Pane#https://support.microsoft.com/article/274dfc5a-281b-472b-94e2-ef931c5cc590#', NULL, 2),
        (39, N'MRU List', N'Most Recently Used orders and purchase orders dropdown in the Ribbon', N'Ribbon', N'TODO: Link to NW2 Help Page##', N'ribbon dropdown mru', 2),
        (40, N'Listbox form navigation', N'An unbound Listbox control used to navigate to a selected record in a form', N'System Admin > Product Categories', N'Listbox Object#https://learn.microsoft.com/office/vba/api/access.listbox#', N'Enable users to find a record by selecting a value from a list', 1);
    SET IDENTITY_INSERT [NorthwindFeatures] OFF;
END