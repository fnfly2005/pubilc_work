/*sensitive聚说积分*/
select
	enc_user_id sensitive_enc_user_id,
	point
from
	ods.uc_point_info
where
	status=1
	and send_time>='-time1'
	and send_time<'-time2'
