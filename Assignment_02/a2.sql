/* Kimberly Crevecoeur 

worked with:

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
SELECT DISTINCT p1.pid, p1.name
FROM person p1, knows k, person p2
WHERE p1.pid = k.pid1 AND p2.pid = k.pid2 AND p2.city = 'Chicago' AND EXISTS (SELECT w.pid
    FROM worksfor w
    WHERE p1.pid = w.pid
        AND EXISTS (SELECT c.cname
        FROM company c
        WHERE w.cname = c.cname and c.city = 'Bloomington' ) );


-- 1.2.a
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



-- 1.4

--1.5
\qecho 1.5
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

/*
person: pid, name, city, birthyear
knows: pid1, pid2, PK -- (pid1, pid2)
company: cname, city, PK -- (cname, city)
worksfor: pid, cname, salary
jobskill: skill, PK-- skill
personskill: pid, skill

*/

-- 2.1.a
DROP VIEW IF EXISTS SalaryAbove50000;
CREATE VIEW SalaryAbove50000
AS
    SELECT p.pid, p.name, p.city, p.birthyear
    FROM person p, worksfor w
    WHERE p.pid = w.pid AND w.salary > 50000;

select *
from SalaryAbove50000;



-- 2.1.b
DROP VIEW IF EXISTS IBMEmployee;
CREATE VIEW IBMEmployee
AS
    SELECT p.pid
    FROM person p, worksfor w
    WHERE p.pid = w.pid AND w.cname ='IBM';

select *
from IBMEmployee;

-- 2.1.c
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
DROP FUNCTION IF EXISTS KnowsEmployeeAtCompany;
CREATE FUNCTION KnowsEmployeeAtCompany(workname TEXT) RETURNS TABLE
(pid INTEGER) AS
$$
SELECT distinct p1.pid
FROM person p1, knows k, person p2, worksfor w
WHERE k.pid1 = p1.pid and k.pid2 = p2.pid and w.pid = p2.pid and w.cname = workname;
$$   LANGUAGE  SQL;

\qecho 'People who know someone who works at Yahoo'
SELECT *
FROM KnowsEmployeeAtCompany('Yahoo');

\qecho 'People who know someone who works at Google'
SELECT *
FROM KnowsEmployeeAtCompany('Google');

\qecho 'People who know someone who works at Amazon'
SELECT *
FROM KnowsEmployeeAtCompany('Amazon');

--2.2.c
/*
Select w.salary, w.cname, p1.pid
FROM person p1, worksfor w, worksfor w2, company c
WHERE p1.pid = w2.pid and w2.cname = w.cname
    and  
*/
