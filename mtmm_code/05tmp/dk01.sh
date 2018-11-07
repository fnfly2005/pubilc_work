#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ds=`fun dim_sku` 
sopd=`fun sale_order_pay_detail`
mc=`fun sensitive_cart`
tnpd=`fun tfc_navpage_path_detail`
siha=`fun sword_imp_hard_adv_brand_mt_relation`
ox=`fun ox`
al=`fun ad_log`
tp2="tmp.t_292324"
tp="tmp.t_281843"
bd="(118,134,83,9828,126,1573,116,227,9754,82,503,1812,1747,1617,8470,1539,1740,8713,504,1739)"

file="dk01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 1 = 2 ]
then 
#筛选指定sku
${presto_e}"
${se}
with ds as (
		${ds}
		and category_lvl1_name='奶粉'
		and brand_id in ${bd}
		),
temp as (select 1)
	select distinct
		category_lvl1_name,
		category_lvl2_name,
		category_lvl3_name,
		brand_id,
		sku_code,
		prod_name
	from
		ds
"|grep -iv "SET">${attach}
fi

if [ 2 = 1 ]
then 
#曝光品牌
${presto_e}"
${se}
with siha as (
		${siha}
		),
	 ox as (
			 ${ox}
		   ),
	 al as (
			 ${al}
		   ),
	 sx as (
			select distinct
				brand,
				ad_id
			from
				siha
				join ${tp2} using(id)
				join ox on ox.adv_brand_name=siha.adv_brand_name
		),
temp as (select 1)
	select
		'${t1% *}' dt,
		brand,
		count(distinct case when EVENT in ('1','2') THEN equ_uuid else null end) advertise_uv,
		count(case WHEN EVENT='2' THEN equ_uuid else null end) click_count,
		sum(case when event='1' then impressions else 0 end) expose_count
	from
		al
		join sx on al.ad_id=cast(sx.ad_id as varchar)
	group by
		1,2
"|grep -iv "SET">>${attach}
fi

if [ 2 = 1 ]
then 
#销量销售
${presto_e}"
${se}
with sopd as (
		${sopd}
		),
	 ds as (
			 ${ds}
		   ),
	 dp as (
			 select
				brand,
				sub_brand,
				sku_id
			 from
				ds
				join ${tp} t using(sku_code)
			where
				t.is_vsku=0
		   ),
temp as (select 1)
/*	select
		dt,
		-99 brand,
		0 sub_brand,
		count(distinct sensitive_enc_user_id) suv,
		count(distinct parent_order_id) so,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt
	from
		sopd s
		join dp using(sku_id)
	group by
		1,2,3
	union all
	select
		dt,
		brand,
		0 sub_brand,
		count(distinct sensitive_enc_user_id) suv,
		count(distinct parent_order_id) so,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt
	from
		sopd s
		join dp using(sku_id)
	group by
		1,2,3
	union all*/
	select
		dt,
		brand,
		sub_brand,
		count(distinct sensitive_enc_user_id) suv,
		count(distinct parent_order_id) so,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt
	from
		sopd s
		join dp using(sku_id)
/*	where
		sub_brand<>0*/
	group by
		1,2,3
"|grep -iv "SET">${attach}
fi

