create table test.dim_topic_type as 
select
	0 topic_type_id,
	'长期在线' topic_type
union all
select
	4 topic_type_id,
	'拼团' topic_type
union all
select
	1 topic_type_id,
	'单品团' topic_type
union all
select
	2 topic_type_id,
	'主题团' topic_type
union all
select
	3 topic_type_id,
	'品牌团' topic_type
	;
