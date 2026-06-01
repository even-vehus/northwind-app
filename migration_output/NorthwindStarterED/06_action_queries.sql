-- Access Action Queries (reference only — not directly runnable as T-SQL)
-- These are DELETE, UPDATE, APPEND, MAKE-TABLE, and other non-SELECT queries.
-- Migrate manually as stored procedures or application logic as needed.

-- ============================================================
-- Query: qrycboProductCategories
-- Type:  PASS-THROUGH
-- ============================================================
/*
select distinct 1 as theClause, 0 as ProductCategoryID, "<All>" as ProductCategoryName FROM ProductCategories
UNION ALL SELECT 2 as theClause, ProductCategories.ProductCategoryID, ProductCategories.ProductCategoryName
FROM ProductCategories
ORDER BY theClause, ProductCategoryName;
*/

