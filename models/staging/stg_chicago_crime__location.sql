with source as (
    select *
    from {{ ref('chicago_crime_seed') }}
),
renamed as (
    select
        -- IDs
        {{ adapter.quote("id") }} as crime_id,

        -- STRINGS
        {{ adapter.quote("block") }} as neighborhood_block,
        {{ adapter.quote("location_description") }} as location_description,
        {{ adapter.quote("beat") }} as police_beat,
        {{ adapter.quote("district") }} as police_district,
        {{ adapter.quote("ward") }} as ward,
        {{ adapter.quote("community_area") }} as community_area,

        -- FLOATS
        {{ adapter.quote("x_coordinate") }} as x_coordinate,
        {{ adapter.quote("y_coordinate") }} as y_coordinate,
        {{ adapter.quote("latitude") }} as latitude,
        {{ adapter.quote("longitude") }} as longitude

    from source
),
casted as (
    select
        * replace (
            police_beat::int as police_beat,
            police_district::int as police_district,
            ward::int as ward,
            community_area::int as community_area
        )
    from renamed
)
select * from casted
