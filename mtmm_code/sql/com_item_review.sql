/*ods评论明细表,含图片*/
select
	has_img,
	id comment_id
from
	ods.com_item_review
where
	create_time>='-time1'
	and create_time<'-time2'
	and is_import=0
	and has_img in (0,1)
