import os
import logging
import glob
from pathlib import Path

import polars as pl

DATA_DIR = "data"
OUTPUT_DATA_DIR = "data_monthly"
CRIME_DATA_RAW_SCHEMA: pl.Schema = pl.Schema(
    schema={
        "id": pl.UInt64(),
        "date": pl.String(),  # Converts later.
        "case_number": pl.String(),
        "block": pl.String(),
        "iucr": pl.String(),
        "primary_type": pl.String(),
        "description": pl.String(),
        "location_description": pl.String(),
        "arrest": pl.Boolean(),
        "domestic": pl.Boolean(),
        "beat": pl.String(),
        "district": pl.String(),
        "ward": pl.UInt32(),
        "community_area": pl.String(),
        "fbi_code": pl.String(),
        "x_coordinate": pl.Float32(),
        "y_coordinate": pl.Float32(),
        "year": pl.UInt16(),
        "updated_on": pl.String(),  # Converts later.
        "latitude": pl.Float32(),
        "longitude": pl.Float32(),
    }
)

logger = logging.getLogger(__name__)
logger.setLevel(level=logging.INFO)


def _get_file_list_for_year_month(year: int, month: int) -> list[str]:
    return glob.glob(
        pathname=os.path.join(DATA_DIR, f"year={year}", f"month={month}", "*.csv")
    )


def _get_file_list_for_year(year: int) -> list[str]:
    return glob.glob(pathname=os.path.join(DATA_DIR, f"year={year}", "**", "*.csv"))


def _get_file_list() -> list[str]:
    return glob.glob(pathname=os.path.join(DATA_DIR, "**", "**", "*.csv"))


def _create_data_folder(path: str) -> None:
    """Creates a partition folder."""
    Path(path).mkdir(parents=True, exist_ok=True)


def concat_month(year: int, month: int, output: str = OUTPUT_DATA_DIR) -> None:
    """Concat a month of csv data and output as a CSV to `output`."""

    files = _get_file_list_for_year_month(year=year, month=month)
    dataframes: list[pl.DataFrame] = []

    for file in files:
        logger.info(f"Reading {file}...")
        raw_df: pl.DataFrame = pl.read_csv(
            file, schema=CRIME_DATA_RAW_SCHEMA, infer_schema=False, has_header=True
        )
        raw_df = raw_df.with_columns(
            pl.col("date")
            .str.strptime(pl.Datetime(), "%Y-%m-%dT%H:%M:%S.000")
            .dt.strftime("%Y-%m-%d %H:%M:%S")
        )
        raw_df = raw_df.with_columns(
            pl.col("updated_on")
            .str.strptime(pl.Datetime(), "%Y-%m-%dT%H:%M:%S.000")
            .dt.strftime("%Y-%m-%d %H:%M:%S")
        )

        dataframes.append(raw_df)

    df_concat: pl.DataFrame = pl.concat(dataframes, how="vertical_relaxed")

    df_concat.write_csv(file=os.path.join(output, f"{year}-{month:>02}.csv"))


def concat_year(year: int, output: str = OUTPUT_DATA_DIR) -> None:
    """Concat a year of csv data and output as a CSV to `output`."""

    files = _get_file_list_for_year(year=year)
    dataframes: list[pl.DataFrame] = []

    for file in files:
        logger.info(f"Reading {file}...")
        raw_df: pl.DataFrame = pl.read_csv(
            file, schema=CRIME_DATA_RAW_SCHEMA, infer_schema=False, has_header=True
        )
        raw_df = raw_df.with_columns(
            pl.col("date")
            .str.strptime(pl.Datetime(), "%Y-%m-%dT%H:%M:%S.000")
            .dt.strftime("%Y-%m-%d %H:%M:%S")
        )
        raw_df = raw_df.with_columns(
            pl.col("updated_on")
            .str.strptime(pl.Datetime(), "%Y-%m-%dT%H:%M:%S.000")
            .dt.strftime("%Y-%m-%d %H:%M:%S")
        )

        dataframes.append(raw_df)

    df_concat: pl.DataFrame = pl.concat(dataframes, how="vertical_relaxed")

    _create_data_folder(output)
    df_concat.write_csv(file=os.path.join(output, f"{year}.csv"))


if __name__ == "__main__":
    # concat_month(2010, 1)
    for i in range(2010, 2025):
        concat_year(i)
