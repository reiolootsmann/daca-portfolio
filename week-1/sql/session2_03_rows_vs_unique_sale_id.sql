-- Session 2 question: how many sales rows are there, and how many of
-- them have a unique sale_id? This is the same duplicate-rows signal
-- the meeting lead demonstrated live.
-- Table: sales | Field: sale_id

SELECT
    COUNT(*)                AS total_sales_rows,
    COUNT(DISTINCT sale_id) AS unique_sale_ids
FROM sales;

-- Result: 15,234 total rows, 10,118 distinct sale_id values -> a gap
-- of 5,116 rows, matching the "around 5,000 duplicated rows" figure
-- from the course documents and Toomas's letter.
--
-- Limitation: this confirms the size of the gap, not that every
-- extra row is a confirmed duplicate — see
-- week1_02_sale_and_invoice_id_check.sql for the fuller version of
-- this check (which also compares against invoice_id).
