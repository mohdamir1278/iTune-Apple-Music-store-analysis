select* from album;
select* from artist;
select * from customer;
select * from employee;
select * from genre;
select * from invoice;
select * from invoice_line;
select * from media_type;
select * from playlist;
select * from track;
select * from employee;


-- top ranked employee
select * from employee
where levels='L1' 
limit 1

-- top three highest billing countries

select billing_country, count('billing_country') as invoice_count
from invoice
group by billing_country
order by invoice_count desc
limit 3


-- highest billing country

select billing_city, sum("total") as Total_sum
from invoice
group by billing_city
order by total_sum desc
limit 1

-- the customer who highest purchase 
SELECT 
c.first_name, 
c.last_name, 
c.customer_id,
c.country,
SUM(i.total) AS total_sum
FROM 
customer c
JOIN 
invoice i ON c.customer_id = i.customer_id
GROUP BY 
c.first_name, c.last_name, c.customer_id
ORDER BY 
total_sum DESC
limit 1

-- the most played genre
select 
c.first_name,
c.last_name, 
c.email,
g.name as genre
from 
customer c
join 
invoice i on c.customer_id = i.customer_id
join 
invoice_line il on i.invoice_id = il.invoice_id
join
track t on il.track_id = t.track_id
join
genre g on t.genre_id = g.genre_id
where
g.name='Rock'
order by 
c.email;


select 
c.first_name,
c.last_name, 
c.email,
g.name as genre
from 
customer c
join 
invoice i on c.customer_id = i.customer_id
join 
invoice_line il on i.invoice_id = il.invoice_id
join
track t on il.track_id = t.track_id
join
genre g on t.genre_id = g.genre_id
where
g.name='Rock'
order by 
c.email

select 
a.name as artist_name,
t.name as track_name,
g.name as genre_name

from artist a
join 
album al on al.artist_id = a.artist_id
join
track t  on t.album_id = al.album_id
join 
genre g on g.genre_id = t.genre_id
where g.name='Rock' 
group by a.name,t.name,g.name

limit 10


SELECT 
    a.name AS artist_name,
    COUNT(t.track_id) AS total_track_count
FROM 
 artist a
JOIN 
    album al ON a.artist_id = al.artist_id
JOIN 
    track t ON al.album_id = t.album_id
join
genre g on g.genre_id = t.genre_id
WHERE 
    g.name = 'Rock'
GROUP BY 
    a.artist_id, a.name
ORDER BY 
    total_track_count DESC
LIMIT 10


-- longest songs length wise

select 
name as track_name, 
milliseconds
from track
order by 
milliseconds desc limit 3


 

select 
t.name as track_name,
t.milliseconds,
al.title as album_title
from track t
join
album al on t.album_id = al.album_id
order by t.name, t.milliseconds desc
limit 3

-- total spend on music
select
c.first_name ||' '||c.last_name as customer_name,
a.name as artist_name,
sum(il.unit_price*il.quantity )as total_spent
from customer c
join
invoice i on i.customer_id = c.customer_id
join 
invoice_line il on il.invoice_id = i.invoice_id
join
track t on il.track_id = t.track_id
join 
album al on t.album_id = al.album_id
join 
artist a on al.artist_id = a.artist_id
group by 
c.customer_id, a.artist_id
order by 
total_spent desc

-- total purchase by countries
 
with genresales as(
select
c.country,
g.name as genre,
count(*) as purchase_count
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
group by c.country, g.name
),
RankedGenres as (
select 
country, 
genre,
purchase_count,
rank() over(partition by country order by purchase_count desc) as genre_rank
from genresales
)
select 
country, genre, purchase_count
from rankedgenres
where genre_rank = 1
order by purchase_count desc
    
-- the most spent customer 

with customerSpending as(
select 
c.customer_id,
c.first_name||' '|| c.last_name as customer_name,
c.country,
sum(il.unit_price * quantity) as total_spent
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
group by c.customer_id, c.first_name, c.last_name,c.country
),
rankedspenders as(
select
customer_id, customer_name,country, total_spent,
rank() over(partition by country order by total_spent desc) as rank
from customerspending
)
select 
country,
customer_name,
total_spent
from rankedspenders
where rank=1
order by total_spent desc

-- the most invoice purchase country-- 
select 
c.country,
Sum(il.unit_price * il.quantity) as purchase
from
customer c
join
invoice i on c.customer_id = i.customer_id
join
invoice_line il on il.invoice_id = i.invoice_id
group by 
c.country
order by
purchase desc



-- average life span of customer

select 
avg(Customerlifespan) as cutomer_life_span,
avg(life_span_days)as lifedays
from(
select
i.customer_id,
sum(i.total) as customerlifespan,
max(i.invoice_date) - min(i.invoice_date) as life_span_days
from 
invoice i
group by i.customer_id 
) as customer_stats




