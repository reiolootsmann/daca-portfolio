-- Task Card B: are any customers missing a first name or an email
-- address?
-- Table: customers | Fields: first_name, email

-- How many customers are missing a first name?
SELECT COUNT(*) - COUNT(first_name) AS missing_first_names
FROM customers;

-- How many customers are missing an email?
SELECT COUNT(*) - COUNT(email) AS missing_emails
FROM customers;

-- Result: 0 rows missing a first name; 380 rows (about 12%) missing
-- an email.
--
-- Limitation: this counts rows where email is NULL, not why it's
-- missing. Whether a missing email is a data-entry gap or a
-- customer who never provided one is a question for Toomas, not
-- something this query can answer.
