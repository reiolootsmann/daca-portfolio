-- Business question: Toomas says "there are customer references that
-- point nowhere." How many sales have no customer_id at all (guest
-- purchases), and do the sales that DO have a customer_id actually
-- match a real row in `customers`?
-- Tables: sales, customers | Field: sales.customer_id

-- Rows with and without a recorded customer_id
SELECT
    COUNT(*)                        AS sales_rows,
    COUNT(customer_id)              AS rows_with_customer_id,
    COUNT(*) - COUNT(customer_id)   AS rows_without_customer_id
FROM sales;

-- Of the rows that DO have a customer_id, how many fail to match any
-- row in customers? (a within-table lookup, not a join)
SELECT COUNT(*) AS customer_id_not_found_in_customers
FROM sales
WHERE customer_id IS NOT NULL
  AND customer_id NOT IN (SELECT customer_id FROM customers);

-- Result:
--   sales_rows                15,234
--   rows_with_customer_id     13,747
--   rows_without_customer_id   1,487  (about 9.8% — guest purchases)
--   customer_id_not_found_in_customers   0
--
-- Limitation: within the released data, every recorded customer_id
-- does match a real customers row (0 "point nowhere" in that literal
-- sense) — the products/sales foreign keys enforce that on import.
-- The 1,487 guest-purchase rows are a separate, expected pattern
-- (channel/NULL store_location follows the same logic), not proof of
-- an error. If "point nowhere" means something else — e.g. the same
-- person appearing under more than one customer_id — that needs a
-- join across customers, which is out of the Week 1 skill boundary
-- and is flagged as a question for later weeks. No rows were changed.
