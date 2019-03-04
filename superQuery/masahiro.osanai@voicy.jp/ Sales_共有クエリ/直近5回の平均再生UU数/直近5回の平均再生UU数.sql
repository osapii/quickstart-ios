with total_broad_listeners as (SELECT speaker_id
,playlist_id
,count(distinct uuid) as unique_uu
,min(timestamp) as first_timestamp
FROM `voicy_player_play.play_*`
GROUP BY speaker_id,playlist_id)

,filter_newly_five as (
SELECT *
,ROW_NUMBER() over (partition by speaker_id order by first_timestamp desc) as rank
FROM total_broad_listeners
)

,result as (SELECT s.*
,t.name as speaker_name
,cast(avg(s.unique_uu) over (partition by s.speaker_id) as int64) as five_days_avg_b_listener
FROM 
(SELECT *
FROM filter_newly_five
WHERE rank < 6) as s
LEFT JOIN
voicy_rds.t_speaker as t
on
s.speaker_id = t.id)

select speaker_name
,max(five_days_avg_b_listener) as five_days_avg_b_listener
from result
group by speaker_name
order by five_days_avg_b_listener desc