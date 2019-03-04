with total_broad_listeners as (SELECT speaker_id
,playlist_id
,count(distinct uuid) as unique_uu
,min(timestamp) as first_timestamp
FROM `voicy_player_play.play_*`
GROUP BY speaker_id,playlist_id)

,filter_newly_five as (
SELECT *
,ROW_NUMBER() over (partition by speaker_id order by first_timestamp) as rank
FROM total_brand_listners
)

SELECT *
FROM filter_newly_five
WHERE rank < 6