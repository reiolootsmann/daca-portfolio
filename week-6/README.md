# Week 6 — Visualisation Data (polish, story, publish)

## 1. What was the business question or task?

Week 5 built a working dashboard prototype; Week 6's job was to turn it into
something investor-ready — a dashboard that tells a story, not just shows
numbers. Anna Mets wants every store to have its own view, and CEO Kristi
Tamm wants proof the team can spot both strengths and risks, not just
growth. My assigned task (**Task Card — Role C**) was the **Pärnu store
story**: Pärnu is UrbanStyle's smallest store and a summer-resort location,
and the question was whether its seasonality is real, how strong it is, and
what that means for the business.

## 2. What did I do, and what evidence can a reader inspect?

Dashboard file: `Dashboard/urbanstyle_week6_dashboard_reio.pbix` (page:
"TASK CARD — ROLE C: Pärnu Store Story", built on top of my Week 5/6 file).
Screenshot: `week-6-evidence/`.

| Visual | Question | Result |
|---|---|---|
| KPI cards | What's Pärnu's overall size? | €288.74K revenue, 747 customers, €272.91 average order — UrbanStyle's smallest store, consistent with the €0.29M figure I found for Pärnu back in Task Card D |
| Revenue trend (line, Year+Month) | Is there a real long-term pattern? | Same data-completeness gap as Task Cards B and D — reliable through Feb 2025, sparse after; not treated as a real decline |
| Revenue by month, all years combined (bar) | Is there a real seasonal pattern? | August is the peak month (~€33K vs. a €24K average), May the low point (~€19.5K) — annotated with 2 text callouts and a dotted average-monthly-revenue reference line |
| Top 5 products by revenue (bar) | Does a "summer collection" drive the peak? | Top sellers include footwear alongside cooler-weather items (a tweed shirt, warm loafers) — the August spike isn't simply a beach-wear swap |

The most useful check this week was resisting the temptation to eyeball the
seasonal chart. I initially misread which month was lowest just from bar
length in a screenshot — hovering for the exact tooltip values corrected it
from "October" to the actual low point, May. That's the same lesson as
Week 5's decimal-comma mix-up: read the real number before writing a
finding down, don't trust a quick visual impression.

Filtering technique: a page-level filter on `store_location = 'Pärnu'`, so
every visual on the page — including the DAX measures reused from Task Card
D (`Total Revenue`, `Total Customers`, `Average Order Value`) — automatically
scopes to just this store without needing separate measures.

## 3. What did I learn or recommend next?

Pärnu does show a summer lift, but it's a moderate one (~70% swing between
May and August), not the dramatic "summer carries the year" story often
assumed of resort towns — and the top-selling products aren't purely
seasonal either. My recommendation: don't treat Pärnu as a pure summer play;
a light spring promotion to smooth the May dip is a more useful lever than
doubling down on summer alone.

The broader lesson from this week was about verifying a visual claim before
writing it into a business story — a chart can look like it says one thing
at a glance and say something slightly different once you check the actual
numbers. Data storytelling only works if the story is accurate first.

## AI use

I used Claude for step-by-step Power BI guidance: fixing a page-level filter
that wasn't actually applied (it had landed as a single-visual filter
instead), rebuilding the KPI cards and month-only seasonal chart, adding
annotations, an arrow, and an Analytics-pane average reference line, and
formatting a measure's decimal places. Claude also caught that my first read
of the seasonal chart (calling October the low point) was wrong once I
checked the real tooltip values, and helped me phrase the executive summary
findings honestly rather than overstating the seasonal pattern.

**Team's shared work:** this file covers only my own Task Card C (Pärnu)
contribution. The team's combined four-location view (Tallinn, Tartu,
Pärnu, Online) and shared synthesis will be added here — or in a separate
`team/` note — once the rest of the group's dashboards are ready.
