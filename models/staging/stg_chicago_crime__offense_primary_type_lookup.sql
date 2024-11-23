with source as (
    select *
    from {{ source('crime_raw', "crime") }}
),
disinct_offense_primary_types as (
    select distinct primary_type as offense_primary_type
    from
        source
    where
        primary_type is not null
), row_numbers as (
    select
        row_number() over () as offense_primary_type_id,
        offense_primary_type
    from
        disinct_offense_primary_types
)

select
    offense_primary_type_id,
    offense_primary_type
from row_numbers
