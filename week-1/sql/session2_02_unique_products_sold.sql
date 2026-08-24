-- Session 2 question: out of the full product catalogue, how many
-- distinct products actually appear in the sales table?
-- Table: sales | Field: product_id

SELECT COUNT(DISTINCT product_id) AS unique_products_in_sales
FROM sales;

-- Result: 350 distinct product_id values.
--
-- Limitation: the products table has 362 rows, so roughly 12
-- products never appear in a sale. This query only counts which
-- products show up in sales at least once — it says nothing about
-- how many times, or which are best- or worst-selling.
