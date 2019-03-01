with notification_receive as  (select event_date
,count(distinct user_pseudo_id) as push_receive_unique_uu
from `analytics_151361240.events_*` 
where platform = "ANDROID" and event_name = "notification_receive"
group by event_date)

,notification_open as  (select event_date
,count(distinct user_pseudo_id) as push_open_unique_uu
from `analytics_151361240.events_*` 
where platform = "ANDROID" and event_name = "notification_open"
group by event_date)

select s.*
,t.push_open_unique_uu
from notification_receive as s
left join
notification_open as t
on
s.event_date = t.event_date