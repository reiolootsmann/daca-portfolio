"""
Week 8 - Role C: Visualization + Saving
Creates Plotly charts from processed data and exports results to CSV/HTML.
"""

import os
import logging
from datetime import datetime
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go


def create_weekly_chart(df_weekly):
    """Plotly line chart of weekly revenue trend."""
    logging.info("create_weekly_chart: building chart")
    fig = px.line(
        df_weekly,
        x='week',
        y='revenue',
        markers=True,
        title='UrbanStyle: Weekly Revenue Trend',
        labels={'week': 'Week', 'revenue': 'Revenue (EUR)'}
    )
    fig.update_traces(line=dict(width=2))
    return fig


def create_kpi_summary(kpis):
    """Plotly indicator cards showing the key KPIs."""
    logging.info("create_kpi_summary: building KPI summary")
    fig = go.Figure()
    fig.add_trace(go.Indicator(
        mode='number', value=kpis.get('total_revenue', 0),
        number={'prefix': '€', 'valueformat': ',.0f'},
        title={'text': 'Total Revenue'}, domain={'row': 0, 'column': 0}
    ))
    fig.add_trace(go.Indicator(
        mode='number', value=kpis.get('unique_customers', 0),
        title={'text': 'Unique Customers'}, domain={'row': 0, 'column': 1}
    ))
    fig.add_trace(go.Indicator(
        mode='number', value=kpis.get('avg_order_value', 0),
        number={'prefix': '€', 'valueformat': ',.2f'},
        title={'text': 'Avg Order Value'}, domain={'row': 0, 'column': 2}
    ))
    fig.update_layout(
        grid={'rows': 1, 'columns': 3, 'pattern': 'independent'},
        title='UrbanStyle: KPI Summary'
    )
    return fig


def export_results(df, output_dir='output'):
    """Save a DataFrame to a timestamped CSV file inside output_dir."""
    os.makedirs(output_dir, exist_ok=True)
    date_str = datetime.now().strftime('%Y%m%d')
    csv_path = os.path.join(output_dir, f'results_{date_str}.csv')
    df.to_csv(csv_path, index=False)
    logging.info(f"export_results: saved {len(df)} rows to {csv_path}")
    return csv_path


def export_chart(fig, output_dir='output', filename='chart.html'):
    """Save a Plotly figure as an HTML file inside output_dir."""
    os.makedirs(output_dir, exist_ok=True)
    chart_path = os.path.join(output_dir, filename)
    fig.write_html(chart_path)
    logging.info(f"export_chart: saved chart to {chart_path}")
    return chart_path


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    sample_weekly = pd.DataFrame({
        'week': pd.date_range('2026-01-04', periods=6, freq='W'),
        'revenue': [12000, 15500, 9800, 17200, 14100, 16300],
        'orders': [120, 140, 95, 160, 130, 150],
        'avg_order_value': [100, 110.7, 103.2, 107.5, 108.5, 108.7],
    })
    sample_kpis = {'total_revenue': 84900, 'unique_customers': 540, 'avg_order_value': 108.0}

    weekly_fig = create_weekly_chart(sample_weekly)
    kpi_fig = create_kpi_summary(sample_kpis)

    export_results(sample_weekly, output_dir='output')
    export_chart(weekly_fig, output_dir='output', filename='weekly_revenue.html')
    export_chart(kpi_fig, output_dir='output', filename='kpi_summary.html')

    print("Done. Check the output/ folder for the CSV and HTML files.")