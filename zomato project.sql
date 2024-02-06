create database zomato;
use zomato;
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date);

INSERT INTO goldusers_signup(userid,gold_signup_date) 
VALUES (1,'2017-09-22'),
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');

drop table if exists sales;
create table sales(userid integer,created_date date,product_id integer);
INSERT INTO sales(userid,created_date,product_id)
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2017-12-20',2),
(1,'2016-11-09',1),
(1,'2015-05-20',3),
(2,'2016-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-01',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);
drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer);
insert into product(product_id,product_name,price)
VALUES 
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

#rank all the transactions of customers
 select *,rank() over(partition by userid order by created_date)rnk from sales;
#what is the total amount each customer spent on zomato
select a.userid,a.product_id,b.price from sales a inner join product b on a.product_id and b.product_id;
select a.userid,sum(b.price) amount_spent from sales a inner join product b on a.product_id and b.product_id group by userid;    
#How many days each person visited zomato
select userid,count(distinct created_date)from sales group by userid;
#what is the first product purchased by each customer
(select * ,rank() over(partition by userid order by created_date) rnk from sales);
select * from (select * ,rank() over(partition by userid order by created_date)rnk from sales) a where rnk=1;
#what is most purchased item on menu and how many times was it purchased by all customers?
select product_id,count(product_id) total_purchase from sales group by product_id;
select product_id,count(product_id)from sales group by product_id order by count(product_id) desc;

#how many times was it purchased by all the customers?
select userid,count(product_id) cnt from sales where product_id=
(select product_id from sales group by product_id order by count(product_id)desc)
group by userid;

#which was the most popular for each customer?
select *,rank() over(partition by userid order by count(product_id) desc) rnk from
(select userid,product_id,count(product_id)  from sales group by userid,product_id);

#which item purchased first by customer after they became a member?
select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid;
#orders after goldsignup_membership
select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
 goldusers_signup b on a.userid=b.userid and created_date>gold_signup_date;
 #first order after gold membership
 select * from
 (select c.*,rank()over(partition by userid order by created_date) rnk from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
 goldusers_signup b on a.userid=b.userid and created_date>gold_signup_date)c)d where rnk=1;
 
 #which item was purchased just before becoming member
 select * from
 (select c.*,rank()over(partition by userid order by created_date desc) rnk from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
 goldusers_signup b on a.userid=b.userid and created_date<=gold_signup_date)c)d where rnk=1;
 
 #what is total order and amount spent for each member before they became member?
 select userid,count(created_date) order_purchased ,sum(price)total_amt_spent from
 (select c.*,d.price from
 (select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
 goldusers_signup b on a.userid=b.userid and created_date<=gold_signup_date)c inner join product d on c.product_id)e
 group by userid;
 
 select a.created_date,a.userid,b.product_id,b.product_name from sales a right join product b on a.product_id=b.product_id;
 select * from sales a right join product b on a.product_id=b.product_id;
 select * from sales a left join product b on a.product_id=b.product_id;
 select * from sales a inner join product b on a.product_id=b.product_id;
 select * from sales;
 select * from product;
 select a.userid,a.product_id,b.price from sales a inner join product b on a.product_id and b.product_id;
select a.userid,sum(b.price) amount_spent from sales a inner join product b on a.product_id and b.product_id group by userid;
 
 select a.userid,a.product_id,b.price from sales a inner join product b on a.product_id=b.product_id;
 select a.userid,sum(b.price)amount_spent from sales a inner join product b on a.product_id and b.product_id group by userid;
 select c.*,rank()over(partition by userid order by amount_spent ) from
 (select a.userid,sum(b.price)amount_spent from sales a inner join product b on a.product_id and b.product_id group by id);
 
 #if buying each product generates points for eg-5 rupees 2 points and each product has different purchasing points
 #for eg for p1 5rs-1 zomato points,for p2 10 rupees 5 zomato points and p3 5 rupess 1 zomato point
 
 select * from sales;
 select * from product;
 
 select a.*,b.price from sales a inner join product b on a.product_id = b.product_id;
 
 select c.userid,c.product_id,sum(price) from
  (select a.*,b.price from sales a inner join product b on a.product_id = b.product_id)c
  group by userid,product_id;
  
  select d.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
  (select c.userid,c.product_id,sum(price) amt from
  (select a.*,b.price from sales a inner join product b on a.product_id = b.product_id)c
  group by userid,product_id)d;
  
  select userid,sum(total_points) points_earned from
  (select e.*,amt/points total_points from
   (select d.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
  (select c.userid,c.product_id,sum(price) amt from
  (select a.*,b.price from sales a inner join product b on a.product_id = b.product_id)c
  group by userid,product_id)d)e)f group by userid;
  
  
  select *,rank() over(order by points_earned desc)from
   (select product_id,sum(total_points) points_earned from
  (select e.*,amt/points total_points from
   (select d.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
  (select c.userid,c.product_id,sum(price) amt from
  (select a.*,b.price from sales a inner join product b on a.product_id = b.product_id)c
  group by userid,product_id)d)e)f group by product_id)f;
  
  
  
  #In the first one year after a customer joins the gold program(including their joining date)irrespective of what the customer has purchased
  #they earn 5 zomato points for every 10 rupees spent who earned more 1 or 3 and what was their points earning in their first year
 
 select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date and created_date<= date_add(gold_signup_date);
 
 #rank all the transactions for each member whenever they are a zomato gold member for every non gold member transaction mark as na
 select c.*,case when gold_signup_date is null then 'na'  else rank() over(partition by userid order by gold_signup_date desc)end as rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a left join goldusers_signup b on a.userid=b.userid and created_date>=gold_signup_date)c;
 
 
 
 


