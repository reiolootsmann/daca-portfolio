-- Session 2 question: how many rows does the sales table hold, and how
-- many distinct customers does it actually represent?
-- Table: sales | Fields: customer_id

SELECT
    COUNT(*)                       AS total_sales_rows,
    COUNT(DISTINCT customer_id)    AS unique_customers_in_sales
FROM sales;

-- Result: 15,234 total rows, but only 2,558 distinct customer_id values.
--
-- Limitation: this counts how many different customers appear in
-- sales, not how many customers UrbanStyle.ltd has in total (that's
-- the customers table, 3,150 rows) and not how many purchases each
-- customer made. It also excludes guest purchases, where customer_id

