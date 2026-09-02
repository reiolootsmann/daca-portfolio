# Week 2 — Cleaning UrbanStyle.ltd's product data

## 1. What was the business question or task?

Toomas Kask came back with a sharper version of last week's worry: "I
just found 5,116 duplicate invoice rows! How many are there in each
domain?" The board meeting is two weeks out and he wants clean
numbers, but his rule was explicit — **test copy first, then clean,
then check, then document.** Nothing gets changed on the original
tables without a verified test-copy result behind it.

Session 1 introduced the tools for this: `DELETE` + `WHERE`, `UPDATE`
+ `SET`, `COALESCE`, `CASE WHEN`, `TRIM`/`INITCAP`. The group split
the four tables by role again; my assignment this week (Task Card C)
was `products`.

## 2. What did I do, and what evidence can a reader inspect?

All work happened on `products_test`, a copy of `products` created
with `CREATE TABLE products_test AS SELECT * FROM products` — the
original table was never touched. Every real action (or the decision
not to act) is recorded in a shared `cleaning_log` audit table.

Full commented script: `sql/week2_products_cleaning.sql`.

| Step | Question | Result |
|---|---|---|
| Test copy | Does the copy match the original? | 362 rows, matching `products` |
| Duplicates | Are any product names repeated? | 12 product names appear exactly twice (24 rows, 6.6% of the catalogue) — every group has exactly 2 copies, never 3+ |
| NULLs | Any missing name, category, or price? | 0 missing in `product_name`, `category`, `retail_price`, `cost_price` |
| Logical errors | Any negative or unrealistic (>€1,000) prices? | 0 negative, 0 over €1,000 |
| Category consistency | Does `category` have spelling/casing variants? | No — exactly 5 raw values, each with one consistent spelling |

I did **not** delete the 12 duplicate-name rows. There's no
variant/SKU/color column in the table to say whether they're
data-entry errors or legitimate separate products (the same style in
a different colour or material, for example) — that needs a business
answer, not an automatic fix.

Since the base-level diagnosis found nothing safe to delete or
correct, I also completed the optional advanced extension: the five
`category` values were stored as Estonian snake_case
(`meeste_riided`, `naiste_riided`, `laste_riided`, `jalanõusid`,
`aksessuaarid`), so I translated them to readable English labels with
a `CASE WHEN` (Menswear 82, Womenswear 70, Kidswear 70, Footwear 73,
Accessories 67) and verified the row counts still summed to 362
afterward, with nothing lost or reclassified.

Both the diagnosis and the category fix are logged in `cleaning_log`
with the table name, action, row count, and a plain-English
description of what happened and why.

## 3. What did I learn or recommend next?

Products turned out to be the cleanest of the four tables the team
looked at this week — no missing values, no bad prices, and category
data that needed no cleanup at all, only a readability improvement.
The one real issue, the 12 duplicate product names, has a
suspiciously tidy pattern (always exactly 2 copies, never more),
which reads more like something systematic in how the data was
generated than random data-entry error — worth a follow-up question
rather than an assumption.

My recommendation to Toomas: products data can be trusted for pricing
and category analysis as-is. The only open item is that any report
grouping or aggregating by `product_name` instead of `product_id`
would silently combine those 12 duplicate-name pairs into one line —
low risk compared to what the team found elsewhere, but worth a
one-line caveat in any name-based report until the 12 pairs are
manually reviewed.

**Team's shared work:** the group's Week 2 data-quality findings
across all four domains (sales, customers, products,
cross-validation) — including the shared "biggest surprise,"
recommendation, and missing-data synthesis, plus the outcome points
prepared for the live demo — are in the team's Data-Quality Summary
Report, presented in the Session 2 group meeting. This file covers
only my own Task Card C (`products`) contribution.
