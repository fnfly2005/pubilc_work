select
	date_id,
	case stat_type
		when -99 then '大健康汇总'
		when 1 then '开讲'
		when 2 then '专家答'
		when 3 then '快问医生'
	end stat_type,
	gmv_amount,
	mtd_gmv_amount,
	mtd_gmv_reach_rate,
	uv,
	yunyu_rate,
	cust_num,
	mtd_cust_num,
	pay_uv_rate
from
	rpt.rpt_health_key_kpi_overview
where
	dt>='-time1'
	and dt<'-time2'
	and stat_type in (-99,1,2,3)
