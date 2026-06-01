-- Combined Data Inserts (FK dependency order)
-- Insert order: Catalog_TableOfContents -> CompanyTypes -> Learn -> NorthwindFeatures -> OrderDetailStatus -> OrderStatus -> Privileges -> ProductCategories -> PurchaseOrderStatus -> States -> Strings -> SystemSettings -> TaxStatus -> Titles -> UserSettings -> USysRibbons -> Welcome -> Products -> Companies -> Employees -> StockTake -> Contacts -> ProductVendors -> EmployeePrivileges -> MRU -> Orders -> PurchaseOrders -> OrderDetails -> PurchaseOrderDetails

-- === Catalog_TableOfContents ===
IF NOT EXISTS (SELECT 1 FROM [Catalog_TableOfContents])
BEGIN
    INSERT INTO [Catalog_TableOfContents] ([TocTitle], [TocPage])
    VALUES
        (N'Baked Goods & Mixes', 4),
        (N'Beverages', 4),
        (N'Candy', 4),
        (N'Canned Fruit & Vegetables', 5),
        (N'Canned Meat', 5),
        (N'Cereal', 5),
        (N'Chips, Snacks', 5),
        (N'Condiments', 6),
        (N'Dairy Products', 6),
        (N'Dried Fruit & Nuts', 6),
        (N'Grains', 6),
        (N'Jams, Preserves', 7),
        (N'Oil', 7),
        (N'Pasta', 7),
        (N'Sauces', 7),
        (N'Soups', 8);
END

