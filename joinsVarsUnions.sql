SELECT *
FROM  sampdb.emp e 
where e.dept_no not in (select dept_no from dept);

SELECT *
FROM  sampdb.dept;

select 	e.* , d.dept_no, d.dept_name
from	sampdb.emp e
		left join	sampdb.dept d using (dept_no) 	-- outer join(aka left join) lets you show even when the values are null
where 	d.dept_name is null 	-- use 'is' when checking for null
order by 1;

-- right join uses the new table as the driving table

-- aliases only work on the first, order by's only work on the last
select last_name, first_name
from sampdb.president
union
select last_name, first_name from sampdb.member
order by 1 desc,2;

select * 
from sampdb.president 
where birth > '1924-02-03';

select 	@wilson_death := death -- @wilson_death variable stays until your mysql session ends
from	sampdb.president
where	first_name = 'woodrow';

select * from president
where death > @wilson_death;
