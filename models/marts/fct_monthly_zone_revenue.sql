with trips as (
    SELECT * FROM {{ ref('fct_trips') }}
),

dim_zones as (
    SELECT * FROM {{ ref('dim_zones') }}
)

SELECT
    -- zone info
    pickup_location_id,
    pickup_zone.zone as pickup_zone,

    service_type,
    -- monthly
    DATE_TRUNC(pickup_datetime, MONTH) as revenue_month,

    -- revenue
    COUNT(trip_id) as total_trips,
    SUM(fare_amount) as total_fare,
    SUM(extra) as total_extra,
    SUM(mta_tax) as total_mta_tax,
    SUM(tip_amount) as total_tip,
    SUM(tolls_amount) as total_tolls,
    SUM(improvement_surcharge) as total_improvement_surcharge,
    SUM(total_amount) as total_revenue

FROM trips
LEFT JOIN dim_zones as pickup_zone
    ON trips.pickup_location_id = pickup_zone.location_id

GROUP BY pickup_location_id, pickup_zone, service_type, revenue_month