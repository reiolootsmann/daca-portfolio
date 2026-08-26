-- Task Card B: when did the first and most recent customers
-- register?
-- Table: customers | Field: registration_date

SELECT MIN(registration_date) AS earliest,
       MAX(registration_date) AS latest
FROM customers;

-- Result: earliest registration 2020-01-02, latest 2025-02-27.
--
-- Limitation: MIN/MAX only give the range's two endpoints — they say
-- nothing about how registrations are spread across that period.
