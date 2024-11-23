{{ config(
    indexes=[
        {
            "columns": ["crime_id"],
            "unique": true,
            "type": "btree",
        }
    ]
) }}

with source as (
    select *
    from {{ ref('stg_chicago_crime__locations') }}
),
columns_selected as (
    select
        -- IDs
        crime_id,
        case_number,

        -- STRINGS
        location_description,

        -- NUMERICS
        police_beat,
        police_district,
        ward,
        community_area,

        -- FLOATS
        latitude,
        longitude

    from source
)
select * from columns_selected
