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
        {{ adapter.quote("id") }} as crime_id,
        {{ adapter.quote("case_number") }} as case_number,

        -- TIMESTAMPS
        {{ adapter.quote("date") }}::timestamp as occurred_on,
        {{ adapter.quote("updated_on") }}::timestamp as updated_on,

        -- STRINGS
        {{ adapter.quote("iucr") }} as iucr_code,
        {{ adapter.quote("primary_type") }} as offense_primary_type,
        {{ adapter.quote("description") }} as offense_description,
        {{ adapter.quote("fbi_code") }} as fbi_code,

        -- BOOLEANS
        {{ adapter.quote("arrest") }} as is_arrested,
        {{ adapter.quote("domestic") }} as is_domestic
    from source
)
select * from renamed
