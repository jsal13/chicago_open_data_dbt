with source as (
    select *
    from {{ source('crime_raw', "crime") }}
),
disinct_descriptions as (
    select distinct location_description
    from
        source
    where
        location_description is not null
), row_numbers as (
    select
        row_number() over () as location_description_id,
        location_description
    from
        disinct_descriptions
)

select
    location_description_id,
    location_description
from row_numbers
