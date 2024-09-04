with promotion as (
	select user_id
	      , createdts as promo_at
	      , date_format(createdts, '%Y-%m') as promo_at_month
	from new_user
	where page_name = 'promotion' 
), detail as (
	select user_id
	      , createdts as detail_at
	      , date_format(createdts, '%Y-%m') as detail_at_month
	from new_user
	where page_name = 'product_detail'
), orderr as (
	select user_id
	      , createdts as order_at
	      , date_format(createdts, '%Y-%m') as order_at_month
	from new_user
	where page_name = 'order' 
), complete as (
	select user_id
	      , createdts as complete_at
	      , date_format(createdts, '%Y-%m') as complete_at_month
	from new_user
	where page_name = 'order_complete' 
)
select promo_at_month as month
, count(DISTINCT promotion.user_id)/count(DISTINCT promotion.user_id) as promotion_user
     , count(DISTINCT detail.user_id)/count(DISTINCT promotion.user_id) as detail_user
     , count(DISTINCT orderr.user_id)/count(DISTINCT promotion.user_id) as order_user
     , count(DISTINCT complete.user_id)/count(DISTINCT promotion.user_id) as order_complete_user
from promotion
	left join detail on promotion.user_id = detail.user_id
				   and promotion.promo_at <= detail.detail_at	
				   and promotion.promo_at_month = detail.detail_at_month
	left join orderr on detail.user_id = orderr.user_id
				   and detail.detail_at_month = orderr.order_at_month	   
	left join complete on orderr.user_id = complete.user_id
				   and orderr.order_at <= complete.complete_at
				   and orderr.order_at_month = complete.complete_at_month	  
group by month