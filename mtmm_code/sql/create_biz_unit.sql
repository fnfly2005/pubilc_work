create table test.dim_biz_unit as 
select
	1 biz_unit_id,
	'自营' biz_unit_name
union all
select
	2 biz_unit_id,
	'代发' biz_unit_name
	;
