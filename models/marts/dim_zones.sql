with taxi_zone_lookup as (
    SELECT * from {{ ref('taxi_zone_lookup')}}
),

rename as (
    SELECT
        LocationID as location_id,
        borough,
        zone,
        service_zone
        FROM taxi_zone_lookup
)


SELECT * from rename
--SELECT * from taxi_zone_lookup