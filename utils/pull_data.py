import os
import calendar
import logging

import pandas as pd
from sodapy import Socrata  # noqa
from dotenv import load_dotenv
from pathlib import Path

load_dotenv()  # take environment variables from .env.

SOCRATA_API_TOKEN = os.getenv("SOCRATA_API_ID")
SOCRATA_API_SECRET = os.getenv("SOCRATA_API_SECRET")

CRIME_ENDPOINT = "https://data.cityofchicago.org/resource/"
SOCRATA_CRIME_DATASET_ID = "ijzp-q8t2"
# Unauthenticated client only works with public data sets. Note 'None'
# in place of application token, and no username or password:

COLUMNS = (
    "id",
    "date",
    "case_number",
    "block",
    "iucr",
    "primary_type",
    "description",
    "location_description",
    "arrest",
    "domestic",
    "beat",
    "district",
    "ward",
    "community_area",
    "fbi_code",
    "x_coordinate",
    "y_coordinate",
    "year",
    "updated_on",
    "latitude",
    "longitude",
)

DATA_DIR = "data"

logger = logging.getLogger(__name__)
logger.setLevel(level=logging.INFO)


def _generate_get_data_query(date_min: str, date_max: str) -> str:
    """Generate a query to get data from the db after `date_min`."""
    return f"""
    SELECT 
        {",".join(COLUMNS)}
    WHERE 
        Date >= '{date_min}' and Date <= '{date_max}'
    LIMIT 20000
    """


def query_by_ymd(year: int = 2024, month=1, day=1) -> str:
    """Save the results of the query for the desired month-year-day."""
    date_min: str = f"{year}-{month:0>2}-{day:0>2}T00:00:00"
    date_max: str = f"{year}-{month:0>2}-{day:0>2}T23:59:59"
    return _generate_get_data_query(date_min=date_min, date_max=date_max)


def run_query(query: str) -> pd.DataFrame:
    """Run query against crime DB, return DataFrame CSV."""
    with Socrata("data.cityofchicago.org", SOCRATA_API_TOKEN) as client:
        response = client.get("ijzp-q8t2", query=query, content_type="csv")
        return pd.DataFrame(response[1:], columns=response[0])


def save_results(
    results: pd.DataFrame, file_name: str, location: str = DATA_DIR
) -> None:
    """Save results from query."""
    results.to_csv(os.path.join(location, file_name), index=False)


if __name__ == "__main__":
    import time

    def _create_partition_folder(path: str) -> None:
        """Creates a partition folder."""
        Path(path).mkdir(parents=True, exist_ok=True)

    def get_last_date_of_month(year: int, month: int) -> int:
        """Gets last day of year-month as an int."""
        return calendar.monthrange(year, month)[1]

    for year in range(2020, 2025):
        # Create partition folder for year.
        current_year_folder: str = os.path.join(DATA_DIR, f"year={year}")
        _create_partition_folder(current_year_folder)

        logger.info(f"Requesting data for year={year}...")

        for month in range(1, 12):

            # Create partition folder for month.
            current_month_folder: str = os.path.join(
                current_year_folder, f"month={month}"
            )
            _create_partition_folder(current_month_folder)

            for day in range(1, get_last_date_of_month(year=year, month=month) + 1):

                query: str = query_by_ymd(year, month, day)
                results = run_query(query=query)
                save_results(
                    results=results,
                    file_name=f"{year}-{month:0>2}-{day:0>2}.csv",
                    location=current_month_folder,
                )
        time.sleep(2)
