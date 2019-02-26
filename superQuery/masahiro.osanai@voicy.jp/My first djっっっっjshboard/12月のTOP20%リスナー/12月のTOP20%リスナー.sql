-- 12月の再生時間TOP20リスナーID抽出
SELECT *
from
(select *
,round(playtime_rank/max(playtime_rank)over()*100,2) as rank_ratio_on_total
,max(playtime_rank)over() as max_rank
from 
(select uuid
,cast (sum(duration/1000/60) as int64) as total_play_minutes
,row_number() over (order by cast (sum(duration/1000/60) as int64)desc) as playtime_rank
from `voicy_player_play.play_201812*` 
where platform = "ios"
group by uuid) as s) as s
where rank_ratio_on_total <= 20