if [ 1 = 1 ]
then 
#复购率分布
${presto_e}"
${se}
with ds as (
		${ds}
		),
	 dp as (
			 select
				brand,
				sub_brand,
				sku_id
			 from
				ds join ${tp} tp on ds.sku_code=tp.sku_code and category_lvl1_name='奶粉'
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 sd as (
			select
				brand,
				sub_brand,
				sensitive_enc_user_id,
				count(distinct parent_order_id) num
			from
				sopd join dp using(sku_id)
			group by
				1,2,3
		   ),
temp as (select 1)
/*	select
		brand,
		'all' sub_brand,
		num,
		count(distinct sensitive_enc_user_id)
	from
		sd
	group by
		1,2,3
	union all*/
	select
		brand,
		sub_brand,
		num,
		count(distinct sensitive_enc_user_id)
	from
		sd
/*	where
		brand<>sub_brand*/
	group by
		1,2,3
"|grep -iv "SET">${attach}
fi

if [ 2 = 1 ]
then 
#复购SKU数量
${presto_e}"
${se}
with ds as (
		${ds}
		),
	 dp as (
			 select
				brand,
				sub_brand,
				sku_id,
				ds.sku_code
			 from
				ds join ${tp} tp on ds.sku_code=tp.sku_code and category_lvl1_name='奶粉'
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 sd as (
			select
				brand,
				sub_brand,
				sku_code,
				sensitive_enc_user_id,
				count(distinct parent_order_id) num
			from
				sopd join dp using(sku_id)
			group by
				1,2,3,4
		   ),
temp as (select 1)
	select
		brand,
		sub_brand,
		count(distinct case when num>1 then sku_code end) sku_num,
		count(distinct sku_code) sku_all
	from
		sd
	group by
		1,2
"|grep -iv "SET">${attach}
fi

if [ 1 = 2 ]
then 
#单单价客单价排名
${presto_e}"
${se}
with ds as (
		${ds}
		),
	 dp as (
			 select
				brand,
				sub_brand,
				sku_id
			 from
				ds join ${tp} tp on ds.sku_code=tp.sku_code and category_lvl1_name='奶粉'
		   ),
	 d1 as (
			 select
				brand_name brand,
				sku_id
			 from
				ds left join ${tp} tp on ds.sku_code=tp.sku_code
			where
				tp.sku_code is null
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 sd1 as (
			select
				brand,
				sub_brand,
				(sum(order_amt)/count(distinct parent_order_id)) o_price,
				(sum(order_amt)/count(distinct sensitive_enc_user_id)) u_price
			from
				dp join sopd using(sku_id)	
			where
				brand<>sub_brand
			group by
				1,2
			union all
			select
				'all' brand,
				brand sub_brand,
				(sum(order_amt)/count(distinct parent_order_id)) o_price,
				(sum(order_amt)/count(distinct sensitive_enc_user_id)) u_price
			from
				dp join sopd using(sku_id)	
			group by
				1,2
			union all
			select
				'all' brand,
				brand sub_brand,
				(sum(order_amt)/count(distinct parent_order_id)) o_price,
				(sum(order_amt)/count(distinct sensitive_enc_user_id)) u_price
			from
				d1 join sopd using(sku_id)	
			group by
				1,2
		  ),
		  sd2 as (
				select 
					brand,
					sub_brand,
					o_price,
					u_price,
					row_number() over (order by o_price desc) o_top,
					row_number() over (order by u_price desc) u_top
				from
					sd1
				 ),
temp as (select 1)
	select distinct
		dp.brand,
		'all' sub_brand,
		o_price,
		u_price,
		o_top,
		u_top
	from
		sd2
		join dp on sd2.sub_brand=dp.brand
	union all
	select
		brand,
		sub_brand,
		o_price,
		u_price,
		o_top,
		u_top
	from
		sd2
	where
		brand<>'all'
"|grep -iv "SET">${attach}
fi

if [ 2 = 1 ]
then 
#加购
${presto_e}"
${se}
with mc as (
		${mc}
		),
temp as (select 1)
	select
		brand,
		sub_brand,
		sum(cart_sku_num) cart_sku_num
	from
		mc join ${tp} using(sku_code)
	group by
		1,2
"|grep -iv "SET">${attach}
fi

if [ 2 = 1 ]
then 
#漏斗
${presto_e}"
with tnpd as (
		${tnpd}
		),
temp as (select 1)
	select
		dt,
		s.brand,
		'all' sub_brand,
		COUNT(DISTINCT CASE WHEN t.track_flag=1 THEN t.uuid ELSE NULL END) AS qz_uv,
		COUNT(DISTINCT CASE WHEN t.navpage_track_id IS NOT NULL AND length (t.navpage_track_id)>1 AND t.track_flag = 1 THEN t.uuid ELSE NULL END) AS navpage_uv,
		COUNT(DISTINCT CASE WHEN t.item_track_id IS NOT NULL AND length (t.item_track_id) > 1 AND t.track_flag = 1 THEN t.uuid ELSE NULL END ) AS item_uv,
		COUNT ( DISTINCT CASE WHEN t.cart_track_id IS NOT NULL AND length (t.cart_track_id) > 1 AND t.track_flag = 1 THEN t.uuid ELSE NULL END ) AS cart_uv,
		COUNT ( DISTINCT CASE WHEN t.parent_order_id IS NOT NULL THEN t.sensitive_enc_user_id ELSE NULL END ) AS order_uv,
		COUNT ( DISTINCT CASE WHEN order_pay_flag = 1 THEN t.sensitive_enc_user_id ELSE NULL END ) AS pay_uv
	from
		tnpd t join ${tp} s
		on case when t.sku_code is not null and length(t.sku_code) >1 then t.sku_code else t.item_sku end =s.sku_code
	where
		s.brand<>s.sub_brand
	group by
		1,2,3
"|grep -iv "SET">>${attach}
fi
