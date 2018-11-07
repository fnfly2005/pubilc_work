/*社区品牌对照表*/
select 
	id,
	adv_brand_name,
	sensitive_brand_name
from
	dm_sword.sword_imp_hard_adv_brand_mt_relation
where
	sensitive_brand_name not like '%测试%'
	and sensitive_brand_name not like '%test%'
	and sensitive_brand_name not like '%Test%'
