import polars as pl

DB_URI = "postgresql://admin:example@127.0.0.1:5432/admin"

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


def write_csv_to_db(csv_loc: str, uri: str = DB_URI) -> None:
    """Write a csv to a db via `uri`."""
    df_csv = pl.read_csv(csv_loc, schema=CRIME_DATA_RAW_SCHEMA)
    df_csv.write_database(table_name="crime", connection=uri, if_table_exists="append")


if __name__ == "__main__":
    for year in range(2020, 2025):  # Did 2010 manually.
        print(f"Inserting {year} into table...")
        csv_loc = f"./data_monthly/{year}.csv"
        write_csv_to_db(csv_loc=csv_loc)

# TO DELETE DUPLICATES:
#
# DELETE
# FROM test
# WHERE ctid IN
# (
#     SELECT ctid
#     FROM(
#         SELECT
#             *,
#             ctid,
#             row_number() OVER (PARTITION BY crime_id ORDER BY ctid)
#         FROM admin.public.crime
#     ) s
#     WHERE row_number >= 2
# )
