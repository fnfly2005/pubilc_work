select
	to_user_id meitun_user_id,
	enc_user_id babytree_enc_user_id,
	length(enc_user_id) type
from
	ods.coupon_user
where
	status=0
