-- Data for table: Catalog_TableOfContents
-- Row count: 16

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