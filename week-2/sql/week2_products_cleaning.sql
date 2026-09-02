-- =====================================================================
-- Week 2 — Product Data Cleaning (Task Card C)
-- Author: Reio Lootsmann
-- Domain: products
-- Character brief: Toomas Kask — "Identify, Document, Test, only then Fix."
--
-- Process followed throughout: TEST COPY -> DIAGNOSE -> FIX -> VERIFY -> LOG.
-- The original `products` table is never touched directly.
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1: Create a test copy and confirm it matches the original
-- ---------------------------------------------------------------------
CREATE TABLE products_test AS SELECT * FROM products;

SELECT COUNT(*) AS row_count FROM products_test;
-- Expected / actual: 362 (matches original `products` table)


-- ---------------------------------------------------------------------
-- STEP 2: Diagnose — duplicate product names
-- ---------------------------------------------------------------------
SELECT product_name, COUNT(*) AS copy_count
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY copy_count DESC;
-- Result: 12 product names each appear exactly twice (24 rows total, 6.6% of catalog).
-- Not deleted: could be genuine product variants (e.g. same style, different
-- color/material) rather than data-entry errors. No variant/SKU column exists
-- to distinguish them, so a manual business review is required before any
-- row is removed.


-- ---------------------------------------------------------------------
-- STEP 3: Diagnose — NULLs in critical fields
-- ---------------------------------------------------------------------
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_name,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_category,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_retail_price,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_cost_price
FROM products_test;
-- Result: 0 / 0 / 0 / 0 — fully populated, nothing to fix.


-- ---------------------------------------------------------------------
-- STEP 4: Diagnose — logical errors (unrealistic prices)
-- ---------------------------------------------------------------------
-- Negative prices
SELECT COUNT(*) AS negative_price
FROM products_test
WHERE retail_price < 0;
-- Result: 0

-- Extreme prices (> €1,000)
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;
-- Result: 0 rows — no extreme prices.


-- ---------------------------------------------------------------------
-- STEP 5: Diagnose — category consistency
-- ---------------------------------------------------------------------
SELECT category, COUNT(*) AS count
FROM products_test
GROUP BY category
ORDER BY category;
-- Result: exactly 5 raw category values (Estonian snake_case), each with
-- ONE consistent spelling — meeste_riided (82), naiste_riided (70),
-- laste_riided (70), jalanõusid (73), aksessuaarid (67).
-- A clean result is a valid finding, not a failed query: no spelling
-- inconsistency to fix. The only remaining improvement is readability,
-- addressed in the advanced extension below.


-- ---------------------------------------------------------------------
-- STEP 6: Log the base-level diagnosis
-- ---------------------------------------------------------------------
INSERT INTO cleaning_log (table_name, action, rows_affected, details)
VALUES (
  'products_test',
  'DOCUMENT diagnostic findings',
  0,
  '362 products checked. 12 product names appear exactly twice each (24 rows '
  || 'total) — not deleted, as this may reflect genuine variants rather than '
  || 'errors. 0 NULLs in product_name, category, retail_price, or cost_price. '
  || '0 negative retail prices. 0 extreme retail prices (>1000). category has '
  || 'exactly 5 values, each with one consistent spelling — no standardization '
  || 'needed. Table required no destructive fixes.'
);


-- =====================================================================
-- ADVANCED EXTENSION (optional, 30%): standardize category labels
-- =====================================================================

-- ---------------------------------------------------------------------
-- STEP 7: Fix — translate Estonian snake_case categories to readable
-- English labels
-- ---------------------------------------------------------------------
UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) = 'meeste_riided' THEN 'Menswear'
    WHEN LOWER(TRIM(category)) = 'naiste_riided' THEN 'Womenswear'
    WHEN LOWER(TRIM(category)) = 'laste_riided'  THEN 'Kidswear'
    WHEN LOWER(TRIM(category)) = 'jalanõusid'    THEN 'Footwear'
    WHEN LOWER(TRIM(category)) = 'aksessuaarid'  THEN 'Accessories'
    ELSE INITCAP(TRIM(category))
END;


-- ---------------------------------------------------------------------
-- STEP 8: Verify
-- ---------------------------------------------------------------------
SELECT category, COUNT(*) AS count
FROM products_test
GROUP BY category
ORDER BY category;
-- Result: Accessories (67), Footwear (73), Kidswear (70), Menswear (82),
-- Womenswear (70) — sums to 362, matching the original raw counts exactly.
-- No rows lost or miscategorized.


-- ---------------------------------------------------------------------
-- STEP 9: Log the fix
-- ---------------------------------------------------------------------
INSERT INTO cleaning_log (table_name, action, rows_affected, details)
VALUES (
  'products_test',
  'STANDARDIZE category labels',
  362,
  'Translated Estonian snake_case category values to readable English labels '
  || 'via CASE WHEN: meeste_riided -> Menswear (82), naiste_riided -> '
  || 'Womenswear (70), laste_riided -> Kidswear (70), jalanõusid -> Footwear '
  || '(73), aksessuaarid -> Accessories (67). Verified: all 362 rows accounted '
  || 'for, counts match original raw values exactly, no data lost.'
);


-- =====================================================================
-- SUMMARY / CLEANING REPORT
-- =====================================================================
-- Category            | Issues found | Description
-- --------------------|--------------|---------------------------------
-- Duplicate names      | 12 (24 rows) | Same product name more than once
-- NULL name/price       | 0            | Missing critical fields
-- Logical errors       | 0            | Negative or extreme retail price
-- Inconsistent categories | 0         | Same category in different spellings
-- NULL cost price/category | 0        | Missing classification
-- TOTAL issues         | 12           |
--
-- Recommendation: Duplicate product names are the only real issue found —
-- everything else across pricing, NULLs, and category consistency came back
-- completely clean. This matters most for any analysis that groups or
-- aggregates by product_name instead of product_id, since it would silently
-- combine two potentially-different products under one label. Recommend
-- always aggregating by product_id, and manually reviewing the 12
-- duplicate-name pairs to confirm whether they're data-entry duplicates or
-- intentional variants.
--
-- Full team output (Key Findings across all four domains, Biggest Surprise,
-- Recommendation for Toomas, Missing Data, and the Preparing-the-Demo
-- outcome points) is in week-2/team/week2_team_cleaning_report.md.
-- =====================================================================
