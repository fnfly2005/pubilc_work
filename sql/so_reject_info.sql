/*退货单表*/
select
	reject_no,
	order_no,
	supplier_id,
	reject_status,
	audit_status,
	cs_audit_time,
	create_time
from
	ods.so_reject_info
where
	create_time>='-time1'
	and create_time<'-time2'
