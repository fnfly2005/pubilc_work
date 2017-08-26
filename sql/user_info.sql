/*孕育用户信息表*/
select distinct
	enc_user_id babytree_enc_user_id,
	pregnancy_month,
	province_name,
	location location_id
from
	dw.user_info
where
	last_login_time>='-time1'
	and last_login_time<'-time2'
