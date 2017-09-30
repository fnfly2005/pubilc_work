/*社区硬广基础日志数据*/
select 
	cast(event as varchar) event,
	case
		when client_type in ('android', 'android?') then imei
		when client_type in ('ios', 'ios?') then mac
	else uniqueid end equ_uuid,
	case when regexp_like(impressions,'[a-zA-Z%]') then 1
		when length(impressions)>0 and impressions is not null 
		then cast(split_part(impressions,'.',1) as bigint) 
	else 0 end impressions,
	ad_id        
from 
	baby_ods.trfc_yad_log
where 
	dt='-time1' 
	and impressions<'500'
	and (
		(imei is not null and imei<>'null' and length(imei)>0) 
		or (mac is not null and mac<>'null' and length(mac)>0)
		)
	and client_type in ('android', 'android?', 'ios', 'ios?')
union all
select 
	ad_event event,
	case
		when os='1' then imei
		when os='2' then mac
	else uniqueid end equ_uuid,
	case when ad_event='1' then 1 else 0 end impressions,
	ad_bannerid ad_id
from 
	ods.ad_log 
where 
	dt='-time1'
