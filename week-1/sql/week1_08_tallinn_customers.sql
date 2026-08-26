-- Task Card B: sample of customers from one city, sorted by name.
-- Table: customers | Fields: city, last_name

SELECT * FROM customers
WHERE city = 'Tallinn'
ORDER BY last_name ASC
LIMIT 15;

-- Result: returns the exact-match "Tallinn" rows only.
--
-- Limitation: because of the spelling inconsistency found in
-- week1_07_customer_cities_by_count.sql, this exact-match filter
-- misses customers stored as "TALLINN", "tallinn", "Tallinn " etc.
-- — it undercounts Tallinn customers, it does not return zero real
-- ones.
