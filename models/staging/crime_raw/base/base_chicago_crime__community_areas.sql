with source as (
    select *
    from {{ ref('chicago_community_areas') }}
)
select
    community_area_id,
    community_area_name,
    population_2020,
    area_sq_mi,
    density_per_sq_mi
from source
