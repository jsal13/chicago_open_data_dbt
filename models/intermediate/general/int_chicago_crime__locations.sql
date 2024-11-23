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
    from {{ ref('stg_chicago_crime__locations_normalized') }}
),
columns_selected as (
    select
        -- IDs
        crime_id,
        case_number,
        community_area_id,
        location_description_id,

        -- NUMERICS
        police_beat,
        police_district,
        ward

    from source
)
select * from columns_selected
