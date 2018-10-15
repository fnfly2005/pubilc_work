/*孕育广告ID品牌对应表*/
select 
	ad_id,
	adv_brand_name
from 
	(
	select 
		b.bannerid ad_id,
		cl.clientname adv_brand_name,
		row_number() OVER(PARTITION BY b.bannerid ORDER BY cl.clientname desc) rk_id
	from 
		ods.ox_banners b
		left join ods.ox_campaigns c
		on b.campaignid = c.campaignid
		left join ods.ox_clients  cl
		on c.clientid = cl.clientid
			) a
where 
	rk_id=1
