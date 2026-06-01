-- Data for table: ProductCategories
-- Row count: 16

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