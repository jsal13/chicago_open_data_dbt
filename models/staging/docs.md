{% !! TABLES !! %}

{% docs stg_chicago_crime__locations %}
This table holds information about the location of crimes.  It is indexed by `crime_id`.
{% enddocs %}

{% docs stg_chicago_crime__offense_information %}
This table holds information about the criminal offense.  It is indexed by `crime_id`.
{% enddocs %}

{% !! FIELDS !! %}

{% docs stg_chicago_crime__id %}
Unique identifier for the record in the Chicago Crime data.
{% enddocs %}

{% docs stg_chicago_crime__case_number %}
The Chicago Police Department RD Number (Records Division Number), which is unique to the incident.
{% enddocs %}

{% docs stg_chicago_crime__occurred_on %}
Date when the incident occurred. This is sometimes a best estimate.
{% enddocs %}

{% docs stg_chicago_crime__neighborhood_block %}
The partially redacted address where the incident occurred, placing it on the same block as the actual address.
{% enddocs %}

{% docs stg_chicago_crime__iucr_code %}
The Illinois Unifrom Crime Reporting code. This is directly linked to the Primary Type and Description. See the list of IUCR codes at <https://data.cityofchicago.org/d/c7ck-438e>.
{% enddocs %}

{% docs stg_chicago_crime__offense_primary_type %}
The primary description of the IUCR code.
{% enddocs %}

{% docs stg_chicago_crime__offense_description %}
The secondary description of the IUCR code, a subcategory of the primary description.
{% enddocs %}

{% docs stg_chicago_crime__location_description %}
Description of the location where the incident occurred.
{% enddocs %}

{% docs stg_chicago_crime__is_arrested %}
Indicates whether an arrest was made.
{% enddocs %}

{% docs stg_chicago_crime__is_domestic %}
Indicates whether the incident was domestic-related as defined by the Illinois Domestic Violence Act.
{% enddocs %}

{% docs stg_chicago_crime__police_beat %}
Indicates the beat where the incident occurred. A beat is the smallest police geographic area - each beat has a dedicated police beat car. Three to five beats make up a police sector, and three sectors make up a police district. The Chicago Police Department has 22 police districts.
See the beats at <https://data.cityofchicago.org/d/aerh-rz74>.
{% enddocs %}

{% docs stg_chicago_crime__police_district %}
Indicates the police district where the incident occurred. See the districts at <https://data.cityofchicago.org/d/fthy-xz3r>.
{% enddocs %}

{% docs stg_chicago_crime__ward %}
The ward (City Council district) where the incident occurred. See the wards at <https://data.cityofchicago.org/d/sp34-6z76>.
{% enddocs %}

{% docs stg_chicago_crime__community_area %}
Indicates the community area where the incident occurred. Chicago has 77 community areas.
See the community areas at <https://data.cityofchicago.org/d/cauq-8yn6>.
{% enddocs %}

{% docs stg_chicago_crime__fbi_code %}
Indicates the crime classification as outlined in the FBI's National Incident-Based Reporting System (NIBRS).See the Chicago Police Department listing of these classifications at <https://gis.chicagopolice.org/pages/crime_details>.
{% enddocs %}

{% docs stg_chicago_crime__x_coordinate %}
The x coordinate of the location where the incident occurred in State Plane Illinois East NAD 1983 projection. This location is shifted from the actual location for partial redaction but falls on the same block.
{% enddocs %}

{% docs stg_chicago_crime__y_coordinate %}
The y coordinate of the location where the incident occurred in State Plane Illinois East NAD 1983 projection. This location is shifted from the actual location for partial redaction but falls on the same block.
{% enddocs %}

{% docs stg_chicago_crime__year %}
Year the incident occurred.
{% enddocs %}

{% docs stg_chicago_crime__updated_on %}
Date and time the record was last updated.
{% enddocs %}

{% docs stg_chicago_crime__latitude %}
The latitude of the location where the incident occurred. This location is shifted from the actual location for partial redaction but falls on the same block.
{% enddocs %}

{% docs stg_chicago_crime__longitude %}
The longitude of the location where the incident occurred. This location is shifted from the actual location for partial redaction but falls on the same block.
{% enddocs %}
