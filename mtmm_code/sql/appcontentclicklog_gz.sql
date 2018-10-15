/*孕育内容点击表*/
select
	pageid,
	case when item_id is null or length(item_id)=0 then '0'
	else item_id end item_id,
	content_id,
	action_event,
	action_params,
	action_extend,
	case when mac is not null and mac>0 then cast(mac as varchar)
	else imei end uuid
from
	default.appcontentclicklog_gz
where
	dt>='-time1'
	and dt<'-time2'
	and action_event='2'
