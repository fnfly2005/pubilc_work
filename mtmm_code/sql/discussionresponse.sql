/*帖子信息表*/
select
	response_id,
	user_id babytree_user_id
from
	babytree.discussionresponse
where
	dt>='-time1'
	and dt<'-time2'
