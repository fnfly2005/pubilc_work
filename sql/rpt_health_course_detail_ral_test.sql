select
	substr(date_id,1,7) mt,
	course_id,
	course_name,
	course_catagory_name,
	expert_name,
	organization_name,
	course_type,
	listen_gmv,
	cust_num,
	new_cust_num,
	voice_num,
	ask_question_num,
	expert_answer_num,
	award_cust_num,
	award_amount,
	course_like_num,
	uv,
	diversion_uv,
	uv*uv_rate r_uv,
	voice_play_times,
	course_price
from
	rpt.rpt_health_course_detail_ral_test
where
	is_weike=1
