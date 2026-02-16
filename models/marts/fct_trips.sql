-- with taxi_zone as (
--     SELECT * from {{ ref('dim_zones')}}
-- ),

-- with trips_unioned as (
--     SELECT * from {{ ref('int_trips_unioned')}}
-- ),

-- trips as (
--     SELECT

--         vendor_id ||'-'|| ratecode_id ||'-'||
--         UNIX_SECONDS(pickup_datetime) ||'-'|| 
--         UNIX_SECONDS(dropoff_datetime)||'-'||
--         total_amount||'-'||
--         trip_distance  AS trip_id,

--         vendor_id,
--         ratecode_id,
--         pickup_location_id,
--         dropoff_location_id,
--         pickup_datetime,
--         dropoff_datetime,
--         passenger_count,
--         trip_distance,
--         trip_type,
--         fare_amount,
--         extra,
--         mta_tax,
--         tip_amount,
--         tolls_amount,
--         improvement_surcharge,
--         total_amount,
--         payment_type
--     from trips_unioned
-- )

-- SELECT COUNT(*) as total_doublons
-- FROM (
--     SELECT trip_id, COUNT(*) as cnt
--     from trips 
--     GROUP BY trip_id
--     HAVING COUNT(*)>1
-- )

with trips_unioned as (
    SELECT * FROM {{ ref('int_trips_unioned') }}
),

trips as (
    SELECT
        vendor_id || '-' || ratecode_id || '-' ||
        UNIX_SECONDS(pickup_datetime) || '-' ||
        UNIX_SECONDS(dropoff_datetime) || '-' ||
        trip_distance || '-' ||
        total_amount AS trip_id,

        vendor_id,
        ratecode_id,
        pickup_location_id,
        dropoff_location_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        trip_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        payment_type,
        service_type,
        ROW_NUMBER() OVER(PARTITION BY 
            vendor_id || '-' || ratecode_id || '-' ||
            UNIX_SECONDS(pickup_datetime) || '-' ||
            UNIX_SECONDS(dropoff_datetime) || '-' ||
            trip_distance || '-' ||
            total_amount
        ORDER BY pickup_datetime) as row_num
    FROM trips_unioned
),

no_dupli_trips as (
    SELECT * FROM trips
    WHERE row_num = 1
)

SELECT * FROM no_dupli_trips