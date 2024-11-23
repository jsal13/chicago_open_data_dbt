with source as (
    select *
    from {{ ref('chicago_location_descriptions') }}
)

select
    location_description_id,
    location_description_name
from source
