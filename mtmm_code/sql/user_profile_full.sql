/*sensitive人群画像标签表*/
select distinct
	sensitive_user_id sensitive_enc_user_id,
	favor_province_name
from
	dw.user_profile_full
where
	browse_time>='-time1'
	and browse_time<'-time2'
