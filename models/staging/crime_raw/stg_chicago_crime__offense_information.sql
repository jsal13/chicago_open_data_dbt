{{ config(
    indexes=[
        {
            "columns": ["crime_id"],
            "unique": true,
            "type": "btree",
        }
    ]
) }}

select
    -- IDs
    base.crime_id,
    base.case_number,
    opt.offense_primary_type_id,
    od.offense_description_id,

    -- TIMESTAMPS
    base.occurred_on,
    base.updated_on,

    -- STRINGS
    base.iucr_code,
    base.fbi_code,

    -- BOOLEANS
    base.is_arrested,
    base.is_domestic

from {{ ref('base_chicago_crime__all') }} as base
left join
    {{ ref('base_chicago_crime__offense_description') }} as od
    on base.offense_description = od.offense_description_name
left join
    {{ ref('base_chicago_crime__offense_primary_types') }} as opt
    on base.offense_primary_type = opt.offense_primary_type_name
