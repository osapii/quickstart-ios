with add_date as (SELECT EXTRACT(DATE FROM timestamp at time zone "Asia/Tokyo") as date
,*
FROM `voicy_player_play.play_201902*`)

SELECT date
,platform
,count(distinct uuid) as dau
FROM add_date
GROUP BY date,platform
ORDER BY date