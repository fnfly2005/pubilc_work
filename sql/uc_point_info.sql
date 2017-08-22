/*美囤聚说积分*/
select
	enc_user_id babytree_enc_user_id,
	point
from
	ods.uc_point_info
where
	status=1
