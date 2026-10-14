"""
Week 8 - Role B: Data Processing
Cleans, aggregates, and merges UrbanStyle.ltd's sales/customer data.
"""

import logging
import pandas as pd


def clean_data(df):
    """
    Remove duplicate invoices, drop rows missing key values,
    convert sale_date to datetime, and filter out invalid amounts.
    """
    logging.info(f"clean_data: starting with {len(df)} rows")
    df_clean = df.copy()

    before = len(df_clean)
    if 'invoice_id' in df_clean.columns:
        df_clean = df_clean.drop_duplicates(subset=['invoice_id'])
    else:
        df_clean = df_clean.drop_duplicates()
    logging.info(f"clean_data: removed {before - len(df_clean)} duplicate rows")

    key_columns = [c for c in ['customer_id', 'sale_date', 'total_price'] if c in df_clean.columns]
    before = len(df_clean)
    if key_columns:
        df_clean = df_clean.dropna(subset=key_columns)
    logging.info(f"clean_data: dropped {before - len(df_clean)} rows with missing key values")

    if 'sale_date' in df_clean.columns:
        df_clean['sale_date'] = pd.to_datetime(df_clean['sale_date'])

    # Advanced: basic validation - flag/drop non-positive amounts
    if 'total_price' in df_clean.columns:
        invalid = (df_clean['total_price'] <= 0).sum()
        if invalid > 0:
            logging.warning(f"clean_data: {invalid} rows have non-positive total_price, dropping them")
            df_clean = df_clean[df_clean['total_price'] > 0]

    logging.info(f"clean_data: finished with {len(df_clean)} rows")
    return df_clean


def calculate_weekly_aggregates(df):
    """Group sales by week and calculate revenue, order count, and avg order value."""
    logging.info("calculate_weekly_aggregates: starting")
    df = df.copy()
    df['sale_date'] = pd.to_datetime(df['sale_date'])

    weekly = (
        df.resample('W', on='sale_date')
          .agg(revenue=('total_price', 'sum'),
               orders=('sale_id', 'count'),
               avg_order_value=('total_price', 'mean'))
          .reset_index()
          .rename(columns={'sale_date': 'week'})
    )
    logging.info(f"calculate_weekly_aggregates: produced {len(weekly)} weekly rows")
    return weekly


def calculate_kpis(df):
    """Return a dict of headline KPIs: total revenue, unique customers, avg order value."""
    logging.info("calculate_kpis: starting")
    kpis = {
        'total_revenue': round(df['total_price'].sum(), 2),
        'unique_customers': df['customer_id'].nunique(),
        'avg_order_value': round(df['total_price'].mean(), 2),
        'total_orders': len(df),
    }
    logging.info(f"calculate_kpis: {kpis}")
    return kpis


def merge_datasets(df_sales, df_customers):
    """Merge sales and customer data on customer_id."""
    logging.info("merge_datasets: starting")
    merged = pd.merge(df_sales, df_customers, on='customer_id', how='left')
    logging.info(f"merge_datasets: produced {len(merged)} rows after merge")
    return merged


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    # Sample data for standalone testing (includes a duplicate, a missing date,
    # and a negative amount, to prove the cleaning logic actually works)
    sample_sales = pd.DataFrame({
        'sale_id': [1, 2, 2, 3, 4],
        'invoice_id': ['INV-001', 'INV-002', 'INV-002', 'INV-003', 'INV-004'],
        'sale_date': ['2026-01-05', '2026-01-06', '2026-01-06', '2026-01-12', None],
        'customer_id': [101, 102, 102, 103, 104],
        'total_price': [49.99, 89.50, 89.50, -5.00, 120.00],
    })
    sample_customers = pd.DataFrame({
        'customer_id': [101, 102, 103, 104],
        'first_name': ['Anna', 'Peeter', 'Liisa', 'Jaan'],
        'city': ['Tallinn', 'Tartu', 'Pärnu', 'Tallinn'],
    })

    print("Testing clean_data()...")
    cleaned = clean_data(sample_sales)
    print(cleaned)

    print("\nTesting calculate_weekly_aggregates()...")
    print(calculate_weekly_aggregates(cleaned))

    print("\nTesting calculate_kpis()...")
    print(calculate_kpis(cleaned))

    print("\nTesting merge_datasets()...")
    print(merge_datasets(cleaned, sample_customers))