select
	sensitive_user_id,
	sensitive_enc_user_id,
	case when baby_birthday='null' then null
	else substr(baby_birthday,1,19) end baby_birthday
from
	dw.dim_user
where
	uid_valid_flag=1
	and sensitive_enc_user_id is not null
