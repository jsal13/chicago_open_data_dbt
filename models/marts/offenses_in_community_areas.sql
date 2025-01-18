select
    ocaj.*,
    opt.offense_primary_type_name,
    od.offense_description_name,
    ca.community_area_name
from
    {{ ref('int_offenses_and_community_areas_joined') }} as ocaj
    join {{ ref('base_chicago_crime__offense_primary_types') }} as opt on opt.offense_primary_type_id = ocaj.offense_primary_type_id
    join {{ ref('base_chicago_crime__offense_descriptions') }} as od on od.offense_description_id = ocaj.offense_description_id
    join {{ ref('base_chicago_crime__community_areas') }} as ca on ca.community_area_id = ocaj.community_area_id