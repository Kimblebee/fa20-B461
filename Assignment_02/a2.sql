/* Kimberly Crevecoeur 

worked with:
michael abbott
Zunaeed S
jackson ennis
Matthew Geborek
*/
-- Section 1

--\qecho "question 1.1.a"


select DISTINCT p1.name, p1.pid
FROM Person p1, person p2, knows k, Company c, worksfor w
where k.pid1 = p1.pid
    AND k.pid2 = p2.pid
    AND w.pid = p1.pid
    AND w.cname = c.cname
    AND c.city = 'Bloomington'
    AND p2.city='Chicago'
ORDER BY pid;

-- 1.1.b
\qecho '1.1.b'

select DISTINCT p1.name, p1.pid
FROM Person p1, person p2, knows k, Company c, worksfor w
where k.pid1 = p1.pid
    AND k.pid2 = p2.pid
    AND w.pid = p1.pid
    AND w.cname = c.cname
    AND c.city IN ( 'Bloomington')
    AND p2.city IN ('Chicago')
ORDER BY pid;

--1.1.c using some/all
\qecho '1.1.c'

select DISTINCT p1.name, p1.pid
FROM Person p1, person p2, knows k, Company c, worksfor w
where k.pid1 = p1.pid
    AND k.pid2 = p2.pid
    AND w.pid = p1.pid
    AND w.cname = c.cname
    AND c.city IN ( 'Bloomington')
    AND p2.pid = some(select distinct p.pid
    from person p
    where p.city = 'Chicago')
ORDER BY pid;

-- 1.1.d
\qecho '1.1.d'
SELECT DISTINCT p1.pid, p1.name
FROM person p1, knows k, person p2
WHERE p1.pid = k.pid1 AND p2.pid = k.pid2 AND p2.city = 'Chicago' AND EXISTS (SELECT w.pid
    FROM worksfor w
    WHERE p1.pid = w.pid
        AND EXISTS (SELECT c.cname
        FROM company c
        WHERE w.cname = c.cname and c.city = 'Bloomington' ) );


-- 1.2.a
\qecho '1.2.a'
-- find pid and name of some1 who:
-- know someone who works at googles
-- does NOT know someone who works at amazons
-- has programming skill

    SELECT DISTINCT p1.pid, p1.name
    FROM person p1, knows k, person p2, Company c, worksfor w
    --...
    WHERE k.pid1 = p1.pid and k.pid2 = p2.pid and w.pid = p2.pid and w.cname = 'Google'

EXCEPT
    (SELECT pa.pid, pa.name
    FROM person pa, knows ka, person pb, worksfor wa, personskill s
    WHERE ka.pid1 = pa.pid AND ka.pid2 = pb.pid
        AND s.pid = pb.pid
        AND s.skill = 'Programming'
        AND wa.pid = pb.pid
        AND wa.cname = 'Amazon' )
ORDER BY pid;

-- 1.2.b
-- SELECT DISTINCT p1.pid, p1.name 
\qecho '1.2.b'

    SELECT DISTINCT p1.pid, p1.name
    FROM person p1, knows k, person p2, Company c, worksfor w
    --...
    WHERE k.pid1 = p1.pid and k.pid2 = p2.pid and w.pid = p2.pid and w.cname = 'Google'

EXCEPT
    (SELECT pa.pid, pa.name
    FROM person pa, knows ka, person pb, worksfor wa, personskill s
    WHERE ka.pid1 = pa.pid AND ka.pid2 = pb.pid
        AND s.pid = pb.pid
        AND s.skill = 'Programming'
        AND wa.pid = pb.pid
        AND wa.cname = 'Amazon' )
ORDER BY pid;

-- 1.2.c
\qecho '1.2.c'

    SELECT DISTINCT p1.pid, p1.name
    FROM person p1, knows k, person p2, Company c, worksfor w
    --...
    WHERE k.pid1 = p1.pid and k.pid2 = p2.pid and w.pid = p2.pid and w.cname = 'Google'

EXCEPT
    (SELECT pa.pid, pa.name
    FROM person pa, knows ka, person pb, worksfor wa, personskill s
    WHERE ka.pid1 = pa.pid AND ka.pid2 = pb.pid
        AND s.pid = pb.pid
        AND s.skill = 'Programming'
        AND wa.pid = pb.pid
        AND wa.cname = 'Amazon' )
ORDER BY pid;


-- 1.3.a
\qecho '1.3.a'
SELECT distinct c.cname
FROM company c, worksfor w1, worksfor w2, personskill ps1, personskill ps2, person p1, person p2
WHERE p1.pid = ps1.pid
    AND p2.pid = ps2.pid
    AND w1.pid = p1.pid
    AND w2.pid = p2.pid
    AND p1.pid != p2.pid
    AND w1.cname = c.cname
    AND w2.cname = c.cname
    AND ps1.skill = ps2.skill;

