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
renamed as (
    select
        -- IDs
        id as crime_id,
        case_number,
        community_area as community_area_id,
        -- STRINGS
        block as neighborhood_block,
        iucr as iucr_code,
        fbi_code,
        primary_type as offense_primary_type,
        description as offense_description,
        location_description,
        beat as police_beat,
        district as police_district,
        ward,
        -- NUMERICS
        x_coordinate,
        y_coordinate,
        latitude,
        longitude,
        -- BOOLEANS
        arrest as is_arrested,
        domestic as is_domestic,
        -- TIMESTAMPS
        date as occurred_on,
        updated_on

    from source
),
cols_casted as (
    select
        crime_id::bigint as crime_id,
        community_area_id::bigint as community_area_id,
        case_number,
        neighborhood_block,
        iucr_code::text as iucr_code,
        fbi_code::text as fbi_code,
        offense_primary_type,
        offense_description,
        location_description,
        police_beat::text as police_beat,
        police_district::text as police_district,
        ward::text as ward,
        x_coordinate::bigint as x_coordinate,
        y_coordinate::bigint as y_coordinate,
        latitude,
        longitude,
        is_arrested,
        is_domestic,
        occurred_on::timestamp as occurred_on,
        updated_on::timestamp as updated_on
    from renamed
)
select * from cols_casted
