{{ config(
    indexes=[
        {
            "columns": ["offense_description_id"],
            "unique": true,
            "type": "btree",
        }
    ]
) }}
with source as (
    select *
    from {{ ref('chicago_offense_descriptions') }}
)
select
    offense_description_id,
    offense_description_name
from source
