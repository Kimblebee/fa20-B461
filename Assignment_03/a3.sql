
-- jackson ennis
-- james conway

-- question1.1

drop table if exists polynomial1;
create table polynomial1
(
    coeff integer,

    degree integer
);

insert into polynomial1
values
    (2, 2),
    (-5, 1),
    (5, 0);

drop table if exists polynomial2;
create table polynomial2
(
    coeff integer,
    degree integer
);

insert into polynomial2
values
    (4, 4),
    (3, 3),
    (1, 2),
    (-1, 1),
    (0, 0);



create or replace function multiplicationPandQ
()
returns table
(coefficient bigint, degree integer) as
$$
SELECT sum(x.coeff), x.degree
FROM
    (SELECT p1.coeff * p2.coeff as coeff, p1.degree + p2.degree as degree
    FROM polynomial1 p1, polynomial2 p2
    order by degree) as x

group by x.degree;
$$ language sql;


SELECT *
FROM multiplicationPandQ();




\qecho 'Question 2'


drop table if exists tablex;
create table tablex
(
    index integer,
    val integer
);

insert into tablex
values
    (1, 7),
    (2, -1),
    (3, 2);

drop table if exists tabley;
create table tabley
(
    index integer,
    val integer
);

insert into tabley
values
    (1, 1),
    (2, 1),
    (3, -10);

create or replace function dotProductXandY
() returns bigint as
$$
(SELECT sum(z.val)
FROM (SELECT x.val * y.val as val
    FROM tablex x, tabley y
    WHERE x.index = y.index) Z
)
$$ language sql;


select *
from dotProductXandY();

-- 2.3 
\qecho '2.3'
SELECT p.pid, p.name
FROM Person p
WHERE p.city = 'Bloomington' AND
    (SELECT COUNT(1)
    FROM personSkill ps
    WHERE ps.pid = p.pid and ps.skill <> 'Programming') >=1 AND (SELECT Count(1)
    FROM worksfor w, personskill ps2
    WHERE w.cname = 'Netflix' and w.pid = p.pid) >=1
;


-- 2.4
\qecho '2.4'
SELECT w.pid, w.cname, w.salary
FROM worksfor w
WHERE NOT (SELECT Count(w2.salary)
FROM worksfor w2, company c
WHERE w.pid <> w2.pid and w.cname = w2.cname and not w.salary <= w2.salary and
    (SELECT count(p.city)
    FROM person p
    WHERE p.birthYear <> 1990 and p.city = c.city)=0)=0;


-- 3.5
\qecho 'question 5'
sELECT distinct p1.pid, p1.name
FROM person p1
WHERE p1.city = 'Bloomington' and

    (SELECT count (y.pid)
    FROM (Select p2.pid
        from person p2, knows k
        where k.pid1 = p1.pid and k.pid2 = p2.pid and
            (SELECT count(x.skill)
            FROM (SELECT DISTINCT ps.skill
                FROM personskill ps
                WHERE ps.pid = p2.pid )x) >=3 )y 
)<=1;


--3.6
\qecho ' question 6'
SELECT DISTINCT p1.pid
FROM person p1
WHERE 
(SELECT count(x.skill)
FROM (SELECT DISTINCT ps.skill
    FROM personskill ps
    WHERE ps.pid = p1.pid )x) =2;

--3.7 
\qecho 'question 7'
SELECT c.cname, count(p1.pid)
FROM company c, person p1, worksfor w
WHERE p1.pid = w.pid and w.cname = c.cname
    and
    -- the person knows at least 2 other employees
    (SELECT count(p1.pid)
    FROM person p1, knows k, person p2, worksfor w2
    WHERE k.pid1 = p1.pid and k.pid2 = p2.pid
        AND w2.pid = p2.pid AND w2.cname = c.cname) >= 2
group by c.cname;


-- 4.8
-- except, [not] exists, [not] in, intersect
\qecho  'question 8'

-- this function lists off everyone who know someone with a salary above 55000
drop function if exists knowsWithSalaryAbove;
CREATE function knowsWithSalaryAbove
() 
RETURNS TABLE
(pid INTEGER,
    name text) AS
$$
SELECT p1.pid, p1.name
from person p1, knows k, person p2, worksfor w
where p1.pid = k.pid1 and p2.pid = k.pid2 and w.pid = k.pid2 and w.salary > 55000
$$   LANGUAGE  SQL;


DROP VIEW IF EXISTS SalaryAbove55000;
CREATE VIEW SalaryAbove55000
AS
    SELECT p1.pid, p1.name
    from person p1, knows k, person p2, worksfor w
    where p1.pid = k.pid1 and p2.pid = k.pid2 and w.pid = k.pid2 and w.salary > 55000


-------- actual question solution
    SELECT distinct p1.pid, p1.name
    from person p1
EXCEPT
    SELECT *
    from SalaryAbove55000

order by pid;




