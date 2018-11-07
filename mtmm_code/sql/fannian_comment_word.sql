select
	comment_id,
	key
from
	sensitive_tmp.fannian_comment_word
where
	comment_id is not null
	and length(key)>0
