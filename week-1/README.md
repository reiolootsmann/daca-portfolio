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

Later, during the group session, Toomas raised the same worry about
every table, not just `sales`: "I don't trust this data yet... I want
a separate report on EVERY table." The team split the tables up by
role; my assignment (Role B / Task Card B) was to investigate
`customers`.

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

### Session 2 — additional queries from the group meeting

During Session 2, the meeting lead ran through basic queries against
`sales` live in Supabase. I couldn't note down all of hers in time, so
I wrote three of my own afterward, covering the same territory —
reading the table and sizing up the duplicate-row issue:

| File | Question | Result |
|---|---|---|
| `session2_01_rows_and_unique_customers.sql` | How many sales rows are there, and how many distinct customers do they represent? | 15,234 rows, 2,558 distinct `customer_id` values |
| `session2_02_unique_products_sold.sql` | How many of the 362 catalogue products actually appear in `sales`? | 350 distinct `product_id` values (about 12 products never sold) |
| `session2_03_rows_vs_unique_sale_id.sql` | Does the row-count-vs-distinct-ID gap from `week1_02` show up with a simpler, single-field version of the same check? | Same result: 15,234 rows vs 10,118 distinct `sale_id` |

### Task Card B (group meeting) — Customer data

For Toomas's "a separate report on every table" challenge, my role
was to investigate `customers`. Screenshots for these six queries are
in `Customer data evidence/` (a separate folder from
`setup-evidence/`, created during the live session).

| File | Question | Result |
|---|---|---|
| `week1_05_customer_count.sql` | How many customers are there in total? | 3,150 customers |
| `week1_06_customer_table_sample.sql` | What columns and data does the table actually contain? | `customer_id`, `first_name`, `last_name`, `email`, `phone`, `city`, `registration_date`, `loyalty_tier`, `birth_year` |
| `week1_07_customer_cities_by_count.sql` | Which cities are customers from, and how many per city? | 54 distinct raw `city` values for roughly a dozen real cities; Tallinn alone is split across at least 4 spellings ("Tallinn" 1,135, "Tallinn " 31, "tallinn" 26, " Tallinn" 23) |
| `week1_08_tallinn_customers.sql` | Sample of customers from one city, sorted by name | Exact-match `city = 'Tallinn'` rows only — undercounts the real Tallinn total for the reason above |
| `week1_09_customer_registration_range.sql` | When did the first and most recent customers register? | Earliest 2020-01-02, latest 2025-02-27 |
| `week1_10_customer_missing_values.sql` | Are any customers missing a first name or an email? | 0 missing first names; 380 missing emails (about 12%) |

No `UPDATE` or `DELETE` statements were run against `customers`
either.

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

Session 2 added two more useful baseline numbers: sales only
represent 2,558 distinct customers (out of 3,150 in the customers
table) and 350 distinct products (out of 362 in the catalogue) — both
worth keeping in mind before making any "per customer" or "per
product" claim later.

There are 3,150 customers in the table, spread across roughly a dozen
real cities — though you can't read that off `GROUP BY city` directly,
because of the spelling issue below. The most surprising finding was
how messy `city` is: 54 different raw values came back where there
should only be about 12, purely from inconsistent casing and stray
leading/trailing spaces. That's not a rare edge case — Tallinn alone,
the most common city, is fragmented across at least 4 spellings. Any
report or filter that groups customers by city as it's currently
stored will undercount, not fail outright, which is arguably worse
because it looks correct at a glance. Missing data was minimal on the
name side (0 missing first names) but real on the contact side (380
customers, about 12%, have no email on file) — worth flagging if
email is meant to be a required field. None of this was changed in
the database; standardising `city` and deciding what to do about
missing emails are both cleanup questions for a later week, not this
one.

**Team's shared work:** Session 2 (group work) happened, and the
group's "report on every table" challenge is in progress — this file
covers my Role B (`customers`) contribution; link to the team's
shared repository/board to follow.
