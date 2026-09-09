-- =====================================================================
-- Week 3 — Sales Channel Analysis (Task Card D)
-- Author: Reio Lootsmann
-- Domain: Sales channels + customers + products
-- Character brief: Anna Mets — "Which sales channels and cities are
-- working? I want to know EVERYTHING!"
--
-- JOIN types used: INNER JOIN (customers, products), GROUP BY aggregation.
-- All queries are read-only (SELECT) — no data was modified.
-- Prerequisite: Week 2 clean-up already applied to the real `sales` and
-- `customers` tables (Step 0 of the Week 3 self-study workbook).
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1: Explore — which sales channels exist?
-- ---------------------------------------------------------------------
SELECT DISTINCT channel FROM sales ORDER BY channel;
-- Result: 2 channels — 'online' and 'pood' (Estonian for "in-store").


-- ---------------------------------------------------------------------
-- STEP 2: Basic channel overview — which channel brings the most sales?
-- ---------------------------------------------------------------------
SELECT
    s.channel AS sales_channel,
    COUNT(DISTINCT s.customer_id) AS customers,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_revenue
FROM sales s
GROUP BY s.channel
ORDER BY total_revenue DESC;
-- Result: pood leads on every count — 2,278 customers, 6,656 purchases,
-- €1,902,430.30 total revenue. online: 1,706 customers, 3,462 purchases,
-- €1,006,747.68 total revenue.


-- ---------------------------------------------------------------------
-- STEP 3: JOIN with customers — which cities use which channel?
-- ---------------------------------------------------------------------
SELECT
    s.channel AS sales_channel,
    c.city AS city,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(s.total_price) AS total_revenue
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.channel, c.city
ORDER BY sales_channel, total_revenue DESC;
-- Result: Tallinn leads for BOTH channels — online: 667 customers,
-- €335,719.11; pood (via Step 6 store data): also Tallinn-dominant.
-- Tallinn is where the two channels most directly overlap for the
-- same customer base.


-- ---------------------------------------------------------------------
-- STEP 4: 3-table JOIN — which product categories sell in which channel?
-- ---------------------------------------------------------------------
SELECT
    s.channel AS sales_channel,
    p.category AS product_category,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_revenue,
    ROUND(AVG(s.total_price), 2) AS average_purchase
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY s.channel, p.category
ORDER BY sales_channel, total_revenue DESC;
-- Result: top category for online is jalanõusid (footwear, €248,820.61).
-- Top category for pood is meeste_riided (menswear, €447,173.58).
-- Channel and category preference differ, not just channel and city.


-- ---------------------------------------------------------------------
-- STEP 5: Most effective channel — revenue per customer
-- ---------------------------------------------------------------------
SELECT
    s.channel AS sales_channel,
    COUNT(DISTINCT s.customer_id) AS customers,
    SUM(s.total_price) AS total_revenue,
    ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS revenue_per_customer
FROM sales s
GROUP BY s.channel
ORDER BY revenue_per_customer DESC;
-- Result: pood €835.13 per customer vs online €590.12 per customer.
-- pood outperforms online on customer count, total revenue, AND
-- revenue per customer — the strongest channel on every measure.


-- =====================================================================
-- ADVANCED EXTENSION: store-level comparison
-- =====================================================================

-- ---------------------------------------------------------------------
-- STEP 6: Store comparison — does channel performance differ by store?
-- ---------------------------------------------------------------------
SELECT
    s.store_location AS store,
    s.channel AS sales_channel,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_revenue,
    ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS average_purchase
FROM sales s
GROUP BY s.store_location, s.channel
ORDER BY store, total_revenue DESC;
-- Result:
--   Tallinn (pood): 3,801 purchases, €1,092,083.15, avg €287.31
--   Tartu   (pood): 1,797 purchases, €521,603.11,   avg €290.26
--   Pärnu   (pood): 1,058 purchases, €288,744.04,   avg €272.91
--   (NULL)  (online): 3,462 purchases, €1,006,747.68, avg €290.80
-- Note: store_location is only populated for pood sales — online orders
-- aren't tied to a physical location, so this compares 3 physical
-- stores against one nationwide online channel, not city vs city.


-- =====================================================================
-- SUMMARY / CHANNEL ANALYSIS FOR ANNA
-- =====================================================================
-- Question              | Finding
-- -----------------------|--------------------------------------------
-- Most revenue           | pood: €1,902,430.30 vs online: €1,006,747.68
-- Most customers         | pood: 2,278 vs online: 1,706
-- Most effective (per    | pood: €835.13/customer vs online: €590.12
--   customer)            |
-- Best city (both        | Tallinn, for both channels
--   channels)             |
-- Category differs by    | online -> jalanõusid (footwear); pood ->
--   channel               | meeste_riided (menswear)
-- Average purchase size  | Consistent across all 4 store/channel rows
--                        | (€272.91-€290.80) — volume differs, not
--                        | basket size
--
-- For Anna: pood (in-store) is UrbanStyle's stronger channel on every
-- measure — €1,902,430 in revenue from 2,278 customers, versus online's
-- €1,006,748 from 1,706 customers, and a higher €835 average revenue
-- per customer versus online's €590. Tallinn dominates both channels,
-- so that's where the two most directly compete for the same
-- customers. But online isn't weak — as a single "location" it already
-- rivals Tallinn's entire physical store in revenue (€1.01M vs
-- €1.09M) and has the highest average purchase size of any store or
-- channel (€290.80), while Tartu and Pärnu's combined in-store revenue
-- (€810,347) is still smaller than online alone. That suggests online
-- is underinvested relative to its performance, not underperforming.
--
-- Recommendation: keep the marketing budget weighted toward Tallinn
-- and Tartu in-store, where it's already working, but grow the online
-- channel specifically to serve Tartu/Pärnu-area customers — online
-- may already be doing the work a second physical store expansion
-- would otherwise need to do.
-- =====================================================================
