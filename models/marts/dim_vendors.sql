with trips_unioned as (
    SELECT * from {{ ref('int_trips_unioned')}}
),

vendors as (
    SELECT
        distinct vendor_id,
        {{ get_vendor_names('vendor_id')}}
    from trips_unioned
)

SELECT * from vendors