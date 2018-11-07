/*帖子信息表*/
select
	response_id,
	user_id sensitive_user_id
from
	sensitive.discussionresponse
where
	dt>='-time1'
	and dt<'-time2'
