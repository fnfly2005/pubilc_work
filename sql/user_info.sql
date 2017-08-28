/*孕育用户信息表*/
select distinct
	enc_user_id babytree_enc_user_id,
	case when substr(babybirthday,6,2)='00' then null
	else date_parse(substr(babybirthday,1,10),'%Y-%m-%d') end  babybirthday,
	province_name,
	location location_id
from
	dw.user_info
where
	last_login_time>='-time1'
	and last_login_time<'-time2'
