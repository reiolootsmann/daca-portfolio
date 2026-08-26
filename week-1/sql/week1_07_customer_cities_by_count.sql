-- Task Card B: which cities are customers from, and how many
-- customers per city?
-- Table: customers | Field: city

-- First pass: what values actually occur in city?
SELECT DISTINCT city FROM customers;

-- Advanced extension (previews GROUP BY, Week 4 material): count
-- customers per city.
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

-- Result: 54 distinct raw values came back for what should be about
-- a dozen real cities. Tallinn alone is split across at least 4
-- spellings: "Tallinn" (1,135), "Tallinn " with a trailing space
-- (31), "tallinn" lowercase (26), " Tallinn" with a leading space
-- (23) — same pattern likely repeats for the other cities.
--
-- Limitation: GROUP BY treats each spelling as a different city, so
-- these counts undercount the real city totals rather than being
-- wrong outright. Standardising city spelling (trim + consistent
-- case) is a cleanup question for later, not something changed here
-- — this query only reports what's actually stored.
