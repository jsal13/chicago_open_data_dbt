{{ config(
    indexes=[
        {
            "columns": ["offense_primary_type_id"],
            "unique": true,
            "type": "btree",
        }
    ]
) }}
with source as (
    select *
    from {{ ref('chicago_offense_primary_types') }}
)
select
    offense_primary_type_id,
    offense_primary_type_name
from source
