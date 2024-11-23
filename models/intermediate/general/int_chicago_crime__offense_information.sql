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
    from {{ ref('stg_chicago_crime__offense_information_normalized') }}
),
columns_selected as (
    select
        -- IDs
        crime_id,
        case_number,
        offense_primary_type_id,
        offense_description_id,

        -- TIMESTAMPS
        occurred_on,

        -- BOOLEANS
        is_arrested,
        is_domestic

    from source
)
select * from columns_selected
