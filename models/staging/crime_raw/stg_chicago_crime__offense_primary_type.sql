with source as (
    select *
    from {{ ref('chicago_offense_primary_type') }}
),
select
    offense_primary_type_id,
    offense_primary_type_name
from source
