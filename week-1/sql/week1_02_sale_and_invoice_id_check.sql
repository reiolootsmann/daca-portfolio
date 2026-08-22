-- Business question: Toomas says some sales "look like the same sale
-- recorded more than once — my rough count is over five thousand".
-- Does the row count match the number of distinct sale/invoice
-- identifiers in `sales`?
-- Table: sales | Fields: sale_id, invoice_id

SELECT
    COUNT(*)                   AS sales_rows,
    COUNT(DISTINCT sale_id)    AS distinct_sale_ids,
    COUNT(DISTINCT invoice_id) AS distinct_invoice_ids
FROM sales;

-- Result:
--   sales_rows            15,234
--   distinct_sale_ids     10,118
--   distinct_invoice_ids  10,118
--
-- 15,234 rows but only 10,118 distinct sale_id values (and the same
-- 10,118 distinct invoice_id values) -> 5,116 rows more than distinct
-- identifiers. This matches the scale of Toomas's estimate ("over
-- five thousand").
--
-- Limitation: this proves a gap between row count and distinct-ID
-- count, not that every extra row is an erroneous duplicate. A row
-- could share a sale_id/invoice_id for a reason that isn't a data
-- error. Defining and validating "true duplicate" is Week 2 work.
-- No rows were changed or removed to produce this result.
