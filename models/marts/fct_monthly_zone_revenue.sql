with trips as (
    SELECT * FROM {{ ref('fct_trips') }}
),

dim_zones as (
    SELECT * FROM {{ ref('dim_zones') }}
)

SELECT
    -- zone info
    pickup_location_id,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    dropoff_location_id,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,

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
LEFT JOIN dim_zones as dropoff_zone
    ON trips.dropoff_location_id = dropoff_zone.location_id

GROUP BY 1, 2, 3, 4, 5, 6, 7