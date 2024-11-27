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
        opt.offense_primary_type_id,
        od.offense_description_id,

        -- TIMESTAMPS
        source.date,
        source.updated_on,

        -- STRINGS
        source.iucr,
        source.fbi_code,

        -- BOOLEANS
        source.arrest,
        source.domestic

    from source
    left join
        {{ ref('stg_chicago_crime__offense_description') }} as od
        on source.description = od.offense_description_name
    left join
        {{ ref('stg_chicago_crime__offense_primary_types') }}
            as opt
        on source.primary_type = opt.offense_primary_type_name
),
renamed_and_casted as (
    select
        -- IDs
        id as crime_id,
        case_number,
        offense_primary_type_id,
        offense_description_id,

        -- TIMESTAMPS
        date::timestamp as occurred_on,
        updated_on::timestamp,

        -- STRINGS
        iucr::text as iucr_code,
        fbi_code::text,

        -- BOOLEANS
        arrest as is_arrested,
        domestic as is_domestic
    from
        joined_to_lookups

)
select * from renamed_and_casted
