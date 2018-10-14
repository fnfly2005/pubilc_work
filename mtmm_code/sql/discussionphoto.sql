/*回帖楼层图片表*/
select
	response_id,
	floor
from
	babytree.discussionphoto
where
	dt>='-time1'
	and dt<'-time2'
	and response_id>0
	and status=1
