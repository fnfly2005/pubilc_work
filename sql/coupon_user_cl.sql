/*优惠券Uid清洗*/
select
	babytree_enc_user_id
from
	cu
where
	type>0
union
select
	du.babytree_enc_user_id
from
	cu
	join du on cu.meitun_user_id=du.meitun_user_id and cu.type=0
