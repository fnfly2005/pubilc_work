/*仲裁事务表*/
select
	reject_no,
	status,
	create_time,
	arbitrate_time,
	assign_time
from
	ods.so_reject_issue
where
	(create_time>='-time1'
	and create_time<'-time2')
	or (arbitrate_time>='-time1'
	and arbitrate_time<'-time2')
	or (assign_time>='-time1'
	and assign_time<'-time2')
