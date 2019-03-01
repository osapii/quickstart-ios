with play_personality_list as (select user_pseudo_id
,EXTRACT(DATE FROM TIMESTAMP_MICROS(user_first_touch_timestamp)　AT TIME ZONE 'Asia/Tokyo') AS first_date
,EXTRACT(DATE FROM TIMESTAMP_MICROS(event_timestamp)　AT TIME ZONE 'Asia/Tokyo') AS event_date 
,date_diff(EXTRACT(DATE FROM TIMESTAMP_MICROS(event_timestamp)　AT TIME ZONE 'Asia/Tokyo'),EXTRACT(DATE FROM TIMESTAMP_MICROS(user_first_touch_timestamp)　AT TIME ZONE 'Asia/Tokyo'),DAY) as date_diff
from `analytics_151361240.events_*`
where device.operating_system = "IOS" 
)

select first_date
,count(distinct user_pseudo_id) as dl_uu
,avg(day1) as d1_rate
,avg(day3) as d3_rate
,avg(day7) as d7_rate
from
(select user_pseudo_id
,first_date
,case when sum(case when date_diff = 1 then 1 else 0 end) > 0 then 1 else 0 end as day1
,case when sum(case when date_diff = 3 then 1 else 0 end) > 0 then 1 else 0 end as day3
,case when sum(case when date_diff = 7 then 1 else 0 end) > 0 then 1 else 0 end as day7
from play_personality_list 
group by user_pseudo_id,first_date
order by day1 desc) as s
group by first_date
order by first_date