--1.3.b
\qecho '1.3.b'
SELECT DISTINCT c.cname
FROM company c
WHERE c.cname IN (SELECT c1.cname
FROM company c1, person p1, person p2, personskill ps1, personskill ps2, worksfor wf1, worksfor wf2
WHERE p1.pid != p2.pid AND p1.pid = wf1.pid AND wf1.cname = c1.cname AND p2.pid = wf2.pid AND wf2.cname = c1.cname AND ps1.pid = p1.pid AND ps2.pid = p2.pid AND ps1.skill = ps2.skill);

\qecho '1.3.c'

SELECT DISTINCT c.cname
from company c, person p1, person p2
WHERE p1.pid != p2.pid AND EXISTS( SELECT c1.cname
    FROM company c1, personskill ps1, personskill ps2, worksfor wf1, worksfor wf2
    WHERE p1.pid = wf1.pid AND wf1.cname = c.cname AND p2.pid = wf2.pid AND wf2.cname = c.cname AND ps1.pid = p1.pid AND ps2.pid = p2.pid AND ps1.skill = ps2.skill);



-- 1.4.a

\qecho '1.4.a'
Select DISTINCT p1.pid, p1.name
FROM person p1, worksfor w, personskill ps
WHERE p1.pid = w.pid and w.cname = 'IBM' and w.salary =
                                            (Select max(salary)
    FROM (SELECT w2.Salary
        FROM worksfor w2
        WHERE w2.cname = 'IBM')x);


\qecho '1.4.b'
Select DISTINCT p1.pid, p1.name
FROM person p1, worksfor w, personskill ps
WHERE p1.pid = w.pid and w.cname = 'IBM' and w.salary =
                                            (Select max(salary)
    FROM (SELECT w2.Salary
        FROM worksfor w2
        WHERE w2.cname = 'IBM')x);


--1.5
\qecho '1.5'
SELECT DISTINCT c.cname, p1.pid, p1.name
FROM person p1, company c, worksfor w
WHERE p1.pid = w.pid and w.cname = c.cname and w.salary  in
-- finds the second minimum salary for a company.
-- 1.) find a list of company salaries
-- 2.) find a list of company salaries > minimum
-- 3.) find the minimum salary from that list
(Select min(salary)
    from
        (Select x.salary
        from (Select w2.salary
            from worksfor w2
            where w2.cname = c.cname) x
        where x.salary > (Select min(salary)
        from worksfor w2
        where w2.cname = c.cname) 
        )z
);



-- 1.6
\qecho '1.6'
SELECT distinct p1.pid, p1.name
FROM person p1, knows k, person p2, jobskill j

-- if the person doesnt know anyone
WHERE (p1.pid not in (select k2.pid1
    from knows k2
    where k2.pid1 = p1.pid))
    OR -- or if they do know someone, then they only know one person that has 2 jobskills
    (k.pid1 = p1.pid and k.pid2 = p2.pid
    and p2.pid = ALL(select k2.pid2
    from knows k2
    where k2.pid1 = p1.pid)
    and p2.pid in (select p2.pid
    from personskill j1, personskill j2
    where j1.pid = p2.pid and j2.pid = p2.pid and j1.skill != j2.skill)

)
order by pid;

-- 1.7
\qecho '1.7'
    SELECT j.skill
    FROM personskill j
EXCEPT
    (select j2.skill
    FROM person p2, worksfor w, personskill j2
    WHERE p2.pid = w.pid and p2.pid = j2.pid and w.cname in ('Yahoo', 'Netflix')
);

-- 1.8
\qecho '1.8'

SELECT js1.skill, js2.skill
FROM jobskill js1, jobskill js2
WHERE (js1.skill = js2.skill) or
    ( Select ps1.pid
    from personskill ps1
    where ps1.skill = js1.skill
        ) =
    ALL
        (Select ps2.pid
    from personskill ps2
    where ps2.skill = js2.skill);
/*
person: pid, name, city, birthyear
knows: pid1, pid2, PK -- (pid1, pid2)
company: cname, city, PK -- (cname, city)3
worksfor: pid, cname, salary
jobskill: skill, PK-- skill
personskill: pid, skill

*/

-- 2.1.a
\qecho
'2.1.a'
DROP VIEW IF EXISTS SalaryAbove50000;
CREATE VIEW SalaryAbove50000
AS
    SELECT p.pid, p.name, p.city, p.birthyear
    FROM person p, worksfor w
    WHERE p.pid = w.pid AND w.salary > 50000;

