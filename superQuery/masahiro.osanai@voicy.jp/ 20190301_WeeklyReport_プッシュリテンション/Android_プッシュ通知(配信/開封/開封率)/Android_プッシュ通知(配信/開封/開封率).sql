with notification_receive as  (select event_date
,count(distinct user_pseudo_id) as push_receive_unique_uu
from `analytics_151361240.events_*` 
where platform = "ANDROID" and event_name = "notification_receive" and EXTRACT(DATE FROM TIMESTAMP_MICROS(event_timestamp)　AT TIME ZONE 'Asia/Tokyo') > "2019-01-31"
group by event_date)

,notification_open as  (select event_date
,count(distinct user_pseudo_id) as push_open_unique_uu
from `analytics_151361240.events_*` 
where platform = "ANDROID" and event_name = "notification_open"  and EXTRACT(DATE FROM TIMESTAMP_MICROS(event_timestamp)　AT TIME ZONE 'Asia/Tokyo') > "2019-01-31"
group by event_date)

select s.*
,t.push_open_unique_uu
,round(t.push_open_unique_uu/s.push_receive_unique_uu*100,1) as push_open_rate
from notification_receive as s
left join
notification_open as t
on
s.event_date = t.event_date