{{ config(
    indexes=[
        {
            "columns": ["crime_id"],
            "unique": true,
            "type": "btree",
        }
    ]
) }}
select * from {{ ref('stg_chicago_crime__offense_information') }}