select *
from SalaryAbove50000;



-- 2.1.b
\qecho '2.1.b'

DROP VIEW IF EXISTS IBMEmployee;
CREATE VIEW IBMEmployee
AS
    SELECT p.pid
    FROM person p, worksfor w
    WHERE p.pid = w.pid AND w.cname ='IBM';

select *
from IBMEmployee;

-- 2.1.c
\qecho '2.1.c'

    Select p.pid, p.name
    from person p, worksfor w
    where p.pid = w.pid and w.cname = 'Apple'
        and w.salary >50000
EXCEPT
    (Select p1.pid, p1.name
    from person p1, knows k, person p2, worksfor w2
    where k.pid1 = p1.pid and k.pid2 = p2.pid and p2.pid = w2.pid and w2.cname = 'IBM'
);


-- 2.2.a
\qecho '2.2.a'

DROP FUNCTION IF EXISTS SalaryAbove;
CREATE FUNCTION SalaryAbove(amount INTEGER) RETURNS TABLE
(pid INTEGER, name TEXT, city TEXT, birthyear INTEGER) AS
$$
SELECT p.pid, p.name, p.city, p.birthyear
FROM person p, worksfor w
WHERE p.pid = w.pid and w.salary > amount;
$$   LANGUAGE  SQL;

\qecho 'Salary above 30000'
SELECT *
FROM SalaryAbove(30000);

\qecho 'Salary above 50000'
SELECT *
FROM SalaryAbove(50000);

\qecho 'Salary above 70000'
SELECT *
FROM SalaryAbove(70000);

-- 2.2.b


\qecho '2.2.b'
drop function if exists knowsemployeeatcompany;
CREATE function
 KnowsEmployeeAtCompany
(workname TEXT) RETURNS TABLE
(pid INTEGER, kpid INTEGER) AS
$$
SELECT distinct p1.pid, k.pid2
FROM person p1, knows k, person p2, worksfor w
WHERE k.pid1 = p1.pid and k.pid2 = p2.pid and w.pid = p2.pid and w.cname = workname;
$$   LANGUAGE  SQL;

\qecho 'People who know someone who works at Yahoo'
SELECT c.pid
FROM KnowsEmployeeAtCompany('Yahoo') c;

\qecho 'People who know someone who works at Google'
SELECT c.pid
FROM KnowsEmployeeAtCompany('Google') c;

\qecho 'People who know someone who works at Amazon'
SELECT c.pid
FROM KnowsEmployeeAtCompany('Amazon') c;

--2.2.c

\qecho 'Problem 2.2.c'
SELECT DISTINCT w2.salary, c.cname, p.pid
FROM worksfor w, company c, person p, company c1, worksfor w2
WHERE p.pid = w.pid
    AND w.cname = c.cname
    AND p.pid IN (SELECT x.pid
    FROM SalaryAbove(w2.salary)x) -- persons salary is above
    AND p.pid IN (Select y.pid
    FROM KnowsEmployeeAtCompany(c1.cname) y
    WHERE c1.cname != c.cname -- making sure they both don't work at the same company
        AND y.kpid NOT IN (SELECT t.pid
        FROM SalaryAbove(w2.salary)t));


\qecho 'Problem 3.1'
Drop TABLE IF EXISTS vals;

create table vals
(
    number INTEGER
);
insert into vals
values
    (1),
    (2),
    (3),
    (4),
    (5);

Select v.number as x, sqrt(v.number) as sqrt_x, power(v.number, 2) as squared_x, power(2, v.number) as two_to_the_power_x, factorial(v.number) as x_factorial,
    log(v.number) as log_x
FROM vals v;


DROP TABLE IF EXISTS A;
DROP TABLE IF EXISTS B;
DROP TABLE IF EXISTS c;

create table A
(
    numbera INTEGER
);
create table B
(
    numberb INTEGER
);
create table C
(
    numberc INTEGER
);

insert into A
values
    (1),
    (2);

insert into B
values
    (1),
    (4),
    (5);

-- 3.2.a
\qecho '3.2.a'
SELECT EXISTS
    (
        SELECT *
    FROM A
INTERSECT
    SELECT *
    FROM B);


-- 3.2.b
\qecho '3.2.b'
INSERT INTO B
VALUES
    (2);

SELECT NOT EXISTS
    (
        SELECT *
    FROM A
INTERSECT
    (
        SELECT *
    FROM a
INTERSECT
    SELECT *
    FROM b)
);


\qecho '3.3a'
SELECT NOT EXISTS
(SELECT p.pid
FROM person p, personskill ps1, personskill ps2
WHERE p.pid = ps1.pid AND p.pid = ps2.pid AND ps1.skill = ps2.skill)
AS answer; 
