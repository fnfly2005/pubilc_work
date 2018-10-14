/*孕期维度表*/
select
	distance,
	pregnancy_week,
	case when pregnancy_static1='无年龄' then pregnancy_static1 
	else '有年龄' end pregnancy1,
	case when pregnancy_static1<>'无年龄' then pregnancy_static1 
	else null end pregnancy2,
	case when pregnancy_static1 like '孕%月' then '-1-0岁'
		when pregnancy_static1 like '婴%月' then '0-1岁'
		when pregnancy_static1 like '%岁' then '12月+' 
	else null end pregnancy3
from
	dw.dim_pregnancy_day
