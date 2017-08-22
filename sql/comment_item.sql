select
	dt,
	comment_id,
	supplier_id,
	babytree_enc_user_id,
	sku_id,
	mark,
	service_mark,
	transport_mark,
	content
from
	dw.comment_item
where
	dt>='-time1'
	and dt<'-time2'
	and import_flag=0
