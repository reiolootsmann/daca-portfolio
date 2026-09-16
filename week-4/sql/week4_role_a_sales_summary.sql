-- =====================================================================
-- Week 4 — Sales Summary (Task Card A)
-- Author: Reio Lootsmann
-- Domain: Sales aggregation (monthly + category summaries, monthly trends)
-- Character brief: Kristi Tamm (CEO) — "I want numbers for the board
-- meeting. Average order value, top categories, sales trends. FAST!"
--
-- Techniques used: GROUP BY, HAVING, CTE (WITH), window function (LAG).
-- All queries are read-only (SELECT) — no data was modified.
-- Tables: sales, products.
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1: Sales by month — how does revenue change month by month?
-- ---------------------------------------------------------------------
SELECT
    DATE_TRUNC('month', sale_date) AS month,
    COUNT(sale_id) AS order_count,
    SUM(total_price) AS total_revenue,
    ROUND(AVG(total_price), 2) AS average_order
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;
-- Result: 21 rows (2024 through mid-2026). 2024 is the full, reliable
-- range; 2025 onward is a sparse tail (most months have only a handful
-- of orders) — likely a synthetic-data generation artifact, the same
-- shape we found in Week 3's customer-registration recency-bias finding.
-- Kept the full range here since raw monthly totals are self-explanatory
-- (a reader can see the small 2025+ numbers for themselves), but see
-- Step 3 for why the *trend* calculation needed a stricter cutoff.


-- ---------------------------------------------------------------------
-- STEP 2: Sales by category — which categories should Kristi hear about?
-- ---------------------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS product_count,
    SUM(s.total_price) AS total_sales,
    ROUND(AVG(p.retail_price), 2) AS average_price
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(s.total_price) > 700000
ORDER BY total_sales DESC;
-- Result: only 2 of 5 categories clear the €700K threshold —
-- jalanõusid (footwear): €774,034.75 from 71 products, avg €213.26
-- meeste_riided (menswear): €749,798.72 from 81 products, avg €188.61
-- The other 3 categories (naiste_riided, aksessuaarid, laste_riided)
-- all fall below €700K and are filtered out by HAVING.


-- ---------------------------------------------------------------------
-- STEP 3: Monthly trends with a CTE — month-on-month growth (advanced)
-- ---------------------------------------------------------------------
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        COUNT(sale_id) AS order_count,
        SUM(total_price) AS revenue,
        ROUND(AVG(total_price), 2) AS average_order
    FROM sales
    WHERE sale_date >= '2024-01-01' AND sale_date <= '2024-12-31'
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    month,
    order_count,
    revenue,
    average_order,
    LAG(revenue) OVER (ORDER BY month) AS previous_month,
    revenue - LAG(revenue) OVER (ORDER BY month) AS change,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month) * 100, 1
    ) AS growth_percentage
FROM monthly_sales
ORDER BY month;
-- Result: 12 clean rows (2024 only). Deliberately capped to 2024 here,
-- unlike Step 1 — a growth-percentage calculation is misleading on the
-- sparse 2025+ tail (tested this live: a month with ~1 order can show
-- +1,700% growth against another near-empty month, which is technically
-- correct arithmetic but not a number anyone should report to a CEO).
--
-- Jan   85,618.65  (—)
-- Feb   90,181.83  (+5.3%)
-- Mar  109,559.98  (+21.5%)
-- Apr  113,838.38  (+3.9%)
-- May  116,843.02  (+2.6%)
-- Jun  144,558.18  (+23.7%)
-- Jul  146,800.80  (+1.6%)
-- Aug  144,870.17  (-1.3%)
-- Sep  109,267.47  (-24.6%)  <- sharpest drop of the year
-- Oct  127,622.32  (+16.8%)
-- Nov  110,573.94  (-13.4%)
-- Dec  170,623.28  (+54.3%)  <- revenue peak AND biggest single jump
--
-- Total 2024: 5,137 orders (cross-checks exactly against the year-level
-- COUNT(*) run earlier), ~€1,470,358 total revenue.


-- =====================================================================
-- SUMMARY FOR KRISTI (board meeting)
-- =====================================================================
-- 2024 revenue grew from €85,618.65 in January to €170,623.28 in
-- December — a strong year overall, with December alone up 54.3% on
-- November. Growth wasn't steady: September saw a sharp 24.6% drop that
-- interrupted an otherwise rising trend, which is worth a follow-up
-- question rather than reading too much into month-to-month noise. At
-- the category level, only footwear (€774,034.75) and menswear
-- (€749,798.72) clear €700K in sales — together they carry the bulk of
-- category revenue, while accessories and kidswear trail well behind.
-- My recommendation to Kristi: highlight December's strong close and
-- the footwear/menswear lead, but flag the September dip as something
-- to investigate before the board meeting, and treat any revenue
-- figures from 2025 onward as unreliable given how sparse that data is.
-- =====================================================================
