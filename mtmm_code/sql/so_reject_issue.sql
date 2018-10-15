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
	arbitrate_time>='-time1'
	and arbitrate_time<'-time2'
