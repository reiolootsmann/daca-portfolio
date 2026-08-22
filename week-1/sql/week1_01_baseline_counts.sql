-- Business question: How large are the three tables released for Week 1?
-- Table: products, customers, sales
-- This is the baseline every later check is measured against.

SELECT 'products'  AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'sales',     COUNT(*) FROM sales;

-- Result:
--   products    362
--   customers   3,150
--   sales       15,234
--
-- Limitation: a row count only confirms the tables loaded; it says
-- nothing yet about whether the values inside them are trustworthy.
