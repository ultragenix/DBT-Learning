WITH green_tripdata as (
    SELECT * FROM {{ ref('stg_green_tripdata')}}
),

yellow_tripdata as (
    SELECT * FROM {{ ref('stg_yellow_tripdata')}}
),

trips_unioned as (
    SELECT * FROM green_tripdata
    UNION all
    SELECT * from yellow_tripdata
)

SELECT distinct pickup_location_id FROM trips_unioned