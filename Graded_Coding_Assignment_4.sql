/* Create and Use Schema */
create schema if not exists `Travel-On-The-Go`;
use `Travel-On-The-Go`;

/* Create PASSENGER Table */
create table if not exists `PASSENGER` (
	`Passenger_name` varchar(30),
	`Category` varchar(10),
	`Gender` varchar(1),
	`Boarding_City` varchar(30),
	`Destination_City` varchar(30),
	`Distance` int,
	`Bus_Type` varchar(10)
);

/* Create PRICE Table
create table if not exists `PRICE` (
	Bus_Type varchar
	Distance int
	Price int
)
*/

/* Split Price Table into 2 distinct tables */
create table if not exists `DISTANCE` (
	`Bus_Type_ID` int primary key,
	`Bus_Type` varchar(10),
	`Distance` int
);

create table if not exists `PRICE` (
	`Bus_Type_ID` int,
	`Price` int,
	foreign key(`Bus_Type_ID`) references distance(`Bus_Type_ID`)
);

/* Insert data into passenger Table */
insert into `passenger` values("Sejal", "AC", "F", "Bengaluru", "Chennai", 350, "Sleeper");
insert into `passenger` values("Anmol", "Non-AC", "M", "Mumbai", "Hyderabad", 700, "Sitting");
insert into `passenger` values("Pallavi", "AC", "F", "Panaji", "Bengaluru", 600, "Sleeper");
insert into `passenger` values("Khusboo", "AC", "F", "Chennai", "Mumbai", 1500, "Sleeper");
insert into `passenger` values("Udit", "Non-AC", "M", "Trivandrum", "Panaji", 1000, "Sleeper");
insert into `passenger` values("Ankur", "AC", "M", "Nagpur", "Hyderabad", 500, "Sitting");
insert into `passenger` values("Hemant", "Non-AC", "M", "Panaji", "Mumbai", 700, "Sleeper");
insert into `passenger` values("Manish", "Non-AC", "M", "Hyderabad", "Bengaluru", 500, "Sitting");
insert into `passenger` values("Piyush", "AC", "M", "Pune", "Nagpur", 700, "Sitting");

/* Insert data into distance Table */
insert into `distance` values(1,"Sleeper",350);
insert into `distance` values(2,"Sleeper",500);
insert into `distance` values(3,"Sleeper",600);
insert into `distance` values(4,"Sleeper",700);
insert into `distance` values(5,"Sleeper",1000);
insert into `distance` values(6,"Sleeper",1200);
insert into `distance` values(7,"Sleeper",350);
insert into `distance` values(8,"Sitting",500);
insert into `distance` values(9,"Sitting",600);
insert into `distance` values(10,"Sitting",700);
insert into `distance` values(11,"Sitting",1000);
insert into `distance` values(12,"Sitting",1200);
insert into `distance` values(13,"Sitting",1500);

/* Insert data into price Table */
insert into `price` values(1,770);
insert into `price` values(2,1100);
insert into `price` values(3,1320);
insert into `price` values(4,1540);
insert into `price` values(5,2200);
insert into `price` values(6,2640);
insert into `price` values(7,434);
insert into `price` values(8,620);
insert into `price` values(9,744);
insert into `price` values(10,868);
insert into `price` values(11,1240);
insert into `price` values(12,1488);
insert into `price` values(13,1860);

-- 3) How many females and how many male passengers travelled for a minimum distance of 600 KMs?
select if(gender="M","Male","Female") Gender,
count(*) Total_Count 
from passenger
where distance >= 600
group by gender;

-- 4) Find the minimum ticket price for Sleeper Bus. 
select min(p.price) "Minimum Sleeper Price" 
from price p
inner join distance d
on p.bus_type_id = d.bus_type_id
where d.bus_type = "Sleeper";

-- 5) Select passenger names whose names start with character 'S' 
select passenger_name 
from passenger
where upper(passenger_name) like upper('S%');

-- 6) Calculate price charged for each passenger displaying Passenger name, Boarding City, Destination City, Bus_Type, Price in the output
select p1.passenger_name,
       p1.Boarding_City,
	   p1.Destination_City,
	   p1.bus_type,
	   p1.distance,
	   p2.price
from passenger p1
left outer join distance d
on p1.bus_type = d.bus_type
and p1.distance = d.distance
left outer join price p2
on p2.bus_type_id = d.bus_type_id
order by p1.passenger_name,p1.distance,p2.price;

-- 7) What are the passenger name/s and his/her ticket price who travelled in the Sitting bus for a distance of 1000 KMs 
select p1.passenger_name,d.bus_type, p2.price 
from passenger p1
inner join distance d
on p1.distance = d.distance
and p1.bus_type = d.bus_type
inner join price p2
on p2.bus_type_id = d.bus_type_id
where p1.distance = 1000
and d.bus_type = "Sitting";

-- 8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?
select p1.passenger_name,d.bus_type, p2.price 
from passenger p1
inner join distance d
on p1.distance = d.distance
inner join price p2
on p2.bus_type_id = d.bus_type_id
where passenger_name = "Pallavi";

-- 9) List the distances from the "Passenger" table which are unique (non-repeated distances) in descending order.
select distinct distance 
from passenger
order by 1 desc;

-- 10) Display the passenger name and percentage of distance travelled by that passenger from the total distance travelled by all passengers without using user variables 
select passenger_name, distance, 
round(distance/(select sum(distance) from passenger) * 100,2) Dist_Trav_Percentage
from passenger;

-- 11) Display the distance, price in three categories in table Price
	-- 	a) Expensive if the cost is more than 1000
	-- 	b) Average Cost if the cost is less than 1000 and greater than 500
	-- 	c) Cheap otherwise
select distinct distance, price,
       case        
       WHEN price < 500 THEN "Cheap"
       WHEN price between 500 and 1000 THEN "Average Cost"
       else "Expensive"
       end price_category
from price p
inner join distance d
on p.bus_type_id = d.bus_type_id
order by 1;