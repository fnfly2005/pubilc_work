#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"

file="djk03"
s_file="cm03"
script="${path}05tmp/${s_file}.sh"
attach="${path}00output/${file}.csv"
s_attach="${path}00output/${s_file}.csv"

model=${attach/00output/model}
cp ${model} ${attach}

sku=(
	34090100070101
	34090100080101
	)
for s in "${sku[@]}"
do 
	bash ${script} ${t1% *} ${t2% *} ${s}
	cat ${s_attach}>>${attach}
done

script="${path}bin/mail.sh"
topic="﻿和睦家服务类SKU-流量日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
mt_name=(
		duyanhua
	 )
bb_name=(
		miaozhen
	)
for i in "${mt_name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
for i in "${bb_name[@]}"
do 
	address="${address}, ${i}@babytree-inc.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
