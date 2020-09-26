-- Kimberly Crevecoeur 
--WORKED WITH: 
-- jackson ennis
-- james conway
-- benjamin reichert
-- zunaeed Salahuddin
-- kenjie moore

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

\qecho 'polynomial p'
SELECT *
from polynomial1;
\qecho 'polynomial q'
SELECT *
from polynomial2;

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

\qecho 'vector x'
SELECT *
from tablex;
\qecho 'vector y'
SELECT *
from tabley;

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
\qecho 'question 3'
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
\qecho 'question 4'
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
-- p1 lives in bloomington
-- p1 knows p2
-- p1 only knows one p2 that has 3 job skills
sELECT distinct p1.pid, p1.name
FROM person p1
WHERE p1.city = 'Bloomington' and
    -- This big Select is checking to see that the number of people known with at least 3 skills is <= 1
    (SELECT count (y.pid)
    -- this From is getting all people that p1 knows
    FROM (Select p2.pid
        from person p2, knows k
        where k.pid1 = p1.pid and k.pid2 = p2.pid and
            -- this condition is to make sure only people with at least 3 skills are returned
            (SELECT count(x.skill)
            FROM (SELECT DISTINCT ps.skill
                FROM personskill ps
                WHERE ps.pid = p2.pid )x) >=3)y )
                <=1;


--3.6
\qecho ' question 6'
SELECT DISTINCT p1.pid
FROM person p1
WHERE 
(SELECT count(x.skill)
FROM (SELECT DISTINCT ps.skill
    FROM personskill ps
    WHERE ps.pid = p1.pid )x) = 2;

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
DROP VIEW IF EXISTS SalaryAbove55000;
CREATE VIEW SalaryAbove55000
AS
    SELECT p1.pid, p1.name
    from person p1, knows k, person p2, worksfor w
    where p1.pid = k.pid1 and p2.pid = k.pid2 and w.pid = k.pid2 and w.salary > 55000;


DROP VIEW IF EXISTS allPids;
CREATE VIEW allPids
AS
    SELECT DISTINCT p1.pid, p1.name
    FROM person p1;


-------- actual question solution
    SELECT *
    FROM allPids
EXCEPT
    SELECT *
    from SalaryAbove55000

order by pid;


\qecho 'question 9'

-- list of pids of everyone who knows someone who works at netflix, has a salary >=55000, and birthyear > 1985
Create or replace view problem9 as
(
SELECT w.pid
From Worksfor w, person p
Where p.pid = w.pid and p.birthyear > 1985 and w.cname = 'Netflix' and w.salary >= 55000);

-- gets a list of everyone that pid1 knows
DROP FUNCTION IF EXISTS knowspeople;
CREATE FUNCTION knowspeople(personid integer) RETURNS TABLE
(pid integer) AS
$$
SELECT p2.pid
From person p1, person p2, knows k
where p1.pid = personid and p1.pid = k.pid1 and p2.pid = k.pid2
$$   LANGUAGE  SQL;



Select p.pid, p.name
FROM person p
WHERE EXISTS (                                                                                                        SELECT x.pid
    FROM problem9 x
INTERSECT
    SELECT *
    FROM knowspeople(p.pid) /*all ppl p knows function */);


-- 10 TODOTODOTODO
\qecho 'question 10'
-- fn gets a list of people who work at a given company
DROP FUNCTION if EXISTS worksforcompany;
CREATE FUNCTION worksforcompany (cname1 text) returns TABLE
(pid integer) AS
$$
SELECT DISTINCT w.pid
FROM worksfor w
WHERE w.cname = cname1
$$ LANGUAGE SQL;

-- view gets lisit of all people who make < 55000 

DROP VIEW IF EXISTS moreThan55000;
CREATE VIEW moreThan55000
AS
    SELECT DISTINCT w.pid
    FROM worksfor w
    WHERE w.salary >= 55000;


-- actual functional code for q10
Select distinct c.cname
FROM company c
WHERE not EXISTS (                                                        Select *
    From worksforcompany(c.cname)
INTERSECT
    (Select *
    from morethan55000));
-- where not exists, intersect company workers and above 55k



-- 11
\qecho 'question 11'

DROP VIEW IF EXISTS IBMSkills;
CREATE VIEW IBMSkills
AS
    SELECT DISTINCT ps.skill
    FROM person p, worksfor w, personskill ps
    WHERE p.pid = w.pid and w.cname = 'IBM';


DROP FUNCTION IF EXISTS CommonIBMSkills;
CREATE FUNCTION CommonIBMSkills(pid1 integer) RETURNS TABLE
(pskill text) AS
$$
    SELECT ps.skill
    FROM personskill ps
    WHERE ps.pid = pid1
INTERSECT
    Select *
    FROM IBMSkills
$$   LANGUAGE  SQL;

SELECT p.pid, p.name
FROM person p
WHERE (Select count(x.pskill)
FROM CommonIBMSkills(p.pid)x ) > 2;

\qecho 'question 12'

CREATE or REPLACE VIEW atleast50000 as
(select w.pid
from worksfor w
where w.salary >= 50000);

create or REPLACE FUNCTION employspeople
(company text)
returns table
(pid integer) AS
$$
select w.pid
from worksfor w
where w.cname = company;
$$ language sql;

SELECT DISTINCT w.cname
from worksfor w
WHERE (SELECT count (emp.pid)
FROM employsPeople(w.cname) emp
where emp.pid in (select atl.pid
from atleast50000 atl)
) % 2 != 0;


\qecho 'Question 13'

create or REPLACE FUNCTION has3skills
()
returns table
(pid1 integer) AS
$$
SELECT DISTINCT p.pid
FROM person p
-- getting the count of all skills someone has
WHERE (SELECT Count(x.skill)
FROM (SELECT ps.skill
    FROM personskill ps
    WHERE ps.pid = p.pid)x ) = 3;
$$ language sql;

SELECT p.pid, p.name
FROM person p
-- making sure that all people p knows totals > 2
WHERE (SELECT count(x.pid)

FROM (SELECT p2.pid
    FROM person p2, knows k
    -- specifying that all people p2 are known by p and are present in the table of all people with exactly 3 jobskills
    WHERE k.pid1 = p.pid and k.pid2 = p2.pid and p2.pid in (Select *
        from has3skills()))x) >=2;


\qecho 'question 14'

-- function to return list of everyone known by pid1
create or REPLACE FUNCTION knowsPerson
(ppid integer)
returns table
(pid integer) AS
$$
SELECT DISTINCT k.pid2
FROM knows k
where k.pid1 = ppid
$$ language sql;

-- actual problem solution
Select p1.pid, p2.pid
FROM person p1, person p2
WHERE p1.pid <> p2.pid and
    not EXISTS (
        SELECT *
    From (             Select *
            FROM knowsPerson(p1.pid)
        except
            (Select *
            FROM knowsperson(p2.pid))) z)

    and
    not EXISTS (
        SELECT *
    From (            select *
            FROM knowsPerson(p2.pid)
        except
            (Select *
            FROM knowsperson(p1.pid))) z);


\qecho 'Question 15'

SELECT p1.pid, p2.pid
FROM person p1, person p2
WHERE p1.pid <> p2.pid AND (Select COUNT(x.pid)
    FROM knowsperson(p1.pid)x) = (Select COUNT(y.pid)
    FROM knowsperson(p2.pid)y );



