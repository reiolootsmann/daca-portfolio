"""
Week 8 - Role D: Automation Script
Combines Roles A, B, C into one orchestrated pipeline with logging and timing.
"""

import logging
import time
import os
from datetime import datetime

from data_fetcher import fetch_sales, fetch_customers, fetch_products
from transform import clean_data, calculate_weekly_aggregates, calculate_kpis, merge_datasets
from visualize_export import create_weekly_chart, create_kpi_summary, export_results, export_chart

os.makedirs('logs', exist_ok=True)
log_filename = f"logs/pipeline_{datetime.now().strftime('%Y%m%d')}.log"

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler(log_filename), logging.StreamHandler()]
)


def run_pipeline():
    """Orchestrates: fetch -> clean -> aggregate -> visualize -> export."""
    logging.info("Pipeline started")

    try:
        logging.info("Stage 1/3: Fetching data from Supabase")
        sales_df = fetch_sales()
        customers_df = fetch_customers()
        logging.info(f"Stage 1/3 complete: {len(sales_df)} sales rows, {len(customers_df)} customer rows")
    except Exception as e:
        logging.error(f"Stage 1/3 (Extract) failed: {e}")
        raise

    try:
        logging.info("Stage 2/3: Cleaning, aggregating, merging")
        sales_clean = clean_data(sales_df)
        weekly = calculate_weekly_aggregates(sales_clean)
        kpis = calculate_kpis(sales_clean)
        merged = merge_datasets(sales_clean, customers_df)
        logging.info(f"Stage 2/3 complete: {len(sales_clean)} rows cleaned, KPIs: {kpis}")
    except Exception as e:
        logging.error(f"Stage 2/3 (Transform) failed: {e}")
        raise

    try:
        logging.info("Stage 3/3: Building charts and exporting")
        weekly_fig = create_weekly_chart(weekly)
        kpi_fig = create_kpi_summary(kpis)
        csv_path = export_results(merged, output_dir='output')
        export_chart(weekly_fig, output_dir='output', filename='weekly_revenue.html')
        export_chart(kpi_fig, output_dir='output', filename='kpi_summary.html')
        logging.info(f"Stage 3/3 complete: results exported to {csv_path}")
    except Exception as e:
        logging.error(f"Stage 3/3 (Visualize/Export) failed: {e}")
        raise

    logging.info("Pipeline complete")
    return {'rows_processed': len(sales_clean), 'kpis': kpis, 'output_csv': csv_path}


if __name__ == '__main__':
    start_time = time.time()
    try:
        summary = run_pipeline()
        elapsed = time.time() - start_time
        print(f"\nPipeline finished successfully in {elapsed:.1f} seconds")
        print(f"Rows processed: {summary['rows_processed']}")
        print(f"KPIs: {summary['kpis']}")
    except Exception as e:
        elapsed = time.time() - start_time
        logging.error(f"Pipeline failed after {elapsed:.1f} seconds: {e}")
        print(f"\nPipeline FAILED after {elapsed:.1f} seconds — see logs/ for details")