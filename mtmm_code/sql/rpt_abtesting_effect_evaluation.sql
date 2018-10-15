/*ABtesting开讲*/
select
	exps_pv,
	exps_uv,
	click_pv
from
	rpt.rpt_abtesting_effect_evaluation
where
	date_id>='-time1'
	and date_id<'-time2'
