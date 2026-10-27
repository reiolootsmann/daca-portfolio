# DACA Portfolio

**Participant:** Reio Lootsmann

**Programme:** Data Analyst Career Accelerator (DACA)

## About this portfolio

This repository documents my learning projects and evidence from the 10-week DACA
programme: SQL/PostgreSQL, Python/pandas, and Power BI/Plotly, all built around a
shared case study — UrbanStyle.ltd, a fictional Estonian fashion e-commerce company.

A note on structure: rather than one GitHub repo per project, this portfolio keeps
every week as its own folder (`week-0` through `week-10`) inside a single repository.
Each week's folder has its own README describing the business problem, what I built,
the results, and how I used AI.

## Projects

- [Week 0](week-0/): First SQL in Supabase — `CREATE TABLE`, `INSERT`, `SELECT` on a practice `team_members` table.
- [Week 1](week-1/): Investigated UrbanStyle's sales data quality — found duplicate, orphan, and negative-price rows using `SELECT`/`WHERE`/`COUNT`/`DISTINCT`.
- [Week 2](week-2/): Cleaned and standardised the `products` table on a test copy before touching production (`DELETE`/`UPDATE`/`COALESCE`/`CASE`/`TRIM`).
- [Week 3](week-3/): Joined `products`, `customers` and `sales` to analyse sales-channel effectiveness.
- [Week 4](week-4/): Built a `GROUP BY`/`HAVING`/CTE sales summary — monthly and category-level trends for a board meeting.
- [Week 5](week-5/): Designed a Power BI dashboard comparing in-store vs. online channel performance, plus a combined Investor Dashboard.
- [Week 6](week-6/): Polished the dashboard into an investor-ready story, including a dedicated Pärnu-store seasonality analysis.
- [Week 7](week-7/): RFM customer segmentation in Python/pandas — 2,540 customers scored into 5 segments (455 VIP Champions, 17.9%).
- [Week 8](week-8/): Automated the weekly reporting pipeline (Supabase API → pandas → Plotly), cutting a ~4-hour manual process to 2.8 seconds.
- [Week 9](week-9/): Co-authored UrbanStyle's hiring guide (Technical Interviewer's view) as part of career-prep group work.
- [Week 10](week-10/): Portfolio polish and closing board presentation — in progress.

## Skills in progress

- SQL (PostgreSQL): `JOIN`s, CTEs, window functions, aggregation
- Python (pandas): data cleaning, RFM segmentation, automation
- Power BI / Plotly: dashboards and data storytelling
- Supabase REST API: pagination, retry/error handling
- Git and GitHub

## AI use

Every project from Week 4 onward has its own "AI use" section describing exactly
where AI helped (debugging, scaffolding, polishing text) and which decisions —
analytical logic, business conclusions — were my own.
