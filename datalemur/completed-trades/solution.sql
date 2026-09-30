SELECT s.city , count(order_id) as total_order FROM trades t 
join  users s on t.user_id = s.user_id
where status = 'Completed'
group by s.city
order by total_order DESC
limit 3;
