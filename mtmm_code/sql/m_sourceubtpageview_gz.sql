select
	dt,
	case when trackercode='sensitive_to_sensitive'
		and tcode='qiandao_sy' then null
		else (case when uuid is not null 
				and length(uuid)>0 
				then uuid
			else cookieid end) end) uuid,
	sourcetype,
	href,
	referrer,
	userid sensitive_enc_user_id,
	trackercode
from
	sensitive.m_sourceubtpageview_gz
where
	dt>='-time1'
	and dt<'-time2'
	and trackercode not like '%dsp%'
	and trackercode not like 'djk%' 
	and url not like 'djk%' 
	and tcode not like '%djk%'
	and url not like 'qd%' 
	and trackercode not like 'qd%'
	and tcode not like '%djk_kj%'
	and trackercode not like '%djk_kwys%' 
	and url not like '%djk_kwys%' 
	and tcode not like '%djk_kwys%'
	and logevent<>'3'
	and ((logevent in ('1','2') and sourcetype in ('btm-android','android','btm-ios','ios','1','0')) or sourcetype in ('m','pc') or logevent is null or length(logevent)=0)
	and ((length(uuid)>0 and uuid is not null) or (length(cookieid)>0 and cookieid is not null))
