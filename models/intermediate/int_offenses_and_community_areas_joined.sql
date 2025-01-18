with community_areas as (
    select
        crime_id,
        community_area_id
    from
        {{ ref('stg_chicago_crime__locations') }}
),
offenses_with_description as (
    select
        crime_id,
        offense_primary_type_id,
        offense_description_id,
        occurred_on
    from
        {{ ref('stg_chicago_crime__offense_information') }}
),
joined_offenses_and_community_areas as (
    select
        owd.*,
        ca.community_area_id
    from offenses_with_description as owd
    inner join community_areas as ca
        on owd.crime_id = ca.crime_id
)
select * from joined_offenses_and_community_areas