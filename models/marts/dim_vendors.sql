with trips_unioned as (
    SELECT * from {{ ref('int_trips_unioned')}}
),

vendors as (
    SELECT
        distinct vendor_id
        case
            when vendor_id = 1 then 'Creative Modile Technologies, LLC'
            when vendor_id = 2 then 'VeriFone Inc'
            when vendor_id = 4 then 'Unknow Vendor'
        end as vendor_name
    from trips_unioned
)

SELECT * from vendors