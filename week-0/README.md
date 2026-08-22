# Week 0 — "Hello, UrbanStyle.ltd!": a small vertical slice

## What the table represents

`team_members` is a small practice table I created in Supabase during
Week 0 setup (`id SERIAL PRIMARY KEY`, `name`, `role`, `week`,
`joined_at`). It holds four rows: my own practice entry and three
fictional UrbanStyle.ltd colleagues — Toomas Kask (IT Director), Kristi
Tamm (CEO and co-founder) and Anna Mets (Marketing Lead). It is not
real company data; it's a safe table for practicing `CREATE TABLE`,
`INSERT` and `SELECT`.

## What the query returns

`hello_urbanstyle.sql` selects `id`, `name`, `role`, `week` and
`joined_at` from `team_members`, ordered by `id`. Run through VS
Code's SQLTools connection to my own Supabase project, it returns 4
rows:

| id | name | role | week |
|----|------|------|------|
| 10 | Reio Lootsmann | Data analyst | 0 |
| 11 | Toomas Kask | IT Director | 0 |
| 12 | Kristi Tamm | CEO and co-founder | 0 |
| 13 | Anna Mets | Marketing Lead | 0 |

## One thing I checked

I confirmed the connection itself was trustworthy, not just the
query: I ran the same query first in Supabase's browser SQL Editor,
then again from VS Code through SQLTools, and got the same 4 rows
back both times. That's the "vertical slice" — one path from stored
data, through a saved, version-controlled query file, to a result I
can point to.

## One thing this cannot tell you about UrbanStyle.ltd's real business

This table has nothing to do with the company's actual products,
customers or sales — it's four rows I typed in myself as a setup
exercise. It proves the chain (Supabase → VS Code/SQLTools → GitHub)
works end to end. It says nothing about UrbanStyle.ltd's real
performance — that starts with the released `products`, `customers`
and `sales` tables in `week-1/`.
