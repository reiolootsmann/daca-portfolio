# Week 4 — Sales summary with SQL aggregation

## 1. What was the business question or task?

CEO Kristi Tamm needed summary numbers for a board meeting — average order
value, top categories, sales trends — and needed them fast. Anna Mets
coordinated the group work so every domain (sales, customers, inventory,
marketing) would produce its own aggregated report. My assignment this week
(Task Card A) was the **Sales Summary**: monthly and category-level totals,
plus the month-on-month trend, built with GROUP BY, HAVING and a CTE.

## 2. What did I do, and what evidence can a reader inspect?

Full commented script: `sql/week4_role_a_sales_summary.sql`.

| Step | Question | Result |
|---|---|---|
| Sales by month | How does revenue change over time? | 21 months of data (2024 through mid-2026), but 2025+ is a sparse tail — most of those months have only a handful of orders |
| Sales by category (HAVING) | Which categories should Kristi hear about first? | Only 2 of 5 categories clear €700K: footwear (€774,034.75) and menswear (€749,798.72) |
| Monthly trends (CTE + LAG) | What's the real 2024 growth pattern? | Revenue grew from €85,618.65 (Jan) to €170,623.28 (Dec), +54.3% in December alone, with a -24.6% dip in September |

Before trusting any of these numbers, I ran a couple of diagnostic checks
that turned out to matter more than the exercise itself expected. A first
pass at "sales by month" returned 21 rows instead of the ~12 the workbook
assumed, which led to checking `MIN(sale_date)`, `MAX(sale_date)` and a
year-by-year `COUNT(*)`: the real data runs 2023-01-01 to 2026-06-28
(10,118 rows total), but volume collapses from 5,137 orders in 2024 to just
691 in 2025 and 16 in 2026 — almost all of it front-loaded into
January/February 2025, then close to nothing for nine straight months. I
tested what that sparse tail does to a growth-percentage calculation
directly: one query returned **+1,715% growth** for June 2026, which is
correct arithmetic on a ~€77 → ~€1,400 swing but not a number anyone should
put in front of a CEO. That's why the trend query (Step 3) is deliberately
capped to `sale_date <= '2024-12-31'` even though the monthly-totals query
(Step 1) keeps the full range.

## 3. What did I learn or recommend next?

My recommendation to Kristi: lead with December's strong close (+54.3% on
November, the year's revenue peak) and the fact that footwear and menswear
are the only two categories clearing €700K — together they carry the bulk
of category revenue. But flag the September dip (-24.6%) as worth a
follow-up question before the board meeting, since it's the one break in
an otherwise rising year. And don't report any 2025+ revenue figures
without a caveat — the data there is too sparse to represent real business
activity.

The most useful lesson this week wasn't a specific SQL clause — it was that
**aggregation is also a validation tool**. A "0 rows returned" from a badly
chosen HAVING threshold, or a percentage that jumps past 1,000%, isn't a
bug to route around; it's the data telling you to check your assumptions
before you report a number. Diagnosing the sparse-tail issue with a simple
year-level COUNT(*) before trusting any month-level trend is a habit I'll
keep using.

## AI use

I used Claude to build a self-study companion with precomputed expected
results, and to help debug two live issues: a HAVING threshold that was
orders of magnitude off (first too low to filter anything, then flipped
with `<` instead of `>`), and the misleading growth-percentage values in
the sparse 2025–2026 data. Claude flagged the unreliable percentages before
I reported them and helped design the 2024-only cutoff for the trend query.

**Team's shared work:** the group's Week 4 aggregation findings across all
task cards (sales summary, customer segmentation, inventory statistics, and
marketing channel ROI) — including the shared biggest surprise,
recommendation for Anna, and missing-data synthesis — are presented in the
Session 2 group meeting. This file covers only my own Task Card A (sales
summary) contribution.
