# Week 5 — Visualisation design

## 1. What was the business question or task?

This week the group each built a Power BI dashboard answering a different
stakeholder question, then combined them into one shared investor view. My
assigned task (**Task Card B**) was the marketing question: **which sales
channel — in-store ("pood") or online — actually performs better**, in
revenue, reach, and how customer acquisition has trended over time, so Anna
can decide where to keep investing. After finishing my own task card, I also
went ahead and built **Task Card D** myself — the combined Investor
Dashboard — pulling in my own Task B numbers plus the findings from the
teammates who owned Task Cards A (financials) and C (operations).

## 2. What did I do, and what evidence can a reader inspect?

Dashboard file: `Dashboard/urbanstyle_week5_dashboard_reio.pbix` (two report
pages — **Task card B** and **Task card D**). Screenshots:
`week-5-evidence/Power BI week 5 - Marketing.png` (Task B) and
`week-5-evidence/Power BI week 5 - Investor.png` (Task D).

### Task Card B — Sales-channel effectiveness

| Visual | Question | Result |
|---|---|---|
| Sales-channel effectiveness (bar) | Which channel generates more revenue? | Pood (in-store) €1,902,430.30 vs. online €1,006,747.68 |
| Unique customers by channel (bar) | Which channel reaches more distinct customers? | Pood 2,279 distinct customers vs. online 1,707 |
| Customer acquisition over time (line) | Is the acquisition trend healthy across the full date range? | Chronological Year+Month line, Jan 2023 onward, revenue-channel gap holds steady until the data thins out in 2025 |

Two checks mattered more than the chart-building itself. First, a plain
`COUNT` of `customer_id` overstated both channels' customer numbers because
the same customer can appear across multiple orders — switching to
`DISTINCTCOUNT` gave the real 2,279 vs. 1,707. Second, the acquisition line
chart initially collapsed every year onto the same 12 months when I used
"drill down" on the date hierarchy; using "expand to next level" instead
kept Year and Month together and produced a real chronological timeline. That
timeline then showed 2025 going almost silent between March and November —
I confirmed with a temporary diagnostic table (Year/Month/customer count)
that this is a genuine gap in the source data (reliable Jan 2023–Feb 2025,
sparse after) rather than another drill artefact. I chose to keep the full
range visible rather than trim the chart, and call the gap out directly here
instead of letting it quietly understate 2025 activity.

**Recommendation to Anna:** pood is the stronger channel on every measure —
2,279 customers and €1,902,430 in revenue vs. online's 1,707 customers and
€1,006,748, and pood customers also spend more per order (~€835 vs. ~€590).
Keep prioritizing in-store investment, and look into what's driving online's
lower average order value. Don't read anything into channel performance
after Feb 2025 — the data there is too sparse to trust.

### Task Card D — Investor Dashboard (self-initiated, combines Roles A + B + C)

No one had picked up Task Card D yet, so once Task B was done I built it
myself and folded in teammates' numbers as they became available. Measures
(DAX, under `public sales`):

```dax
Total Revenue = SUM('public sales'[total_price])
Total Customers = DISTINCTCOUNT('public sales'[customer_id])
Average Order Value = DIVIDE([Total Revenue], COUNTROWS('public sales'))
Revenue Growth % =
VAR Rev2024 = CALCULATE([Total Revenue], YEAR('public sales'[sale_date]) = 2024)
VAR Rev2023 = CALCULATE([Total Revenue], YEAR('public sales'[sale_date]) = 2023)
RETURN DIVIDE(Rev2024 - Rev2023, Rev2023)
```

plus a calculated column to label online sales, since `store_location` is
blank for them:

```dax
SalesLocation = IF(ISBLANK('public sales'[store_location]), "Online", 'public sales'[store_location])
```

| Visual | Result |
|---|---|
| KPI cards | Total Revenue €2.91M · Total Customers 2.55K · Average Order Value €287.53 · Revenue Growth % +19.1% · Low Stock Alerts 216 (from Role C) |
| Revenue trend (line) | Same Year+Month chronological fix as Task B, full range shown |
| Revenue by store location (bar) | Tallinn ≈€1.09M, Online ≈€1.01M, Tartu ≈€0.52M, Pärnu ≈€0.29M |

Two build issues worth noting. The Power BI **KPI visual** initially showed
a Revenue Growth % of 32.2% instead of the correct 19.1% — it turned out the
KPI visual filters its "Value" by only the *last point* of the trend axis
(December in isolation), unlike a plain Card visual which shows the true
unfiltered total. I used the Card visual's 19.1% and dropped the KPI visual.
Separately, clicking a bar in one chart cross-filtered the whole page and
made the KPI cards show wrong, partial totals (e.g. €95.78K instead of
€2.91M) until I clicked the empty page background to clear the selection —
worth remembering since it's easy to mistake for a data bug.

Tallinn + Tartu + Pärnu (€1.09M + €0.52M + €0.29M ≈ €1.90M) lines up with
Task B's own "pood" total, which was a useful sanity check that the two
pages agree with each other.

## 3. What did I learn or recommend next?

For Anna (marketing): double down on in-store, and dig into why online's
average order value lags. For the combined investor view: the business is
growing at +19.1% YoY, led by Tallinn and the in-store channel overall, but
the 216 low-stock items Role C flagged should be resolved before they turn
into missed sales — and any 2025+ trend numbers need the sparse-data caveat
attached, on both my page and the combined one.

The bigger lesson this week was about visual, not written, honesty: it's
easy to make a chart *look* clean by trimming the range or letting a KPI
visual quietly filter itself down to a friendlier number. Catching the
KPI-vs-Card discrepancy and choosing to show the real acquisition gap rather
than hide it both came down to the same habit — check what a visual is
actually computing before trusting what it displays.

## AI use

I used Claude for step-by-step Power BI guidance throughout — fixing DAX
syntax errors (a stray "Measure =" placeholder, quoting a table name with a
space), diagnosing why the acquisition line chart collapsed to 12 months
(drill-down vs. expand-to-next-level) and why 2025 looked broken (a real
data gap, confirmed with a diagnostic table rather than assumed), and
explaining the KPI-vs-Card discrepancy in Task D before I reported the wrong
19.1%→32.2% number. Claude also helped me apply the task card's design
checklist (titles, sorting, a restrained color palette that highlights the
top performer) and draft the write-ups above from the numbers I found.

**Team's shared work:** Task Card D combines my own Task B findings with
data and screenshots shared directly by the teammates who owned Task Cards A
(financials) and C (operations); their own individual write-ups live in
their own submissions. This file documents my own Task B work plus my
self-initiated build of the combined Task D page.
