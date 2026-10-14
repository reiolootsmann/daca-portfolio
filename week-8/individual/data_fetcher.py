"""
Week 8 - Role A: API Query
Fetches sales, customer and product data from UrbanStyle.ltd's Supabase API.
"""

import os
import time
import pandas as pd
from dotenv import load_dotenv
from supabase import create_client, Client

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

PAGE_SIZE = 1000  # Supabase caps each response at 1000 rows


def _fetch_paginated(table_name, filters=None, max_retries=3):
    """
    Fetch all rows from a Supabase table, handling pagination
    and retrying on failure with exponential backoff.
    filters: optional function that applies .gte()/.lte() etc. to a query.
    """
    all_rows = []
    start = 0

    while True:
        for attempt in range(max_retries):
            try:
                query = supabase.table(table_name).select("*")
                if filters:
                    query = filters(query)
                response = query.range(start, start + PAGE_SIZE - 1).execute()
                break
            except Exception as e:
                wait_time = 2 ** attempt
                print(f"  Attempt {attempt + 1} failed for '{table_name}': {e}")
                if attempt < max_retries - 1:
                    print(f"  Retrying in {wait_time}s...")
                    time.sleep(wait_time)
                else:
                    raise

        page = response.data
        if not page:
            break
        all_rows.extend(page)
        if len(page) < PAGE_SIZE:
            break
        start += PAGE_SIZE

    return pd.DataFrame(all_rows)


def fetch_sales(start_date=None, end_date=None):
    """Fetch sales data, optionally filtered by date range (e.g. '2026-01-01')."""
    try:
        def apply_filters(query):
            if start_date:
                query = query.gte("sale_date", start_date)
            if end_date:
                query = query.lte("sale_date", end_date)
            return query

        has_filters = start_date or end_date
        return _fetch_paginated("sales", filters=apply_filters if has_filters else None)
    except Exception as e:
        print(f"ERROR fetching sales data: {e}")
        return pd.DataFrame()


def fetch_customers():
    """Fetch all customer data."""
    try:
        return _fetch_paginated("customers")
    except Exception as e:
        print(f"ERROR fetching customer data: {e}")
        return pd.DataFrame()


def fetch_products():
    """Fetch all product data."""
    try:
        return _fetch_paginated("products")
    except Exception as e:
        print(f"ERROR fetching product data: {e}")
        return pd.DataFrame()


if __name__ == "__main__":
    print("Fetching sales...")
    sales_df = fetch_sales()
    print(f"  {len(sales_df)} rows")
    print(sales_df.head())

    print("\nFetching customers...")
    customers_df = fetch_customers()
    print(f"  {len(customers_df)} rows")
    print(customers_df.head())

    print("\nFetching products...")
    products_df = fetch_products()
    print(f"  {len(products_df)} rows")
    print(products_df.head())