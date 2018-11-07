/*优惠券Uid清洗*/
select
	sensitive_enc_user_id
from
	cu
where
	type>0
union
select
	du.sensitive_enc_user_id
from
	cu
	join du on cu.sensitive_user_id=du.sensitive_user_id and cu.type=0
