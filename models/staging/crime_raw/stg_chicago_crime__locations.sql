{{ config(
    indexes=[
        {
            "columns": ["crime_id"],
            "unique": true,
            "type": "btree",
        }
    ]
) }}

select
    -- IDs
    base.crime_id,
    base.case_number,
    ld.location_description_id,
    ca.community_area_id,

    -- STRINGS
    base.neighborhood_block,

    -- NUMERICS
    base.police_beat,
    base.police_district,
    base.ward,

    -- FLOATS
    base.x_coordinate,
    base.y_coordinate,
    base.latitude,
    base.longitude,

    -- TIMESTAMPS
    base.occurred_on,
    base.updated_on

from {{ ref('base_chicago_crime__all') }} as base
left join
    {{ ref('base_chicago_crime__location_descriptions') }} as ld
    on base.location_description = ld.location_description_name
left join
    {{ ref('base_chicago_crime__community_areas') }} as ca
    on base.community_area = ca.community_area_name
