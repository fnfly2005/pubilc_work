select
	case when 
		uuid is not null 
		and length(uuid)>0 
		then uuid
	else cookieid end uuid,
	sourcetype
from
	meitun.m_sourceubtpageview
where
	dt>='-time1'
	and dt<'-time2'
	and trackercode not like '%dsp%'
	and trackercode not like 'djk-%' 
	and url not like 'djk-%' 
	and url not like 'qd%' 
	and trackercode not like 'qd%'
	and tcode not like '%djk_kj%'
	and trackercode not like '%djk_kwys%' 
	and url not like '%djk_kwys%' 
	and tcode not like '%djk_kwys%'
	and logevent<>'3'
	and ((logevent='2' and sourcetype in ('btm-android','android','btm-ios','ios','1','0')) or sourcetype in ('m','pc') or logevent is null or length(logevent)=0)
	and ((length(uuid)>0 and uuid is not null) or (length(cookieid)>0 and cookieid is not null))
