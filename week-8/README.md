# Week 8 — Automated Data Pipeline

**Team:** [your team name/number]
**My role:** All four roles (API Query, Data Processing, Visualization + Saving, Automation) — our team agreed everyone builds the full pipeline solo, same approach as Week 7.

## Business Problem
Marko (Product Manager) wanted the weekly RFM-style analysis automated — currently it's done by hand every week and takes about 4 hours (load → clean → calculate → export). The goal: a single command that does it all.

## Approach

**Role A — `data_fetcher.py`:** Connects to Supabase via `supabase-py` and fetches `sales`, `customers`, and `products` tables. Handles pagination (the API caps responses at 1,000 rows per request) and retries failed requests with exponential backoff.

**Role B — `transform.py`:** Cleans the raw sales data (removes duplicate invoices, drops rows with missing key fields, filters out non-positive amounts), calculates weekly revenue/order aggregates, computes headline KPIs, and merges sales with customer data.

**Role C — `visualize_export.py`:** Builds a Plotly line chart of weekly revenue and a KPI summary indicator chart, then exports results to a timestamped CSV and the charts to HTML files in `output/`.

**Role D — `pipeline.py`:** Orchestrates all three stages (fetch → clean/aggregate → visualize/export) into one `run_pipeline()` function, with file-based logging (`logs/pipeline_YYYYMMDD.log`) and per-stage error handling, plus a `__main__` block that times the whole run.

## Key Findings
- 8,950 cleaned sales rows across 2,540 unique customers
- Total revenue: €2,676,850.54 (avg order value: €299.09)
- 183 weekly aggregate data points
- **Pipeline runtime: 2.8 seconds**, vs. an estimated ~4 hours doing the same steps by hand

## Technical Stack
Python 3, pandas, Supabase (PostgreSQL) via `supabase-py`, Plotly, Python's built-in `logging` module (console + file), `.env`/`.gitignore` for credential handling.

## Screenshots
*(to add: a screenshot of the KPI summary chart and the weekly revenue chart — `output/kpi_summary.html` and `output/weekly_revenue.html` are gitignored so they won't render on GitHub directly. Take a screenshot of each, the same way as the Week 5/6 dashboards, and save them under `week-8/week-8-evidence/`.)*

## How to Run
1. Clone the repo and `cd week-8/individual`
2. Create a `.env` file in the project root with your Supabase `SUPABASE_URL` and `SUPABASE_KEY` (same variable names `data_fetcher.py` reads)
3. Install dependencies: `pip install pandas supabase plotly`
4. Run `python pipeline.py` — this calls `data_fetcher` → `transform` → `visualize_export` in sequence and writes results to `output/` and a timestamped log to `logs/`

## Lessons Learned and Challenges
**Time saved:** The manual process takes roughly 4 hours a week; the automated pipeline completes the same work in under 3 seconds — a time saving of over 99%.

**Recommendation for extending automation:** Schedule the pipeline to run automatically (e.g. every Monday morning via GitHub Actions or cron) so Marko never has to trigger it manually. Natural next steps: a churn-risk alert for customers whose RFM segment drops, a low-stock/inventory warning, and a weekly summary email with the KPI chart attached.

**What happens if Supabase is down:** The retry logic in `data_fetcher.py` (3 attempts with exponential backoff) handles brief outages automatically. For a sustained outage, the pipeline currently fails cleanly at the fetch stage — it logs a clear error rather than crashing silently, but it does not yet fall back to cached/local CSV data. Adding that CSV fallback would be a good next improvement for production readiness.

## AI Use
Used AI to scaffold the pagination/retry logic in `data_fetcher.py`, the pandas cleaning and aggregation functions in `transform.py`, and the Plotly chart/export functions in `visualize_export.py`, then tested and adjusted each against the real Supabase data.
