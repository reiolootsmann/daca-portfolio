# Week 1 — Investigating UrbanStyle.ltd's sales data quality

## 1. What was the business question or task?

Toomas Kask, UrbanStyle.ltd's IT Director, does not trust the `sales`
table. In his letter to the team he named three specific worries:
rows that look like the same sale recorded more than once (his rough
estimate: over five thousand), customer references that point
nowhere, and negative prices, which "is not a thing that can happen
in a shop." His instruction was explicit: **investigate and report
only — do not change anything in the database yet.**

So the Week 1 question was: using only the three released tables
(`products`, `customers`, `sales`) and Week 1 SQL skills (`SELECT`,
`WHERE`, `COUNT`, `DISTINCT`, `ORDER BY`, `LIMIT` — no joins yet), how
bad is it, really?

## 2. What did I do, and what evidence can a reader inspect?

First, I loaded and verified the three tables (see
`setup-evidence/row-count-check.png`): 362 products, 3,150 customers,
15,234 sales rows. That baseline is the foundation everything below
is measured against.

Then I wrote four read-only queries in `sql/`, one per concern in
Toomas's letter, each saved with its business question, exact result
and stated limitation as comments in the file:

| File | Question | Result |
|---|---|---|
| `week1_01_baseline_counts.sql` | How large are the three tables? | products 362, customers 3,150, sales 15,234 |
| `week1_02_sale_and_invoice_id_check.sql` | Do sales rows match distinct sale/invoice identifiers? | 15,234 rows vs 10,118 distinct `sale_id` **and** 10,118 distinct `invoice_id` → a gap of 5,116 rows |
| `week1_03_non_positive_total_price.sql` | How many sales have `total_price <= 0`? | 305 rows (about 2.0%) |
| `week1_04_customer_reference_check.sql` | Do sales customer references "point nowhere"? | 1,487 rows (9.8%) have no `customer_id` at all (guest purchases); of the rows that do have one, 0 fail to match a real `customers` row |

No `UPDATE` or `DELETE` statements were run against any table.

## 3. What did I learn or recommend next?

Toomas's estimate of "over five thousand" repeated-looking sales
checks out as a row-count gap: 5,116 more sales rows than distinct
`sale_id`/`invoice_id` values. But a gap between a row count and a
distinct-ID count is not, by itself, proof that every extra row is an
erroneous duplicate — it needs a definition and a validation rule
before anyone treats it as a confirmed number. That's exactly the
Week 2 task, and I've deliberately left those rows untouched.

The negative-price concern is real but smaller than it sounds: 305
rows, 2% of the table. Some of these may be legitimate returns rather
than errors — that needs a business definition from Toomas, not a
query result.

The "customer references that point nowhere" concern turned out to
be more specific than expected: every sale that does carry a
`customer_id` matches a real customer (0 orphans) — the database's
foreign key already enforces that. What I found instead is that 9.8%
of sales have no `customer_id` recorded at all (guest purchases),
which is a different pattern, not a broken reference. If Toomas meant
something else by "point nowhere" — for example the same person
existing under more than one customer record — checking that needs a
join across tables, which is outside the Week 1 skill boundary and is
now a flagged question for a later week.

**Team's shared work:** Session 2 (group work) hasn't happened yet — link to follow.