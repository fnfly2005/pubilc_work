#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} 1 days ago ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
du=`fun dim_user`
ds=`fun dim_sku`
pab=`fun pr_activity_base`
dsa=`fun dim_single_activity`
dc=`fun dim_topic`
sopd=`fun sale_order_pay_detail`
sso=`fun sale_sub_order`
scfo=`fun sale_cust_first_order`
dtt=`fun dim_topic_type`

file="sku_detail"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with du as (
		${du}
		),
	 ds as (
			 ${ds}
		   ),
	 pab as (
			 ${pab}
			),
	 dc as (
			 ${dc}
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 sso as (
		   	${sso}
		    ),
	 scfo as (
			 ${scfo}
			 ),
	 dtt as (
			 ${dtt}
			),
	 line as (
			 select
				order_line_id,
				4 topic_type_id,
				topic_name
			 from
				sopd
				join pab on parent_order_type=5 and sopd.promotion_id=pab.promotion_id
			union all
			select
				order_line_id,
				topic_type_id,
				topic_name
			from
				sopd
				join dc on parent_order_type<>5 and dc.topic_id=sopd.topic_id
	),
	s1 as (
			select
				sopd.order_line_id,
				case when topic_type_id is null then 0
				else topic_type_id end topic_type_id,
				topic_name
			from
				sopd
				left join line using(order_line_id)
		),
	s2 as (
			select
				order_line_id,
				topic_name,
				topic_type
			from
				s1
				join dtt using(topic_type_id)
		  ),
temp as (select 1)
	select
		sopd.track_source,
		sopd.topic_id,
		s2.topic_name,
		s2.topic_type,
		sopd.parent_order_id,
		sopd.sub_order_id,
		province_name,
		sopd.babytree_enc_user_id,
		case when scfo.babytree_enc_user_id is null then 'old'
		else 'new' end user_type,
		ds.sku_code,
		ds.barcode,
		ds.prod_name,
		ds.brand_name,
		ds.category_lvl1_name,
		ds.category_lvl2_name,
		ds.category_lvl3_name,
		ds.basic_price,
		sopd.sku_num,
		sopd.order_amt,
		sopd.order_net_amt,
		(sopd.order_amt-sopd.order_net_amt) coupon_amt,
		sopd.supplier_id,
		ds.supplier_name,
		ds.sea_type,
		sso.pay_time,
		du.baby_birthday,
		ds.biz_unit
	from
		sopd
		join s2 using(order_line_id)
		join sso on sopd.sub_order_id=sso.sub_order_id
		join ds on sopd.sku_id=ds.sku_id
		left join scfo on sopd.babytree_enc_user_id=scfo.babytree_enc_user_id
		left join du on sopd.babytree_enc_user_id=du.babytree_enc_user_id
"|grep -iv "SET">>${attach}

name=(
	lixueli
	 )
script="${path}bin/mail.sh"
topic="﻿sku明细"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
fsize=`ls -l ${attach} | cut -d' ' -f 5`
if [ ${fsize} -ge 80000000 ]
then
content="﻿文件大于80MB未发出，邮件由系统发出，有问题请联系樊年"
fi

bash ${script} "${topic}" "${content}" "${attach}" "${address}"
