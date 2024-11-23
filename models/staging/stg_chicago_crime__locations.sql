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
        {{ adapter.quote("id") }} as crime_id,
        {{ adapter.quote("case_number") }} as case_number,

        -- STRINGS
        {{ adapter.quote("block") }} as neighborhood_block,
        {{ adapter.quote("location_description") }} as location_description,

        -- NUMERICS
        {{ adapter.quote("beat") }}::text as police_beat,
        {{ adapter.quote("district") }}::text as police_district,
        {{ adapter.quote("ward") }}::text as ward,
        {{ adapter.quote("community_area") }}::text as community_area,

        -- FLOATS
        {{ adapter.quote("x_coordinate") }} as x_coordinate,
        {{ adapter.quote("y_coordinate") }} as y_coordinate,
        {{ adapter.quote("latitude") }} as latitude,
        {{ adapter.quote("longitude") }} as longitude

    from source
)
select * from renamed_and_casted
