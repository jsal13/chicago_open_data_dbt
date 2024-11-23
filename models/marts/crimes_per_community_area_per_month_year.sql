with community_areas as (
    select
        crime_id,
        community_area_id
    from
        {{ ref('stg_chicago_crime__locations_normalized') }}
),
offenses_with_description as (
    select
        crime_id,
        offense_primary_type_id,
        offense_description_id,
        to_char(occurred_on, 'yyyy-mm') as year_month_occurred_on
    from
        {{ ref('int_chicago_crime__offense_information') }}
),
joined_offenses_and_community_areas as (
    select
        owd.*,
        ca.community_area_id
    from offenses_with_description as owd
    inner join community_areas as ca
        on owd.crime_id = ca.crime_id
),
grouped_by_area_and_year_month as (
    select
        year_month_occurred_on,
        community_area_id,
        offense_primary_type_id,
        offense_description_id,
        count(crime_id) as number_of_crimes
    from
        joined_offenses_and_community_areas
    group by
        1, 2, 3, 4
    order by
        1, 2, 3, 4
),
denormalized as (
    select
        gbaym.year_month_occurred_on,
        cadt.community_area_name,
        opt_lookup.offense_primary_type,
        od_lookup.offense_description,
        gbaym.number_of_crimes
    from

        grouped_by_area_and_year_month as gbaym
    left join
        {{ ref('stg_chicago_crime__offense_description_lookup') }} as od_lookup
        on gbaym.offense_description_id = od_lookup.offense_description_id
    left join
        {{ ref('stg_chicago_crime__offense_primary_type_lookup') }}
            as opt_lookup
        on gbaym.offense_primary_type_id = opt_lookup.offense_primary_type_id
    left join
        {{ ref('stg_chicago_crime__community_areas_dimension_tbl') }} as cadt
        on gbaym.community_area_id = cadt.community_area_id
)

select * from denormalized
