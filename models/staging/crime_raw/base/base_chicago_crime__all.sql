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
renamed_and_casted as (
    select
        -- IDs
        id::bigint as crime_id,
        case_number,

        -- STRINGS
        block as neighborhood_block,
        iucr::text as iucr_code,
        fbi_code::text,
        primary_type as offense_primary_type,
        description as offense_description,
        location_description,
        beat::text as police_beat,
        district::text as police_district,
        ward::text,
        community_area::text,

        -- NUMERICS
        x_coordinate::bigint,
        y_coordinate::bigint,
        latitude,
        longitude,

        -- BOOLEANS
        arrest as is_arrested,
        domestic as is_domestic,

        -- TIMESTAMPS
        date::timestamp as occurred_on,
        updated_on::timestamp

    from source
)
select * from renamed_and_casted
