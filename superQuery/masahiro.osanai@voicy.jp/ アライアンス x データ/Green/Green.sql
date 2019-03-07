with green_row as (select distinct user_id
from `voicy_player_play.play_2019*` 
where media_name = "Green")

,unique_advertising_id as (select distinct user_property.key
,user_property.value.string_value as user_id
,device.operating_system
,device.advertising_id
from `analytics_151361240.events_*` 
,unnest(user_properties) as user_property
where user_property.key = "userId" )

select s.*
,t.operating_system
,t.advertising_id
from green_row as s
left join
unique_advertising_id as t
on
cast(s.user_id as string)  = t.user_id