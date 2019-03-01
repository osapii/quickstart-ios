WITH
`add_date` AS (
	SELECT EXTRACT(DATE FROM timestamp at time zone 'Asia/Tokyo') AS date, *
	FROM `voicy_player_play.play_201902*`
	WHERE platform = "ios"
)
SELECT date, platform, COUNT(distinct uuid) AS dau
FROM `add_date`
GROUP BY date, platform
ORDER BY date