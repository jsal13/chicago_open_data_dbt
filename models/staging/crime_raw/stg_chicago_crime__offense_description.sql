with source as (
    select *
    from {{ source('crime_raw', "crime") }}
),
disinct_offense_descriptions as (
    select distinct description as offense_description
    from
        source
    where
        description is not null
), row_numbers as (
    select
        row_number() over () as offense_description_id,
        offense_description
    from
        disinct_offense_descriptions
)

select
    offense_description_id,
    offense_description
from row_numbers
