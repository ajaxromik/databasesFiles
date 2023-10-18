SELECT * FROM adventureworks.employee;

select 	Concat(c.FirstName," ", c.LastName) as "name", 
		e.HireDate, 
		Concat(c2.FirstName," ", c2.LastName) as "Manager name",
        e2.HireDate as "Manager hire date"
from adventureworks.contact c
join adventureworks.employee e on (c.ContactID = e.ContactID) -- this is a self join
join adventureworks.employee e2 on (e.ManagerID = e2.EmployeeID)
join adventureworks.contact c2 on (e2.ContactID = c2.ContactID)
where c.FirstName = "dan" and c.LastName = "bacon";

select c.FirstName, c.LastName, c.EmailAddress, cc.CardNumber from adventureworks.contact c
join adventureworks.contactcreditcard ccc on ccc.ContactID = c.ContactID
join adventureworks.creditcard cc on cc.CreditCardID = ccc.CreditCardID
order by 2 asc;

desc adventureworks.contact;

-- dont do natural joins

select * from employee, department; -- implicit cross join lists every possible combination(cartesian product)
select * from employee
	cross join department; -- explicit cross join is better for readability
    
select f.title, f.length from sakila.film f
where f.rating = "g"
order by length desc
limit 10;

select @s_queen_length := length from sakila.film
where title = 'sorority queen';

select title, description, length from sakila.film
where length > @s_queen_length;
