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
joined_to_lookups as (
    select
        -- IDs
        source.crime_id,
        source.case_number,
        ld_lookup.location_description_id,

        -- STRINGS
        source.neighborhood_block,

        -- NUMERICS
        source.police_beat,
        source.police_district,
        source.ward,
        source.community_area,

        -- FLOATS
        source.x_coordinate,
        source.y_coordinate,
        source.latitude,
        source.longitude

    from source
    left join
        {{ ref('stg_chicago_crime__location_description_lookup') }} as ld_lookup
        on source.location_description = ld_lookup.location_description
)
select * from joined_to_lookups
