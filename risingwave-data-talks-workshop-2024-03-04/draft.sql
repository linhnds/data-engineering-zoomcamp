CREATE MATERIALIZED VIEW zone_trip_time as
    with trip_time as (
        select
            pulocationid, dolocationid,
            max(tpep_dropoff_datetime - tpep_pickup_datetime) max_trip_time,
            min(tpep_dropoff_datetime - tpep_pickup_datetime) min_trip_time,
            avg(tpep_dropoff_datetime - tpep_pickup_datetime) avg_trip_time
        FROM trip_data
        group by pulocationid, dolocationid)
    SELECT
        p.zone pu_zone,
        d.zone do_zone,
        t.max_trip_time, t.min_trip_time, t.avg_trip_time
    from trip_time t
    join taxi_zone p
        on t.pulocationid = p.location_id
    join taxi_zone d
        on t.dolocationid = d.location_id;

select *
from zone_trip_time
order by avg_trip_time desc;