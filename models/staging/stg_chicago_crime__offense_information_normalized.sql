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
    from {{ ref('stg_chicago_crime__offense_information') }}
),
joined_to_lookups as (
    select
        -- IDs
        source.crime_id,
        source.case_number,
        optl.offense_primary_type_id,
        odl.offense_description_id,

        -- TIMESTAMPS
        source.occurred_on,
        source.updated_on,

        -- STRINGS
        source.iucr_code,
        source.fbi_code,

        -- BOOLEANS
        source.is_arrested,
        source.is_domestic

    from source
    left join
        {{ ref('stg_chicago_crime__offense_description_lookup') }} as odl_lookup
        on source.offense_description = odl_lookup.offense_description
    left join
        {{ ref('stg_chicago_crime__offense_primary_type_lookup') }} as optl
        on source.offense_primary_type = odl_lookup.offense_primary_type
)
select * from joined_to_lookups
