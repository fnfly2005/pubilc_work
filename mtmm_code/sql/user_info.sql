/*孕育用户信息表*/
select
	enc_user_id sensitive_enc_user_id,
	date_parse(
			replace(
				replace(
					substr(babybirthday,1,13),
					'-00','-01'),
				' 00',' 01'),
			'%Y-%m-%d %H') babybirthday,
	/*处理1986至1991夏令时改时间问题*/
	province_name,
	location location_id
from
	dw.user_info
where
	last_login_time>='-time1'
	and last_login_time<'-time2'
