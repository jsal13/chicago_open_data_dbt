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
    from {{ source('crime_raw', "crime") }}
),
joined_to_lookups as (
    select
        -- IDs
        source.id,
        source.case_number,
        ld.location_description_id,
        source.community_area,

        -- STRINGS
        source.block,

        -- NUMERICS
        source.beat,
        source.district,
        source.ward,

        -- FLOATS
        source.x_coordinate,
        source.y_coordinate,
        source.latitude,
        source.longitude

    from source
    left join
        {{ ref('stg_chicago_crime__location_description') }} as ld
        on source.description = ld.location_description_name
),
renamed_and_casted as (
    select
        -- IDs
        id as crime_id,
        case_number,
        location_description_id,
        community_area::integer as community_area_id,

        -- STRINGS
        block as neighborhood_block,

        -- NUMERICS
        beat::text as police_beat,
        district::text as police_district,
        ward::text,

        -- FLOATS
        x_coordinate,
        y_coordinate,
        latitude,
        longitude

    from joined_to_lookups
)
select * from renamed_and_casted
