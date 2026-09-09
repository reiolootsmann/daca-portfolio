# Week 3 — Sales channel analysis with SQL JOINs

## 1. What was the business question or task?

Anna Mets (UrbanStyle's Marketing Lead) needed answers that no single
table could give her: who are the best customers, which products sell,
which cities and channels are working, and who registered but never
bought anything? Toomas's answer: "That data exists, but it's in
different tables — you need to combine them with JOIN statements."

The group split UrbanStyle's four core questions across Task Cards
A–D. My assignment this week (Task Card D) was sales channel
effectiveness: which channels bring in the most sales, and which
customers use which channels?

## 2. What did I do, and what evidence can a reader inspect?

Before any JOIN work could produce reliable numbers, Week 2's
clean-up (duplicate removal, date-format fix, city standardization)
had to be applied to the real `sales` and `customers` tables — not
just the `_test` copies used for Week 2's portfolio artefact. That's
Step 0 of the self-study workbook, and it's what today's JOIN results
are built on: 10,118 clean sales rows, 12 standardized cities.

Full commented script: `sql/week3_role_d_sales_channels.sql`.

| Step | Question | Result |
|---|---|---|
| Channel overview | Which channel brings the most sales? | `pood` (in-store): €1,902,430.30 from 2,278 customers. `online`: €1,006,747.68 from 1,706 customers |
| Channel × city | Which cities use which channel? | Tallinn leads for both channels |
| Channel × category (3-table JOIN) | What sells where? | `online` → jalanõusid (footwear). `pood` → meeste_riided (menswear) |
| Revenue per customer | Which channel is most effective? | `pood`: €835.13/customer vs `online`: €590.12/customer |
| Store comparison (advanced) | Does performance differ by store? | Tallinn (pood) €1,092,083.15 — comparable to online's entire €1,006,747.68 nationwide |

`pood` (in-store) outperforms `online` on every base metric — revenue,
customer count, and revenue per customer. But the store-level
comparison tells a more interesting story: online, as a single
channel with no physical footprint, already generates almost as much
revenue as UrbanStyle's single biggest store (Tallinn), and has the
highest average purchase size of any store or channel.

## 3. What did I learn or recommend next?

My recommendation to Anna: keep the marketing budget weighted toward
Tallinn and Tartu in-store, where it's demonstrably working, but there
is a real case for growing the online channel specifically to serve
Tartu and Pärnu-area customers. Tartu and Pärnu's *combined* in-store
revenue (€810,347) is still smaller than online's alone — online may
already be doing the job a second physical store expansion would
otherwise need to do, and it isn't underperforming, it's underinvested.

The most useful JOIN technique this week wasn't the simplest one — it
was the 3-table JOIN (sales + customers + products), which is what
actually revealed that channel and category preference move together
(footwear online, menswear in-store), a pattern invisible from the
channel-only or city-only views.

**Team's shared work:** the group's Week 3 JOIN findings across all
four Task Cards (top customers, lost customers, unsold products +
inventory, and sales channels) — including the shared biggest
surprise, recommendation for Anna, and missing-data synthesis — are
presented in the Session 2 group meeting. This file covers only my
own Task Card D (sales channels) contribution.
