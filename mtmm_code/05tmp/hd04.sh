#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} 1 days ago ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci="8020,8138,8139"
cu=`fun coupon_user`
du=`fun dim_user`
u=`fun user`
uaa=`fun userappapnmap`
uac=`fun userappclientidmaptotal`
cuc=`fun coupon_user_cl`
tdt=`date -d "today" +"%d%H%M"`
table=${2:-tmp.t_${tdt}}

file="hd04"
ios="${path}00output/${file}_ios.csv"
andriod="${path}00output/${file}_andriod.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
if [ 1 = 1 ]
then
${presto_e}"
${se}
create table ${table} as 
with cu as (
		${cu}
		and batch_id in (${ci})
		),
	 du as (
			 ${du}
		   ),
	 u as (
			 ${u}
		  ),
	 cuc as (
			 ${cuc}
		   ),
temp as (select 1)
 select distinct
	sensitive_user_id
 from
	cuc join u using(sensitive_enc_user_id)"
fi
${presto_e}"
${se}
with uaa as (
		${uaa}
		),
temp as (select 1)
	select distinct
		clientid
	from
		uaa join ${table} using(sensitive_user_id)
"|grep -iv "SET"|sed 's/"//g'>${ios}

${presto_e}"
${se}
with uac as (
		${uac}
		),
temp as (select 1)
	select distinct
		clientid
	from
		uac join ${table} using(sensitive_user_id)
"|grep -iv "SET"|sed 's/"//g'>${andriod}
