SELECT EXTRACT(MONTH from r. submit_date) as mth  , r.product_id , cast(AVG(r.stars) as Decimal(10,2))as avg_star FROM reviews r
join  reviews s on r.product_id = s.product_id 
group by mth ,  r.product_id
order by mth ,  r.product_id  ;
