-- Business question: Toomas says "there are prices that are negative,
-- which is not a thing that can happen in a shop." How many sales
-- rows have a non-positive total_price, and what do a few look like?
-- Table: sales | Field: total_price

-- How many rows are affected
SELECT COUNT(*) AS non_positive_total_price_rows
FROM sales
WHERE total_price <= 0;

-- A small, inspectable sample of those rows
SELECT invoice_id, sale_date, quantity, unit_price, total_price, channel
FROM sales
WHERE total_price <= 0
ORDER BY sale_date DESC
LIMIT 20;

-- Result: 305 of 15,234 sales rows (about 2.0%) have total_price <= 0.
--
-- Limitation: the query confirms the count and lets us inspect the
-- rows; it does not explain why. A non-positive total could be a
-- return or adjustment rather than a data-entry error. We need a
-- business definition from Toomas before deciding how to treat these
-- rows. No rows were changed or removed to produce this result.
