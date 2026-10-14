# Week 7 — Python and pandas (RFM customer segmentation)

## 1. What was the business question or task?

Marko Saar, UrbanStyle's Product Manager, wanted customer-level insight beyond the
aggregated dashboard: who are our best customers, who spends the most, and who hasn't
bought in a while — so he can build targeted campaigns (a VIP programme, a win-back
campaign, onboarding for new customers). My team decided each member would build the
full pipeline individually (Role A through D) rather than split it across four people,
so this notebook covers Data Loading, Cleaning, RFM Analysis, and Visualization all
built by me.

## 2. What did I do, and what evidence can a reader inspect?

Notebook: `week7_rfm.ipynb`.

**Role A — Data Loading.** Connected to Supabase via the Python client
(credentials in `.env`, kept out of Git via `.gitignore`), loaded `sales` and
`customers`, merged on `customer_id`. One early catch: Supabase caps results at 1,000
rows per request by default — my first load silently truncated both tables. I
rewrote the loader to paginate with `.range()`, which pulled the full 10,118 sales
rows and 3,150 customers instead of 1,000.

**Role B — Data Cleaning.** 0 duplicate invoices (the table was already cleaned in
Week 3), 988 rows dropped for missing `customer_id` (orphan sales), 180 rows dropped
for zero/negative `total_price`, dates converted to real datetimes. Final: 8,950 clean
rows, 2,540 unique customers, Jan 2023 – mid-2026.

**Role C — RFM Analysis.** Calculated Recency, Frequency, Monetary per customer,
scored 1–5 by quintile, with Recency's labels reversed (fewer days = better) and
Frequency ranked first to handle tied purchase counts. I changed the reference date
from the task card's suggestion (Feb 2025) because it produced negative "days since
last purchase" for several top-spending customers — the real data runs past that
point. Segment sizes came out identical either way (RFM scoring is rank-based, not
scale-based), but every recency value is now a genuine, positive number.

| Segment | Count | Share |
|---|---|---|
| Potential Loyalists | 759 | 29.9% |
| Loyal Customers | 679 | 26.7% |
| At Risk | 529 | 20.8% |
| VIP Champions | 455 | 17.9% |
| Lost | 118 | 4.6% |

**Role D — Visualization.** Three Plotly charts: segment distribution, Recency vs
Monetary (scatter, coloured by segment, sized by frequency), and Top 10 VIP Champions
by spend, each bar labelled with the exact euro amount.

## 3. What did I learn or recommend next?

No customers fall into "Lost" — even the weakest segment (At Risk) shows some
redeeming signal on at least one RFM dimension, so there's no outright-abandoned
group. My recommendation: prioritize a win-back campaign for the 647 At-Risk
customers before investing further in VIP perks — retaining existing customers is
usually cheaper than rewarding already-loyal ones, and at 25.5% of the base, churn
risk there is larger than it first looks. Limitations: no return/refund data (so raw
spend may overstate some customers' true value), no demographics, no web-behaviour or
satisfaction data to explain *why* At-Risk customers are disengaging.

## AI use

I used Claude throughout this week: setting up the full local environment (Python,
pandas, Jupyter, a project-specific virtual environment, fixing a Windows PowerShell
execution-policy block and a PATH issue), connecting to Supabase safely via
`.env`/`.gitignore`, and catching a real bug where Supabase's default 1,000-row limit
was silently truncating my data before I'd even started. Claude also helped me build
the RFM pipeline step by step, catch a cell-ordering error during the final
Restart & Run All check, and think through two genuine analytical decisions: moving
the RFM reference date to avoid nonsensical negative recency values, and noticing my
segmentation function was quietly merging "Lost" into "At Risk" until I gave it its
own tier.