-- === CompanyTypes ===
IF NOT EXISTS (SELECT 1 FROM [CompanyTypes])
BEGIN
    SET IDENTITY_INSERT [CompanyTypes] ON;
    INSERT INTO [CompanyTypes] ([CompanyTypeID], [CompanyType], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Customer', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Shipper', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'Vendor', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Northwind', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [CompanyTypes] OFF;
END

-- === Learn ===
IF NOT EXISTS (SELECT 1 FROM [Learn])
BEGIN
    SET IDENTITY_INSERT [Learn] ON;
    INSERT INTO [Learn] ([ID], [SectionNo], [SectionText])
    VALUES
        (1, 10, N'<div><font size=5>Welcome!</font></div>

<div>The Northwind 2.0 Developer Edition Template expands on the concepts of the Northwind 2.0 Starter edition, with a more complete data model and more sophisticated features. To learn more, select any of the following topics.</div>'),
        (2, 20, N'<div><font size=5>About the Template</font></div>

<div>The Northwind 2.0 Developer Edition template showcases major features of Access; it is not designed to run a company nor show you how to build such an application. </div>

<div>&nbsp;</div>

<div><strong><em>Northwind </em></strong>is a fictitious trading company whose customers are independent grocery stores.</div>

<div>&nbsp;</div>

<ul>
 <li>Customers call in orders or place them over the internet. In this template, Internet orders are a mockup.</li>
 <li>Northwind invoices, ships, collects payments, and closes orders. Purchase orders and inventory management are also included in this edition.</li>
</ul>

<div>&nbsp;</div>

<div>Sample data in the template will help you started quickly. </div>'),
        (3, 30, N'<div><font size=5>How to Navigate</font></div>

<div><font size=4>Home Ribbon</font></div>

<div>This template implements navigation using a custom Home ribbon.</div>'),
        (4, 40, N'<div>The left side of the custom Home ribbon contains Northwind application menu navigation.</div>

<div>&nbsp;</div>

<ul>
 <li><font size=4>MRU</font> </li>
</ul>

<div>&nbsp;</div>

<blockquote>

<div>MRU = Most Recently Used. This ribbon menu item contains a combo box that is refreshed when an order or a purchase order is added or deleted. This enables the current user to quickly revisit their most recently added orders and purchase orders.</div>

</blockquote>'),
        (5, 50, N'<div>Visit <strong>Home &gt; Help Topics &gt; Northwind Features</strong> to learn how Northwind 2.0 Developer Edition implements this concept.</div>

<div>&nbsp;</div>

<ul>
 <li>Orders</li>
 <li>Maintenance</li>
 <li>Reports</li>
</ul>

<div>&nbsp;</div>

<div>The right side contains a group of <strong>Help Topics</strong>:</div>

<div>&nbsp;</div>

<ul>
 <li><strong>Learn </strong>displays this “Welcome” panel.</li>
 <li><strong>Northwind Features</strong> displays a list of features implemented in this template, with navigation tips to view the features’ implementation in the application, and links to Online and in-application Help topics for further exploration.</li>
 <li><strong>About Northwind</strong> displays a very brief history of this template’s conception and development.</li>
</ul>

<div>&nbsp;</div>

<ul>
 <li>In addition to these ribbon buttons, many forms have a Help button</li>
</ul>'),
        (6, 60, N'<div>which opens a form-specific help page.</div>

<div>&nbsp;</div>

<div><font size=4>“Develop” Ribbon</font></div>

<div>&nbsp;</div>

<div>Common development tools are grouped here. For a production environment, you might want to make this invisible.</div>'),
        (7, 70, N'<div><font size=5>Northwind Features</font></div>

<div>Northwind 2.0 Developer edition includes a feature matrix accessible from the custom Home ribbon Northwind Features button. It contains a list of notable concepts implemented in this version. Each concept topic outlines how you can view an example of it within the Northwind 2.0 Developer template, as well as handy links to learn more about the topic:</div>

<div>&nbsp;</div>

<ul>
 <li><strong>Click for On-Line Help</strong> opens a Web page addressing the topic.</li>
 <li><strong>Click for in-App Help</strong> opens the access application’s internal Help library to the topic.</li>
</ul>

<div>&nbsp;</div>

<div><font size=5>Multiple Form Instances</font></div>

<div>By default, Access forms can be instantiated only once. In this template, Northwind Orders and Purchase Orders forms (frmOrderDetails and frmPurchaseOrderDetails) can be instantiated multiple times concurrently. In these forms, follow the</div>'),
        (8, 80, N'<div>for a deeper dive into how this is accomplished.</div>

<div>&nbsp;</div>

<div><font size=5>Cascading Combo Boxes</font></div>

<div>Refer to the Orders form for a method of implementing cascading combo boxes where a Product Categories combobox leads to a Products combobox with only the products for the selected category.</div>

<div>&nbsp;</div>

<div><font size=5>Validating Required Fields</font></div>

<div>This edition features the VBA function ValidateForm() to highlight required form fields that are empty. For an example, try creating an Order without completing fields Customer and Tax Status. You can further investigate how this was accomplished using the</div>'),
        (9, 90, N'<div>on the Order screen.</div>

<div>&nbsp;</div>

<div><font size=5>“Lazy Loading” Subforms</font></div>

<div>Sometimes referred to as “late binding,” lazy loading in a tab control delays loading a tab’s subform contents until the tab is selected. By default, Access loads subforms before loading the form itself. Late binding can improve form performance (loading speed).</div>

<div>&nbsp;</div>

<div>See the Product Detail form.</div>

<div>&nbsp;</div>

<div><font size=5>Street Address Map Link</font></div>

<div>The Company Detail form (frmCompanyDetail) features a <strong>Map </strong>button that opens the default Web browser to a map of the company’s address. Northwind 2.0 Developer implements this using Microsoft Bing maps, but could use any Web-based map site, such as Google Maps or MapQuest.</div>

<div>&nbsp;</div>

<div><font size=5>Show Filter</font></div>

<div>Company List and Company Detail forms also demonstrate a means to allow users to view a form’s current filters.</div>'),
        (10, 100, N'<div><font size=5>Workflows</font></div>

<div>Both <strong>Orders </strong>and <strong>Purchase Orders</strong> implement very simple workflows. These demonstrate a means for controlling the sequence of data updates required to enforce business rules for moving an order from one status to the next.</div>

<div>&nbsp;</div>

<div><font size=5>Reports</font></div>

<div><strong>Report Fall Catalog</strong> - demonstrates a number of more advanced report development topics</div>

<div>&nbsp;</div>

<ul>
 <li>Multiple sections (Introduction, TOC, Categories, Order form)</li>
 <li>TOC and pagination</li>
 <li>Resulting report is a publisher-quality catalog</li>
</ul>

<div>&nbsp;</div>

<div><strong>Monthly Sales By Employee</strong> – The report can be filtered at runtime in Report View.</div>

<div>&nbsp;</div>

<div><font size=5>Database Design</font></div>

<div>Northwind has a simple but correct Relational Database Design.</div>

<div>&nbsp;</div>

<div>Tables hold specific information about Northwind''s business.</div>

<div>&nbsp;</div>

<div>Fields in the tables have specific properties set to make them required or to enforce a certain data type (for example, numeric, date, and yes/no).</div>

<div>&nbsp;</div>

<div>Relations between tables enforce business rules and ensure data consistency (for example, an order must be for an existing customer).</div>

<div>&nbsp;</div>

<div>To explore Northwind''s database design, press F11 to open the Navigation Pane which displays tables and other objects, or choose Develop &gt; Relationships in the ribbon.</div>'),
        (11, 110, N'<div><font size=5>Programming and Visual Basic for Applications (VBA)</font></div>

<div>This edition features more extensive implementation using VBA instead of macros.</div>

<div>&nbsp;</div>

<div>Examining the VBA modules, you may find examples of alternate or <em>Equivalent Syntax</em>. This is included to help you recognize different syntax that accomplishes exactly or approximately the same result.</div>

<div>&nbsp;</div>

<div>Programming facilitates application flow (for example, Opening the next form) or enforces business rules (for example, you cannot update an Order status to “Closed” without first receiving payment for it).</div>

<div>&nbsp;</div>

<div>Northwind Developer uses different examples of Programming to show Access capabilities:</div>

<div>&nbsp;</div>

<ul>
 <li>Expressions in the Employees table create the <em>FullNameFNLN </em>and <em>FullNameLNFN </em>fields. An expression field in a table can be used elsewhere, for example, to show the employee''s full name in the Access main window title.</li>
</ul>'),
        (12, 120, N'<ul>
 <li>In Northwind 2.0 Developer Edition, macros are replaced with VBA procedures. To view the VBA editor, press Alt+F11.</li>
</ul>

<div>&nbsp;</div>

<div>By default, Access creates macros when you use Wizards, such as when dropping a button on a form in design view. Access can convert macros to VBA for you: In form Design view, <strong>Design &gt; Tools &gt; Convert Form’s Macros to Visual Basic.</strong></div>'),
        (13, 130, N'<div>To explore form programming, open the form in Design view, then select <strong>Form Design &gt; Property Sheet</strong> to inspect the properties of the selected object. Most of the code is accessed from the <strong>Events </strong>tab of the property sheet, as shown below.</div>'),
        (14, 140, N'<div><font size=5>Additional Documentation</font></div>

<div>Most Northwind forms contain a special help link denoted with the symbol:</div>'),
        (15, 150, N'<div>This symbol will link contextually to Microsoft web pages devoted to all things Northwind, featuring detailed discussions on the Northwind application form objects, their showcased functionality, and how it was accomplished.</div>');
    SET IDENTITY_INSERT [Learn] OFF;
END

-- === NorthwindFeatures ===
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

-- === OrderDetailStatus ===
IF NOT EXISTS (SELECT 1 FROM [OrderDetailStatus])
BEGIN
    SET IDENTITY_INSERT [OrderDetailStatus] ON;
    INSERT INTO [OrderDetailStatus] ([OrderDetailStatusID], [OrderDetailStatusName], [SortOrder], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Allocated', 40, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Invoiced', 50, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'New', 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'No Stock', 20, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'On Order', 30, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'Shipped', 60, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [OrderDetailStatus] OFF;
END

-- === OrderStatus ===
IF NOT EXISTS (SELECT 1 FROM [OrderStatus])
BEGIN
    SET IDENTITY_INSERT [OrderStatus] ON;
    INSERT INTO [OrderStatus] ([OrderStatusID], [OrderStatusCode], [OrderStatusName], [SortOrder], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'CLO', N'Closed', 40, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'INV', N'Invoiced', 20, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'NEW', N'New', 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'SHI', N'Shipped', 30, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'PAY', N'Paid', 35, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [OrderStatus] OFF;
END

-- === Privileges ===
IF NOT EXISTS (SELECT 1 FROM [Privileges])
BEGIN
    SET IDENTITY_INSERT [Privileges] ON;
    INSERT INTO [Privileges] ([PrivilegeID], [PrivilegeName], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Purchase Approvals', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Privileges] OFF;
END

-- === ProductCategories ===
IF NOT EXISTS (SELECT 1 FROM [ProductCategories])
BEGIN
    SET IDENTITY_INSERT [ProductCategories] ON;
    INSERT INTO [ProductCategories] ([ProductCategoryID], [ProductCategoryName], [ProductCategoryCode], [ProductCategoryDesc], [ProductCategoryImage], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Baked Goods & Mixes', N'BAK', N'Baked Goods and Baking Mixes', N'Baked3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Beverages', N'BEV', N'Coffee, Soda, Water, Juices and Beers', N'Beverage3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'Candy', N'CDY', N'Chocolate, Hard Candy and Mints', N'Candy3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Canned Fruit & Vegetables', N'CFV', N'Fruits and Vegetables in Cans and Jars', N'Canned Fruit.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'Canned Meat', N'CM', N'Tinned Fish, Beef and Pork', N'Canned Meat2.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'Cereal', N'CER', N'Oatmeal, Granola and Boxed Cereals', N'Cereal2.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, N'Chips, Snacks', N'SNK', N'Chips, Pretzels, Popcorn and Cheese Puffs', N'Chips3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, N'Condiments', N'CON', N'Whole and Ground Spices, Herbs and Bottled Sauces', N'Condiment3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, N'Dairy Products', N'DAI', N'Milk and Cheese from Satisfied Cows', N'Dairy.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, N'Dried Fruit & Nuts', N'DRI', N'Raw and Roasted Nuts, Seeds and Dehydrated Fruits', N'Dried Fruit3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, N'Grains', N'GRA', N'Rice, Whole Wheat and Oats', N'Grains.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, N'Jams, Preserves', N'JAM', N'Preserved Fruit in Jars', N'Jam2.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, N'Oil', N'OIL', N'Cooking and Salad Oils', N'Oil.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, N'Pasta', N'PAS', N'Dried Wheat and Rice Pasta in Various Shapes and Varieties', N'Pasta3.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, N'Sauces', N'SAU', N'Tomato Sauces, Gravies and Hot Sauce', N'Sauce.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, N'Soups', N'SOU', N'Canned Soups, Chowders and Bisques', N'Soup.jpg', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [ProductCategories] OFF;
END

-- === PurchaseOrderStatus ===
IF NOT EXISTS (SELECT 1 FROM [PurchaseOrderStatus])
BEGIN
    SET IDENTITY_INSERT [PurchaseOrderStatus] ON;
    INSERT INTO [PurchaseOrderStatus] ([StatusID], [StatusName], [SortOrder], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'Approved', 30, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'Closed', 50, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'New', 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'Submitted', 20, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'Received', 40, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [PurchaseOrderStatus] OFF;
END

-- === States ===
IF NOT EXISTS (SELECT 1 FROM [States])
BEGIN
    INSERT INTO [States] ([StateAbbrev], [StateName])
    VALUES
        (N'AK', N'Alaska'),
        (N'AL', N'Alabama'),
        (N'AR', N'Arkansas'),
        (N'AZ', N'Arizona'),
        (N'CA', N'California'),
        (N'CO', N'Colorado'),
        (N'CT', N'Connecticut'),
        (N'DC', N'District of Columbia'),
        (N'DE', N'Delaware'),
        (N'FL', N'Florida'),
        (N'GA', N'Georgia'),
        (N'HI', N'Hawaii'),
        (N'IA', N'Iowa'),
        (N'ID', N'Idaho'),
        (N'IL', N'Illinois'),
        (N'IN', N'Indiana'),
        (N'KS', N'Kansas'),
        (N'KY', N'Kentucky'),
        (N'LA', N'Louisiana'),
        (N'MA', N'Massachusetts'),
        (N'MD', N'Maryland'),
        (N'ME', N'Maine'),
        (N'MI', N'Michigan'),
        (N'MN', N'Minnesota'),
        (N'MO', N'Missouri'),
        (N'MS', N'Mississippi'),
        (N'MT', N'Montana'),
        (N'NC', N'North Carolina'),
        (N'ND', N'North Dakota'),
        (N'NE', N'Nebraska'),
        (N'NH', N'New Hampshire'),
        (N'NJ', N'New Jersey'),
        (N'NM', N'New Mexico'),
        (N'NV', N'Nevada'),
        (N'NY', N'New York'),
        (N'OH', N'Ohio'),
        (N'OK', N'Oklahoma'),
        (N'OR', N'Oregon'),
        (N'PA', N'Pennsylvania'),
        (N'RI', N'Rhode Island'),
        (N'SC', N'South Carolina'),
        (N'SD', N'South Dakota'),
        (N'TN', N'Tennessee'),
        (N'TX', N'Texas'),
        (N'UT', N'Utah'),
        (N'VA', N'Virginia'),
        (N'VT', N'Vermont'),
        (N'WA', N'Washington'),
        (N'WI', N'Wisconsin'),
        (N'WV', N'West Virginia'),
        (N'WY', N'Wyoming');
END

-- === Strings ===
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

-- === SystemSettings ===
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

-- === TaxStatus ===
IF NOT EXISTS (SELECT 1 FROM [TaxStatus])
BEGIN
    INSERT INTO [TaxStatus] ([TaxStatusID], [TaxStatus], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (0, N'Tax Exempt', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (1, N'Taxable', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
END

-- === Titles ===
IF NOT EXISTS (SELECT 1 FROM [Titles])
BEGIN
    INSERT INTO [Titles] ([Title], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (N'', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (N'Mr.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (N'Ms.', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
END

-- === UserSettings ===
IF NOT EXISTS (SELECT 1 FROM [UserSettings])
BEGIN
    SET IDENTITY_INSERT [UserSettings] ON;
    INSERT INTO [UserSettings] ([SettingID], [SettingName], [SettingValue], [Notes])
    VALUES
        (2, N'AutoLogin', N'0', N'[boolean]');
    SET IDENTITY_INSERT [UserSettings] OFF;
END

-- === USysRibbons ===
IF NOT EXISTS (SELECT 1 FROM [USysRibbons])
BEGIN
    SET IDENTITY_INSERT [USysRibbons] ON;
    INSERT INTO [USysRibbons] ([ID], [RibbonName], [RibbonXML])
    VALUES
        (1, N'Main', N'<customUI xmlns="http://schemas.microsoft.com/office/2006/01/customui" onLoad="ribbonLoaded">
	<!-- Do not start from scratch; suppress built-ins instead. -->
	<ribbon startFromScratch="false">
		<tabs>
			<tab id="tHome" label="Home">
				<group id="gCurrentStatus" label="MRU">
					<box id="bxMRU" boxStyle="vertical">
						<dropDown id="ddMRU"
						          getItemCount="ddMRU_GetItemCount"
						          getItemLabel="ddMRU_GetItemLabel"
						          getSelectedItemIndex="ddMRU_GetSelectedItemIndex"
						          getItemID="ddMRU_GetItemID"
						          onAction="ddMRU_OnAction"
						          screentip="Most Recently Used Objects">
						</dropDown>
					</box>
				</group>
				<group id="gOrders" label="Orders">
					<button id="cmdOrders"
					        label="Orders"
					        size="large"
					        imageMso="CatalogMergeFindRecipient"
					        onAction="cmdOrders_OnAction"/>
					<button id="cmdAddOrder"
					        label="Add Order"
					        size="large"
					        imageMso="AdpNewTable"
					        onAction="cmdAddOrder_OnAction"/>
					<button id="cmdPurchaseOrders"
					        label="Purchase Orders"
					        size="large"
					        imageMso="WindowsCascade"
					        onAction="cmdPurchaseOrders_OnAction"/>
					<button id="cmdAddPurchaseOrder"
					        label="Add Purchase Order"
					        size="large"
					        imageMso="WindowNew"
					        onAction="cmdAddPurchaseOrder_OnAction"/>
				</group>
				<group id="gMaintenance" label="Maintenance">
					<button id="cmdCustomers"
					        label="Companies"
					        size="large"
					        imageMso="BusinessCardInsertMenu"
					        onAction="cmdCustomers_OnAction"/>
					<button id="cmdProducts"
					        label="Products"
					        size="large"
					        imageMso="MaterialResourceInsert"
					        onAction="cmdProducts_OnAction"/>
					<button id="cmdEmployees"
					        label="Employees"
					        size="large"
					        imageMso="MeetingsWorkspace"
					        onAction="cmdEmployees_OnAction"/>
					<button id="cmdAdmin"
					        label="System Admin"
					        size="large"
					        imageMso="ControlsGalleryClassic"
					        onAction="cmdAdmin_OnAction"/>
				</group>
				<group id="gReports" label="Reports" visible="true">
					<button id="cmdReports"
					        label="Reports"
					        size="large"
					        imageMso="ViewsReportView"
					        onAction="cmdReports_OnAction"/>
				</group>
				<group id="gExport" label="Export">
					<button id="cmdExportToExcel"
					        label="Export to Excel"
					        size="large"
					        imageMso="ExportExcel"
					        onAction="cmdExportToExcel_OnAction"/>
				</group>
				<group id="gReportOptions" label="Report Options" getVisible="gReportOptions_GetVisible">
					<button idMso="PrintDialogAccess" size="large"/>
					<button idMso="FilePrintQuick" size="large"/>
					<button idMso="FileSendAsAttachment" size="large"/>
					<button idMso="PublishToPdfOrEdoc" size="large"/>
					<button idMso="PrintPreviewClose" size="large"/>
				</group>
				<group id="gAbout" label="Help Topics">
					<button id="cmdLearn"
					        label="Learn"
					        size="large"
					        imageMso="WatchWindow"
					        onAction="cmdLearn_OnAction"/>
					<button id="cmdFeatures"
					        label="Northwind Features"
					        size="large"
					        imageMso="HelpDevResources"
					        onAction="cmdFeatures_OnAction"/>
					<button id="cmdNorthwindDocumentation"
					        label="Northwind Documentation"
					        size="large"
					        imageMso="HelpDevResources"
					        onAction="cmdNorthwindDocumentation_OnAction"/>
					<button id="cmdAbout"
					        label="About Northwind"
					        size="large"
					        imageMso="GroupAuthors"
					        onAction="cmdAbout_OnAction"/>
				</group>
				<group id="gExit" label="Exit Application">
					<button id="cmdExitApplication"
					        imageMso="PrintPreviewClose"
					        size="large"
					        label="Exit"
					        onAction="cmdExitApplication_OnAction"/>
				</group>
			</tab>

			<!-- Built-in tabs -->
			<tab idMso="TabPrintPreviewAccess" label="Original Print Preview" visible="false"/>
			<tab idMso="TabHomeAccess" label="Original Home" visible="false"/>
			<tab idMso="TabCreate" label="Original Create" visible="false"/>
			<tab idMso="TabExternalData" label="Original External Data" visible="false"/>
			<tab idMso="TabDatabaseTools" label="Original Database Tools" visible="false"/>
			<!-- Rarely use Source Control, not worth customizing -->
			<tab idMso="TabSourceControl" label="Original Source Control" visible="false"/>
			<!-- Normally this may be desirable to disable AddIns tab but to avoid confusion I''m leaving this alone for now. -->
			<tab idMso="TabAddIns" label="AddIns" visible="true"/>
			<!-- Custom tabs -->
			<tab id="DevelopTab" label="Develop">
				<group id="ViewGroup" label="View or Run">
					<splitButton idMso="ViewsModeMenu" size="large">
					</splitButton>
					<button idMso="QueryRunQuery" size="large"/>
				</group>
				<group id="EditGroup" label="Edit">
					<box id="EditBox1" boxStyle="horizontal">
						<button idMso="Cut"/>
						<button idMso="Copy"/>
						<splitButton id="PasteIt">
							<button idMso="Paste"/>
							<menu id="PasteMenu">
								<button idMso="Paste"/>
								<button idMso="PasteSpecialDialog"/>
								<button idMso="PasteAppend"/>
							</menu>
						</splitButton>
					</box>
					<box id="EditBox2" boxStyle="horizontal">
						<gallery idMso="Undo"/>
						<gallery idMso="Redo"/>
					</box>
					<box id="EditBox3" boxStyle="horizontal">
						<comboBox idMso="FormattingFormat"/>
						<control idMso="FormatPainter" label="Paint"/>
					</box>
				</group>
				<group id="TableGroup" label="Tables and Relationship">
					<splitButton id="CreateTableSplitButton" size="large">
						<button idMso="CreateTableInDesignView"/>
						<menu id="CreateTableMenu">
							<button idMso="CreateTableInDesignView"/>
							<button idMso="CreateTable"/>
							<gallery idMso="CreateTableTemplatesGallery"/>
							<gallery idMso="CreateTableUsingSharePointListsGallery"/>
						</menu>
					</splitButton>
					<splitButton id="DatabaseRelationshipsSplitButton" size="large">
						<button idMso="DatabaseRelationships"/>
						<menu id="RelationshipsMenu">
							<button idMso="DatabaseRelationships"/>
							<toggleButton idMso="DatabaseObjectDependencies"/>
						</menu>
					</splitButton>
				</group>
				<group id="ExternalDataGroup" label="External Data">
					<menu id="ImportMenu" label="Import or Link" imageMso="ImportMoreMenu" size="large">
						<menuSeparator id="ImportLink" title="Link tables"/>
						<button idMso="FileServerLinkTables"/>
						<menuSeparator id="ImportMicrosoft" title="Import from Office"/>
						<button idMso="ImportAccess"/>
						<button idMso="ImportExcel"/>
						<button idMso="ImportOutlook"/>
						<button idMso="ImportSharePointList"/>
						<menuSeparator id="ImportOdbc" title="Import from ODBC"/>
						<button idMso="ImportOdbcDatabase"/>
						<menuSeparator id="ImportFlatFile" title="Import from flat files"/>
						<button idMso="ImportTextFile"/>
						<button idMso="ImportHtmlDocument"/>
						<button idMso="ImportXmlFile"/>
						<button idMso="ImportSavedImports"/>
						<menuSeparator id="ImportISAM" title="Import from ISAM"/>
						<button idMso="ImportDBase"/>
						<button idMso="ImportParadox"/>
						<button idMso="ImportLotus"/>
					</menu>
					<menu id="ExportMenu" label="Export" imageMso="ExportMoreMenu" size="large">
						<menuSeparator id="ExportMicrosoft" title="Export to Office"/>
						<button idMso="ExportAccess"/>
						<button idMso="ExportExcel"/>
						<button idMso="ExportWord"/>
						<button idMso="ExportSharePointList"/>
						<menuSeparator id="ExportOdbc" title="Export to ODBC"/>
						<button idMso="ExportOdbcDatabase"/>
						<menuSeparator id="ExportFlatFiles" title="Export to flat files"/>
						<button idMso="ExportTextFile"/>
						<button idMso="ExportHtmlDocument"/>
						<button idMso="ExportXmlFile"/>
						<button idMso="ExportSavedExports"/>
						<menuSeparator id="ExportISAM" title="Export to ISAM"/>
						<button idMso="ExportDBase"/>
						<button idMso="ExportParadox"/>
						<button idMso="ExportLotus"/>
						<menuSeparator id="ExportSnapshot" title="Export as PDF"/>
						<!-- <button idMso="ExportSnapshot" /> -->
						<button idMso="PublishToPdfOrEdoc"/>
					</menu>
					<splitButton id="LinkedTableSplitButton" size="large">
						<button idMso="DatabaseLinedTableManager"/>
						<menu id="LinkedTableMenu">
							<button idMso="DatabaseLinedTableManager"/>
							<button idMso="DatabaseAccessBackEnd" label="Split Database"/>
						</menu>
					</splitButton>
				</group>
				<group id="ObjectGroup" label="Create Objects">
					<splitButton id="QuerySplitButton" size="large">
						<button idMso="CreateQueryInDesignView"/>
						<menu id="QueryMenu">
							<button idMso="CreateQueryInDesignView"/>
							<button idMso="CreateQueryFromWizard"/>
						</menu>
					</splitButton>
					<splitButton id="FormSplitButton" size="large">
						<button idMso="CreateFormInDesignView"/>
						<menu id="FormMenu">
							<button idMso="CreateFormInDesignView"/>
							<button idMso="CreateFormBlankForm"/>
							<button idMso="CreateForm"/>
							<button idMso="CreateFormSplitForm"/>
							<button idMso="CreateFormWithMultipleItems"/>
							<menuSeparator id="SwitchBoardSeparator" title="Switchboard"/>
							<button idMso="DatabaseSwitchboardManager"/>
							<button idMso="BusinessFormWizard"/>
						</menu>
					</splitButton>
					<splitButton id="ReportSplitButton" size="large">
						<button idMso="CreateReportInDesignView"/>
						<menu id="ReportMenu">
							<button idMso="CreateReportInDesignView"/>
							<button idMso="CreateReportBlankReport"/>
							<button idMso="CreateReport"/>
							<button idMso="CreateLabels"/>
							<button idMso="CreateReportFromWizard"/>
						</menu>
					</splitButton>
					<splitButton id="MacroSplitButton" size="large">
						<button idMso="CreateMacro"/>
						<menu id="MacroMenu">
							<button idMso="CreateMacro"/>
							<button idMso="CreateShortcutMenuFromMacro"/>
						</menu>
					</splitButton>
					<splitButton id="VBASplitButton" size="large">
						<button idMso="VisualBasic"/>
						<menu id="VBAMenu">
							<button idMso="VisualBasic"/>
							<button idMso="CreateModule"/>
							<button idMso="CreateClassModule"/>
							<menuSeparator id="ConvertMacroSeparator" title="Convert Macros to VBA"/>
							<button idMso="MacroConvertMacrosToVisualBasic"/>
						</menu>
					</splitButton>
				</group>
				<group id="AdministerGroup" label="Administer">
					<splitButton id="AdministerSplitButton" size="large">
						<button idMso="FileCompactAndRepairDatabase" label="Compact and Repair"/>
						<menu id="AdministerMenu">
							<button idMso="FileCompactAndRepairDatabase"/>
							<button idMso="FileBackupDatabase"/>
							<button idMso="DatabaseCopyDatabaseFile"/>
							<menuSeparator id="ConvertFileSeparator" title="Convert to different version"/>
							<button idMso="FileSaveAsAccess2007"/>
							<button idMso="FileSaveAsAccess2002_2003"/>
							<button idMso="FileSaveAsAccess2000"/>
							<menuSeparator id="SecuritySeparator" title="Secure the file"/>
							<button idMso="SetDatabasePassword"/>
							<button idMso="DatabaseMakeMdeFile"/>
							<button idMso="FilePackageAndSign"/>
							<menuSeparator id="AnalyzeSeparator" title="Analyze/Document"/>
							<button idMso="DatabaseAnalyzeTable"/>
							<button idMso="DatabaseAnalyzePerformance"/>
							<button idMso="DatabaseDocumenter"/>
							<menuSeparator id="CustomizeSeparator" title="Customize"/>
							<button idMso="QuickAccessToolbarCustomization"/>
							<menu idMso="AddInsMenu"/>
							<button idMso="ComAddInsDialog"/>
						</menu>
					</splitButton>
					<button idMso="ApplicationOptionsDialog" size="large"/>
				</group>
				<group id="HelpGroup" label="Help">
					<button idMso="Help" size="large" label="Help"/>
				</group>
			</tab>
		</tabs>
		<contextualTabs>
			<!-- Built-in contextual tabs will be used -->
			<!-- To suppress the built-in tabs, change visible to false, rename the label to "Original <whatever>" then add new tab with a new id, same label -->
			<!-- The ordering of tabSets are roughly Tables, Queries, Forms, Reports, Macros -->
			<tabSet idMso="TabSetTableToolsDesign">
				<tab idMso="TabTableToolsDesignAccess" label="Design" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetTableToolsDatasheet">
				<tab idMso="TabTableToolsDatasheet" label="Datasheet" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetRelationshipTools">
				<tab idMso="TabRelationshipToolsDesign" label="Design" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetQueryTools">
				<tab idMso="TabQueryToolsDesign" label="Design" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetFormTools">
				<tab idMso="TabFormToolsDesign" label="Design" visible="true"/>
				<tab idMso="TabFormToolsLayout" label="Arrange" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetFormToolsLayout">
				<tab idMso="TabFormToolsFormatting" label="Format" visible="true"/>
				<tab idMso="TabControlLayout" label="Arrange" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetReportTools">
				<tab idMso="TabReportToolsDesign" label="Design" visible="true"/>
				<tab idMso="TabReportToolsAlignment" label="Arrange" visible="true"/>
				<tab idMso="TabReportToolsPageSetupDesign" label="Page Setup" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetReportToolsLayout">
				<tab idMso="TabReportToolsFormatting" label="Format" visible="true"/>
				<tab idMso="TabReportToolsLayout" label="Layout" visible="true"/>
				<tab idMso="TabReportToolsPageSetupLayout" label="Page Setup" visible="true"/>
			</tabSet>
			<tabSet idMso="TabSetMacroTools">
				<tab idMso="TabMacroToolsDesign" label="Design" visible="true"/>
			</tabSet>
		</contextualTabs>
	</ribbon>
</customUI>');
    SET IDENTITY_INSERT [USysRibbons] OFF;
END

-- === Welcome ===
IF NOT EXISTS (SELECT 1 FROM [Welcome])
BEGIN
    SET IDENTITY_INSERT [Welcome] ON;
    INSERT INTO [Welcome] ([ID], [Welcome], [Learn], [DataMacro])
    VALUES
        (1, N'<div>The Northwind Developer Edition Template showcases major Access features.</div>

<div>&nbsp;</div>

<div>Northwind is a fictitious Trading Company whose customers are independent grocery stores. </div>

<div>Customers call in orders or place them over the internet. </div>

<div>Northwind invoices, ships, collects payments, and closes orders. </div>

<div>Sample data in this template will get you started quickly.</div>

<div>&nbsp;</div>', N'https://support.office.com/f1/topic/a685f382-e246-4f55-888f-52e4766868f8', N'<?xml version="1.0" encoding="UTF-16" standalone="no"?>
<DataMacros xmlns="http://schemas.microsoft.com/office/accessservices/2009/11/application"><DataMacro Event="BeforeChange"><Statements>
<Comment>Upate the Audit Fields for an Insert (AddedBy AddedOn) or and Update (ModifiedBy ModifiedOn)</Comment>
<ConditionalBlock>
<If><Condition>[IsInsert]</Condition>
<Statements>
<Action Name="SetField"><Argument Name="Field">AddedBy</Argument><Argument Name="Value">GetAuditFieldsUserName()</Argument></Action>
<Action Name="SetField"><Argument Name="Field">AddedOn</Argument><Argument Name="Value">Now()</Argument></Action>
<Action Name="SetField"><Argument Name="Field">ModifiedBy</Argument><Argument Name="Value">GetAuditFieldsUserName()</Argument></Action>
<Action Name="SetField"><Argument Name="Field">ModifiedOn</Argument><Argument Name="Value">Now()</Argument></Action>
</Statements>
</If>
<Else>
<Statements>
<Comment>This is an update</Comment>
<Action Name="SetField"><Argument Name="Field">ModifiedBy</Argument><Argument Name="Value">GetAuditFieldsUserName()</Argument></Action>
<Action Name="SetField"><Argument Name="Field">ModifiedOn</Argument><Argument Name="Value">Now()</Argument></Action>
<Comment>We only set the Added audit values once when the record is added.  If the user has deleted the AddedBy or AddedOn values we want to put them back  </Comment>
<ConditionalBlock>
<If>
<Condition>[Old].[AddedBy]&lt;&gt;[AddedBy]</Condition>
<Statements><Action Name="SetField"><Argument Name="Field">AddedBy</Argument><Argument Name="Value">[Old].[AddedBy]</Argument>
</Action>
</Statements>
</If>
<Else><Statements>
<ConditionalBlock>
<If><Condition>IsNull([AddedBy])</Condition><Statements>
<Action Name="SetField"><Argument Name="Field">AddedBy</Argument><Argument Name="Value">[Old].[AddedBy]</Argument></Action>
</Statements></If></ConditionalBlock></Statements></Else></ConditionalBlock>
<ConditionalBlock>
<If><Condition>IsNull([AddedOn])</Condition>
<Statements><Action Name="SetField"><Argument Name="Field">AddedOn</Argument><Argument Name="Value">[Old].[AddedOn]</Argument></Action>
</Statements></If>
<Else><Statements><ConditionalBlock><If><Condition>[Old].[AddedOn]&lt;&gt;[AddedOn]</Condition><Statements><Action Name="SetField"><Argument Name="Field">AddedOn</Argument><Argument Name="Value">[Old].[AddedOn]</Argument></Action>
</Statements></If></ConditionalBlock></Statements></Else></ConditionalBlock></Statements></Else></ConditionalBlock></Statements>
</DataMacro></DataMacros>');
    SET IDENTITY_INSERT [Welcome] OFF;
END

-- === Products ===
IF NOT EXISTS (SELECT 1 FROM [Products])
BEGIN
    SET IDENTITY_INSERT [Products] ON;
    INSERT INTO [Products] ([ProductID], [ProductCode], [ProductName], [ProductDescription], [StandardUnitCost], [UnitPrice], [ReorderLevel], [TargetLevel], [QuantityPerUnit], [Discontinued], [MinimumReorderQuantity], [ProductCategoryID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, N'NWTDRI- 74', N'Almonds', N'<div>Premium almonds from California''s Central Valley</div>', 7.5000, 10.0000, 30, 20, N'5 kg pkg.', 0, 5, 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, N'NWTBEV- 34', N'Beer', N'<div>Belgian-style: a flavorful, balanced beer with characteristics of hops, malt and fruity yeast</div>', 10.5000, 14.0000, 90, 60, N'24 - 12 oz bottles', 0, 15, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, N'NWTJAM- 6', N'Boysenberry Spread', N'<div>Boy, some berries. A <font face="Berlin Sans FB" color="#6F3198"><strong>delicious</strong></font><font
color="#6F3198"> </font>alternative topping for toast, pancakes and waffles</div>', 18.7500, 25.0000, 130, 100, N'12 - 8 oz jars', 0, 25, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, N'NWTBAK- 85', N'Brownie Mix', N'<div>Rich and fudgy, for a dense, chewy brownie with fudge topping</div>', 9.0000, 12.4900, 30, 20, N'3 boxes', 0, 5, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, N'NWTCON- 4', N'Cajun Seasoning', N'<div>Adds <font face=Forte color="#C55A11">zingy </font>new taste to meat, seafood, vegetables, eggs and more</div>', 16.5000, 22.0000, 60, 40, N'48 - 6 oz jars', 0, 10, 8, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, N'NWTBAK- 86', N'Cake Mix', N'<div><font face="Bahnschrift Condensed"><em>Versatile</em></font><em> </em>yellow mix for moist, fluffy cakes and cupcakes</div>', 10.5000, 15.9900, 30, 20, N'4 boxes', 0, 5, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, N'NWTBEV- 1', N'Chai', N'<div><font face="Monotype Corsiva" color="#0C0C0C"><strong><em>Black tea</em></strong></font><em> </em>with a blend of cardamom, ginger, cloves and cinnamon</div>', 13.5000, 18.0000, 60, 40, N'10 boxes x 20 bags', 0, 10, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, N'NWTCFV- 91', N'Cherry Pie Filling', N'<div>Real, whole, tart <font face="Bauhaus 93" color="#CC0066"><strong>cherries</strong></font><font
face="Bauhaus 93"> </font>hand-picked at their peak</div>', 1.0000, 2.0000, 60, 40, N'15.25 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, N'NWTSOU- 99', N'Chicken Soup', N'<div>To warm the soul. Rich broth chock-full of tender chicken, fresh diced vegetables and hearty egg noodles</div>', 1.0000, 1.9500, 260, 200, N'1', 0, 90, 16, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, N'NWTCDY- 48', N'Chocolate', N'<div>Smooth and satisfying, 72% <font face=Broadway color="#7A4E2B">cacao </font>for an antioxidant boost</div>', 9.5625, 12.7500, 130, 100, N'10 pkgs', 0, 25, 3, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, N'NWTBAK- 19', N'Chocolate Biscuits Mix', N'<div>A flaky, buttery, <font face="Lucida Handwriting" color="#7A4E2B"><strong>chocolatey </strong></font>twist on traditional biscuits</div>', 6.9000, 9.2000, 30, 20, N'10 boxes x 12 pieces', 0, 5, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, N'NWTSOU- 41', N'Clam Chowder', N'<div>New England style with a creamy base, with generous portions of clams and bacon</div>', 7.2375, 9.6500, 60, 40, N'12 - 12 oz cans', 0, 10, 16, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, N'NWTBEV- 43', N'Coffee', N'<div>Pre-ground medium roast is a full-flavored blend of 100% Arabica beans from Guatemala and Ethiopia</div>', 34.5000, 46.0000, 130, 100, N'16 - 500 g tins', 0, 25, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, N'NWTCFV- 93', N'Corn', N'<div>Delicious, tender tri-color sweet corn on the cob</div>', 1.0000, 1.2000, 60, 40, N'14.5 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, N'NWTCM- 40', N'Crab Meat', N'<div>Authentic Maryland Blue crab meat, packed by hand</div>', 13.8000, 18.4000, 160, 120, N'24 - 4 oz tins', 0, 30, 5, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, N'NWTSAU- 8', N'Curry Sauce', N'<div>Thai style red curry sauce is a zesty blend of red chili puree, coconut milk, onions, garlic and ginger</div>', 30.0000, 40.0000, 60, 40, N'12 - 12 oz jars', 0, 10, 15, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, N'NWTDRI- 51', N'Dried Apples', N'<div>Apple chips for lunchboxes and snacks are high in fiber and nutrients</div>', 39.7500, 53.0000, 60, 40, N'50 - 300 g pkgs.', 0, 10, 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, N'NWTDRI- 7', N'Dried Pears', N'<div>A sweet treat for hikers and snackers</div>', 22.5000, 30.0000, 60, 40, N'12 - 1 lb pkgs.', 0, 10, 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, N'NWTDRI- 80', N'Dried Plums', N'<div>Dense, sweet <font face="Curlz MT" size=3 color="#6F3198"><strong>dried plums</strong></font>: the perfect snack for people on the go</div>', 3.0000, 3.5000, 100, 75, N'1 lb bag', 0, 25, 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, N'NWTCFV- 17', N'Fruit Cocktail', N'<div>Diced peaches, pears, pineapple and sweet <font face="Bauhaus 93"
color="#CC0066"><strong>cherries</strong></font><font face="Bauhaus 93"> </font>in heavy syrup</div>', 29.2500, 39.0000, 60, 40, N'15.25 OZ', 0, 10, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, N'NWTPAS- 56', N'Gnocchi', N'<div>Traditional Italian potato dumplings, fully-cooked; ready to heat and eat</div>', 28.5000, 38.0000, 160, 120, N'24 - 250 g pkgs.', 0, 30, 14, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, N'NWTCER- 82', N'Granola', N'<div>A super <font face="Snap ITC" size=3 color="#2F5496">crunchy </font>treat: Oats loaded with almonds, walnuts, hazelnuts, raisins, coconut and dried cranberry</div>', 2.0000, 4.0000, 130, 100, NULL, 0, 50, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, N'NWTCFV- 92', N'Green Beans', N'<div>Whole fresh <font color="#538135"><strong>green </strong></font>beans picked in their prime</div>', 1.0000, 1.2000, 60, 40, N'14.5 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, N'NWTBEV- 81', N'Green Tea', N'<div>Authentic <font color="#538135"><strong>green tea</strong></font> leaves, dried quickly after harvest to preserve their vibrant color and naturally occurring antioxidants</div>', 2.0000, 2.9900, 170, 125, N'20 bags per box', 0, 25, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, N'NWTSAU- 65', N'Hot Pepper Sauce', N'<div><font face=Chiller size=4 color="#ED1C24"><strong>Hot stuff!</strong></font><font
size=4> </font>Adds tastebud-searing warmth to any dish</div>', 15.7875, 21.0500, 60, 40, N'32 - 8 oz bottles', 0, 10, 15, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, N'NWTGRA- 52', N'Long Grain Rice', N'<div>Premium white Basmati</div>', 5.2500, 7.0000, 130, 100, N'16 - 2 kg boxes', 0, 25, 11, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, N'NWTDAI- 72', N'Mozzarella', N'<div>Fresh, mild and cheesy; a staple of Italian cuisine</div>', 26.1000, 34.8000, 60, 40, N'24 - 200 g pkgs.', 0, 10, 9, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, N'NWTCON- 77', N'Mustard', N'<div>Stone-ground dijon-style prepared mustard</div>', 9.7500, 13.0000, 90, 60, N'12 boxes', 0, 15, 8, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, N'NWTOIL- 5', N'Olive Oil', N'<div>Extra virgin for smooth taste and versatility</div>', 16.0125, 21.3500, 60, 40, N'36 boxes', 0, 10, 13, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, N'NWTCFV- 89', N'Peaches', N'<div>Delicious, juicy freestone peaches suitable for canning, baking and snacking</div>', 1.0000, 1.5000, 60, 40, N'15.25 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (31, N'NWTCFV- 88', N'Pears', N'<div>Organic <font face="Berlin Sans FB" color="#BA1419">red D''Anjou pears</font>, ripened to pear-fection</div>', 1.0000, 1.3000, 60, 40, N'15.25 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, N'NWTCFV- 94', N'Peas', N'<div>Baby <font face="Showcard Gothic" color="#538135"><strong>green peas</strong> </font>in the pod, ready for shucking</div>', 1.0000, 1.5000, 60, 40, N'14.5 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, N'NWTCFV- 90', N'Pineapple', N'<div>Fresh from Hawaii: ripe, succulent whole fruits</div>', 1.0000, 1.8000, 60, 40, N'15.25 OZ', 0, NULL, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, N'NWTSNK- 83', N'Potato Chips', N'<div>Kettle-cooked crispy snackers</div>', 0.5000, 1.8000, 70, 50, NULL, 0, 75, 7, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, N'NWTPAS- 57', N'Ravioli', N'<div>Tender pasta envelopes filled with ricotta cheese and spinach</div>', 14.6250, 19.5000, 110, 80, N'24 - 250 g pkgs.', 0, 20, 14, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, N'NWTBAK- 21', N'Scones', N'<div>The perfect accompaniment to coffee or proper tea</div>', 7.5000, 10.0000, 30, 20, N'24 pkgs. x 4 pieces', 0, 5, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, N'NWTCM- 96', N'Smoked Salmon', N'<div>From the Pacific Northwest''s pristine icy cold waters and hardwood-smoked </div>', 2.0000, 4.0000, 70, 50, N'5 oz', 0, NULL, 5, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, N'NWTCON- 3', N'Syrup', N'<div>Pure cane syrup</div>', 7.5000, 10.0000, 130, 100, N'12 - 550 ml bottles', 0, 25, 8, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, N'NWTBEV- 87', N'Tea', N'<div>Robust<font color="#0C0C0C"><strong> </strong></font><font
face="Kristen ITC" color="#0C0C0C"><strong>black tea leaves</strong></font> have rich flavor, dark color, and a smooth finish</div>', 2.0000, 4.0000, 70, 50, N'100 count per box', 0, NULL, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, N'NWTSAU- 66', N'Tomato Sauce', N'<div>Delicately seasoned with salt, pepper and herbs</div>', 12.7500, 17.0000, 110, 80, N'24 - 8 oz jars', 0, 20, 15, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, N'NWTCM- 95', N'Tuna Fish', N'<div>Wild-caught solid-white albacore tuna packed in water</div>', 0.5000, 2.0000, 70, 50, N'5 oz', 0, NULL, 5, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, N'NWTSOU- 98', N'Vegetable Soup', N'<div>Farm-fresh diced vegetable medley in a rich vegetable broth</div>', 1.0000, 1.8900, 260, 200, N'1', 0, NULL, 16, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, N'NWTDRI- 14', N'Walnuts', N'<div>Shelled, energy-dense and loaded with polyunsaturated &quot;good&quot; fats. Perfect baking and snacking</div>', 17.4375, 23.2500, 60, 40, N'40 - 100 g pkgs.', 0, 10, 10, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Products] OFF;
END

-- === Companies ===
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

-- === Employees ===
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

-- === StockTake ===
IF NOT EXISTS (SELECT 1 FROM [StockTake])
BEGIN
    SET IDENTITY_INSERT [StockTake] ON;
    INSERT INTO [StockTake] ([StockTakeID], [StockTakeDate], [ProductID], [QuantityOnHand], [ExpectedQuantity], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, '2024-09-15 09:00:00.000', 1, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, '2024-09-15 09:01:00.000', 2, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, '2024-09-15 09:02:00.000', 3, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, '2024-09-15 09:03:00.000', 4, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, '2024-09-15 09:04:00.000', 5, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, '2024-09-15 09:05:00.000', 6, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, '2024-09-15 09:06:00.000', 7, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, '2024-09-15 09:07:00.000', 8, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, '2024-09-15 09:08:00.000', 9, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, '2024-09-15 09:09:00.000', 10, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, '2024-09-15 09:10:00.000', 11, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, '2024-09-15 09:11:00.000', 12, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, '2024-09-15 09:12:00.000', 13, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, '2024-09-15 09:13:00.000', 14, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, '2024-09-15 09:14:00.000', 15, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, '2024-09-15 09:15:00.000', 16, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, '2024-09-15 09:16:00.000', 17, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, '2024-09-15 09:17:00.000', 18, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, '2024-09-15 09:18:00.000', 19, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, '2024-09-15 09:19:00.000', 20, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, '2024-09-15 09:20:00.000', 21, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, '2024-09-15 09:21:00.000', 22, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, '2024-09-15 09:22:00.000', 23, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, '2024-09-15 09:23:00.000', 24, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, '2024-09-15 09:24:00.000', 25, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, '2024-09-15 09:25:00.000', 26, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, '2024-09-15 09:26:00.000', 27, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, '2024-09-15 09:27:00.000', 28, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, '2024-09-15 09:28:00.000', 29, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, '2024-09-15 09:29:00.000', 30, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (31, '2024-09-15 09:30:00.000', 31, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, '2024-09-15 09:31:00.000', 32, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, '2024-09-15 09:32:00.000', 33, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, '2024-09-15 09:33:00.000', 34, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, '2024-09-15 09:34:00.000', 35, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, '2024-09-15 09:35:00.000', 36, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, '2024-09-15 09:36:00.000', 37, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, '2024-09-15 09:37:00.000', 38, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, '2024-09-15 09:38:00.000', 39, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, '2024-09-15 09:39:00.000', 40, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, '2024-09-15 09:40:00.000', 41, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, '2024-09-15 09:41:00.000', 42, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, '2024-09-15 09:42:00.000', 43, 0, 0, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [StockTake] OFF;
END

-- === Contacts ===
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

-- === ProductVendors ===
IF NOT EXISTS (SELECT 1 FROM [ProductVendors])
BEGIN
    SET IDENTITY_INSERT [ProductVendors] ON;
    INSERT INTO [ProductVendors] ([ProductVendorID], [ProductID], [VendorID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (2, 2, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, 3, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, 4, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, 5, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, 6, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, 7, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, 8, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, 9, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, 10, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, 11, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, 12, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, 13, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, 14, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, 15, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, 16, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, 17, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, 18, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, 19, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, 20, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, 21, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, 22, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, 23, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, 24, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, 25, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, 26, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, 27, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, 28, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, 29, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, 30, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (31, 31, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, 32, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, 33, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, 34, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, 35, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, 36, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, 37, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, 38, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, 39, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, 40, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, 41, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, 42, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, 43, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (44, 1, 12, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (45, 1, 11, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (46, 2, 11, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (47, 3, 11, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (48, 4, 11, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [ProductVendors] OFF;
END

-- === EmployeePrivileges ===
IF NOT EXISTS (SELECT 1 FROM [EmployeePrivileges])
BEGIN
    SET IDENTITY_INSERT [EmployeePrivileges] ON;
    INSERT INTO [EmployeePrivileges] ([EmployeePrivilegeID], [EmployeeID], [PrivilegeID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 2, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 9, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, 10, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [EmployeePrivileges] OFF;
END

-- === Orders ===
IF NOT EXISTS (SELECT 1 FROM [Orders])
BEGIN
    SET IDENTITY_INSERT [Orders] ON;
    INSERT INTO [Orders] ([OrderID], [EmployeeID], [CustomerID], [OrderDate], [InvoiceDate], [ShippedDate], [ShipperID], [ShippingFee], [TaxRate], [TaxStatusID], [PaymentMethod], [PaidDate], [Notes], [OrderStatusID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 8, 6, '2025-08-13 12:01:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-09-21 12:01:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 3, 7, '2025-08-13 12:02:00.000', '2024-09-20 12:02:00.000', '2025-08-13 12:02:00.000', 10, 20.0000, 0.08500000089406967, 0, N'Credit Card', '2025-08-15 12:02:00.000', NULL, 1, N'Admin', '2024-09-21 12:02:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, 8, 7, '2025-08-13 12:03:00.000', '2024-09-19 12:03:00.000', '2025-08-13 12:03:00.000', 10, 17.5000, 0.08500000089406967, 0, NULL, NULL, NULL, 4, N'Admin', '2024-09-21 12:03:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, 8, 5, '2025-08-15 12:04:00.000', '2024-09-23 12:04:00.000', '2025-08-15 12:04:00.000', 10, 15.0000, 0.08500000089406967, 0, N'Cash', '2025-08-17 12:04:00.000', NULL, 5, N'Admin', '2024-09-23 12:04:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, 5, 7, '2025-08-15 12:05:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-09-23 12:05:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, 4, 1, '2025-08-15 12:06:00.000', '2024-09-23 12:06:00.000', '2025-08-15 12:06:00.000', 10, 15.0000, 0.08500000089406967, 0, N'Check', '2025-08-17 12:06:00.000', NULL, 1, N'Admin', '2024-09-23 12:06:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, 1, 3, '2025-08-17 12:07:00.000', '2024-09-25 12:07:00.000', '2025-08-17 12:07:00.000', 9, 15.0000, 0.08500000089406967, 0, N'Check', '2025-08-19 12:07:00.000', NULL, 5, N'Admin', '2024-09-25 12:07:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, 6, 3, '2025-08-17 12:08:00.000', '2024-09-24 12:08:00.000', NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 2, N'Admin', '2024-09-25 12:08:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, 5, 4, '2025-08-17 12:09:00.000', '2024-09-23 12:09:00.000', '2025-08-17 12:09:00.000', 9, 20.0000, 0.08500000089406967, 0, N'Check', '2025-08-19 12:09:00.000', NULL, 5, N'Admin', '2024-09-25 12:09:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, 7, 2, '2025-08-19 12:10:00.000', '2024-09-26 12:10:00.000', NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 2, N'Admin', '2024-09-27 12:10:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, 9, 3, '2025-08-19 12:11:00.000', '2024-09-25 12:11:00.000', '2025-08-19 12:11:00.000', 9, 15.5000, 0.08500000089406967, 0, N'Check', '2025-08-21 12:11:00.000', NULL, 5, N'Admin', '2024-09-27 12:11:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, 10, 1, '2025-08-19 12:12:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-09-27 12:12:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, 10, 3, '2025-08-21 12:13:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-09-29 12:13:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, 3, 1, '2025-08-21 12:14:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-09-29 12:14:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, 10, 3, '2025-08-21 12:15:00.000', '2024-09-29 12:15:00.000', NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 2, N'Admin', '2024-09-29 12:15:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, 6, 1, '2025-08-23 12:16:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-01 12:16:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, 2, 3, '2025-08-23 12:17:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-01 12:17:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, 10, 6, '2025-08-23 12:18:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-01 12:18:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, 7, 2, '2025-08-25 12:19:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-03 12:19:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, 1, 4, '2025-08-25 12:20:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-03 12:20:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, 6, 5, '2025-08-25 12:21:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-03 12:21:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, 2, 4, '2025-08-27 12:22:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-05 12:22:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, 2, 3, '2025-08-27 12:23:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-05 12:23:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, 8, 7, '2025-08-27 12:24:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-05 12:24:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, 3, 2, '2025-08-29 12:25:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-07 12:25:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, 1, 8, '2025-08-29 12:26:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-07 12:26:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, 3, 3, '2025-08-29 12:27:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-07 12:27:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, 4, 8, '2025-08-31 12:28:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-09 12:28:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, 4, 5, '2025-08-31 12:29:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-09 12:29:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, 10, 4, '2025-08-31 12:30:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-09 12:30:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (31, 10, 7, '2025-09-02 12:31:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-11 12:31:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, 5, 8, '2025-09-02 12:32:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-11 12:32:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, 3, 2, '2025-09-02 12:33:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-11 12:33:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, 2, 5, '2025-09-04 12:34:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-13 12:34:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, 2, 4, '2025-09-04 12:35:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-13 12:35:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, 7, 1, '2025-09-04 12:36:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-13 12:36:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, 5, 4, '2025-09-06 12:37:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-15 12:37:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, 5, 8, '2025-09-06 12:38:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-15 12:38:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, 8, 6, '2025-09-06 12:39:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-15 12:39:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, 4, 8, '2025-09-08 12:40:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-17 12:40:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, 7, 5, '2025-09-08 12:41:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-17 12:41:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, 3, 5, '2025-09-08 12:42:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-17 12:42:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, 2, 2, '2025-09-10 12:43:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-19 12:43:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (44, 6, 7, '2025-09-10 12:44:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-19 12:44:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (45, 1, 8, '2025-09-10 12:45:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-19 12:45:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (46, 5, 4, '2025-09-12 12:46:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-21 12:46:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (47, 10, 5, '2025-09-12 12:47:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-21 12:47:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (48, 3, 4, '2025-09-12 12:48:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-21 12:48:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (49, 8, 3, '2025-09-14 12:49:00.000', NULL, NULL, NULL, NULL, 0.09000000357627869, 1, NULL, NULL, NULL, 3, N'Admin', '2024-10-23 12:49:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (50, 4, 5, '2025-09-14 12:50:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-23 12:50:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (53, 3, 3, '2025-09-14 12:53:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, NULL, 3, N'Admin', '2024-10-23 12:53:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (56, 10, 6, '2025-09-16 12:56:00.000', NULL, NULL, NULL, NULL, 0.08500000089406967, 0, NULL, NULL, N'Internet Order', 3, N'Admin', '2024-10-25 12:56:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [Orders] OFF;
END

-- === PurchaseOrders ===
IF NOT EXISTS (SELECT 1 FROM [PurchaseOrders])
BEGIN
    SET IDENTITY_INSERT [PurchaseOrders] ON;
    INSERT INTO [PurchaseOrders] ([PurchaseOrderID], [VendorID], [SubmittedByID], [SubmittedDate], [ApprovedByID], [ApprovedDate], [StatusID], [ReceivedDate], [ShippingFee], [TaxAmount], [PaymentDate], [PaymentAmount], [PaymentMethod], [Notes], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 12, 2, '2024-08-20 08:00:00.000', 2, '2024-08-20 08:05:00.000', 2, '2024-08-20 08:00:00.000', 100.0000, 5009.9900, '2024-08-20 09:00:00.000', 60776.4900, N'Credit Card', NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 12, NULL, NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [PurchaseOrders] OFF;
END

-- === OrderDetails ===
IF NOT EXISTS (SELECT 1 FROM [OrderDetails])
BEGIN
    SET IDENTITY_INSERT [OrderDetails] ON;
    INSERT INTO [OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice], [Discount], [OrderDetailStatusID], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 1, 25, 18, 21.0500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 1, 13, 40, 46.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, 1, 1, 39, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, 2, 2, 24, 14.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, 2, 38, 41, 10.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, 2, 17, 49, 53.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, 3, 41, 21, 2.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, 4, 3, 32, 25.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, 4, 21, 18, 38.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, 4, 27, 34, 34.8000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, 4, 12, 17, 9.6500, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, 5, 26, 50, 7.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, 5, 40, 15, 17.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, 5, 30, 50, 1.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, 5, 11, 29, 9.2000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, 6, 30, 5, 1.5000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, 6, 25, 9, 21.0500, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, 6, 5, 41, 22.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, 6, 13, 7, 46.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, 7, 13, 48, 46.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, 7, 43, 23, 23.2500, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, 8, 8, 34, 2.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, 9, 31, 20, 1.3000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, 9, 28, 14, 13.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, 10, 4, 26, 12.4900, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, 10, 39, 17, 4.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, 10, 34, 22, 1.8000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, 11, 28, 33, 13.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, 11, 19, 9, 3.5000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, 11, 25, 36, 21.0500, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (31, 11, 40, 43, 17.0000, 0.0, 6, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, 12, 40, 24, 17.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, 12, 30, 28, 1.5000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, 12, 23, 26, 1.2000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, 13, 12, 7, 9.6500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, 13, 11, 50, 9.2000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, 14, 16, 27, 40.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, 14, 7, 26, 18.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, 15, 24, 12, 2.9900, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, 15, 41, 35, 2.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, 15, 22, 22, 4.0000, 0.0, 2, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, 16, 20, 39, 39.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, 16, 26, 43, 7.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (44, 16, 1, 14, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (45, 16, 4, 9, 12.4900, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (46, 17, 1, 29, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (47, 18, 36, 8, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (48, 18, 9, 36, 1.9500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (49, 18, 20, 21, 39.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (50, 19, 40, 29, 17.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (51, 19, 4, 39, 12.4900, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (52, 19, 18, 26, 30.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (53, 20, 15, 9, 18.4000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (54, 21, 40, 9, 17.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (55, 22, 38, 39, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (56, 22, 12, 35, 9.6500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (57, 23, 2, 19, 14.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (58, 24, 11, 27, 9.2000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (59, 24, 2, 27, 14.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (60, 25, 26, 39, 7.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (61, 25, 40, 20, 17.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (62, 25, 24, 8, 2.9900, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (63, 25, 28, 23, 13.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (64, 26, 40, 33, 17.0000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (65, 27, 21, 15, 38.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (66, 28, 2, 20, 14.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (67, 29, 24, 23, 2.9900, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (68, 29, 37, 43, 4.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (69, 29, 29, 38, 21.3500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (70, 29, 43, 20, 23.2500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (71, 30, 30, 13, 1.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (72, 30, 19, 29, 3.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (73, 31, 19, 28, 3.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (74, 31, 10, 33, 12.7500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (75, 31, 22, 36, 4.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (76, 32, 14, 18, 1.2000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (77, 32, 7, 29, 18.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (78, 33, 16, 45, 40.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (79, 33, 21, 13, 38.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (80, 33, 30, 39, 1.5000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (81, 34, 7, 42, 18.0000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (82, 34, 9, 49, 1.9500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (83, 34, 3, 7, 25.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (84, 34, 35, 22, 19.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (85, 35, 5, 12, 22.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (86, 36, 23, 30, 1.2000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (87, 36, 10, 26, 12.7500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (88, 36, 33, 39, 1.8000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (89, 37, 33, 9, 1.8000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (90, 37, 28, 37, 13.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (91, 37, 1, 24, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (92, 37, 18, 17, 30.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (93, 38, 30, 24, 1.5000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (94, 38, 32, 17, 1.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (95, 38, 16, 24, 40.0000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (96, 38, 41, 10, 2.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (97, 39, 5, 13, 22.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (98, 39, 4, 24, 12.4900, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (99, 40, 22, 49, 4.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (100, 40, 10, 22, 12.7500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (101, 40, 18, 17, 30.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (102, 41, 23, 49, 1.2000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (103, 42, 29, 25, 21.3500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (104, 42, 30, 7, 1.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (105, 42, 33, 37, 1.8000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (106, 42, 22, 12, 4.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (107, 43, 34, 7, 1.8000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (108, 43, 23, 23, 1.2000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (109, 44, 42, 41, 1.8900, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (110, 44, 30, 46, 1.5000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (111, 45, 6, 48, 15.9900, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (112, 45, 35, 37, 19.5000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (113, 46, 8, 12, 2.0000, 0.05000000074505806, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (114, 47, 5, 17, 22.0000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (115, 47, 28, 44, 13.0000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (116, 48, 39, 22, 4.0000, 0.10000000149011612, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (117, 49, 10, 25, 12.7500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (118, 49, 11, 45, 9.2000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (119, 49, 27, 22, 34.8000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (120, 49, 17, 44, 53.0000, 0.0, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (121, 50, 23, 19, 1.2000, 0.05999999865889549, 4, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (122, 50, 38, 16, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (123, 50, 12, 13, 9.6500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (124, 50, 15, 5, 18.4000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (126, 53, 4, 1, 12.4900, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (127, 53, 2, 2, 14.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (130, 53, 15, 3, 18.4000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (132, 56, 25, 18, 21.0500, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (133, 56, 13, 40, 46.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (134, 56, 1, 39, 10.0000, 0.0, 1, N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [OrderDetails] OFF;
END

-- === PurchaseOrderDetails ===
IF NOT EXISTS (SELECT 1 FROM [PurchaseOrderDetails])
BEGIN
    SET IDENTITY_INSERT [PurchaseOrderDetails] ON;
    INSERT INTO [PurchaseOrderDetails] ([PurchaseOrderDetailID], [PurchaseOrderID], [ProductID], [Quantity], [UnitCost], [ReceivedDate], [AddedBy], [AddedOn], [ModifiedBy], [ModifiedOn])
    VALUES
        (1, 1, 1, 40, 7.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (2, 1, 2, 120, 10.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (3, 1, 3, 200, 18.7500, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (4, 1, 4, 40, 9.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (5, 1, 5, 80, 16.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (6, 1, 6, 40, 10.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (7, 1, 7, 80, 13.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (8, 1, 8, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (9, 1, 9, 400, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (10, 1, 10, 200, 9.5625, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (11, 1, 11, 40, 6.9000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (12, 1, 12, 80, 7.2375, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (13, 1, 13, 200, 34.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (14, 1, 14, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (15, 1, 15, 240, 13.8000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (16, 1, 16, 80, 30.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (17, 1, 17, 80, 39.7500, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (18, 1, 18, 80, 22.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (19, 1, 19, 150, 3.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (20, 1, 20, 80, 29.2500, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (21, 1, 21, 240, 28.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (22, 1, 22, 200, 2.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (23, 1, 23, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (24, 1, 24, 250, 2.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (25, 1, 25, 80, 15.7875, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (26, 1, 26, 200, 5.2500, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (27, 1, 27, 80, 26.1000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (28, 1, 28, 120, 9.7500, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (29, 1, 29, 80, 16.0125, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (30, 1, 30, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (31, 1, 31, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (32, 1, 32, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (33, 1, 33, 80, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (34, 1, 34, 100, 0.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (35, 1, 35, 160, 14.6250, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (36, 1, 36, 40, 7.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (37, 1, 37, 100, 2.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (38, 1, 38, 200, 7.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (39, 1, 39, 100, 2.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (40, 1, 40, 160, 12.7500, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (41, 1, 41, 100, 0.5000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (42, 1, 42, 400, 1.0000, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000'),
        (43, 1, 43, 80, 17.4375, '2026-01-02 08:00:00.000', N'Admin', '2024-09-21 00:00:00.000', N'tvans', '2025-09-16 15:47:31.000');
    SET IDENTITY_INSERT [PurchaseOrderDetails] OFF;
END

