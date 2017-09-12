/*大健康流量表,目前只有开讲分享有m端流量*/
select
	dt,
	uuid,
	sourcetype,
	userid babytree_enc_user_id,
	trackercode
from
	meitun.m_sourceubtpageview_gz
where
	dt>='-time1'
	and dt<'-time2'
	and sourcetype in ('btm-android', 'btm-ios')
	and (trackercode like '%djk%' 
	or url like '%djk%' 
	or tcode like '%djk%')
