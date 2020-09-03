/*
Kimberly Crevecoeur 1.2.2020
Worked with:
Jackson Ennis
Zunaeed Salahuddin
Ben Reichert
Will Boland
*/

-- problem 1.1

SELECT *
FROM employee;

SELECT *
FROM company;


SELECT *
FROM jobskill;

SELECT *
FROM manages;

-- problem 1.2
\qecho '1.2'

\qecho 'this insert will work b/c primary/foreign keys are absent'
INSERT INTO company
VALUES
    ('Disney', 'Orlando');

\qecho 'this delete works b/c no primary/foreign keys'
DELETE FROM company
WHERE cname = 'Disney'

\qecho ' this delete wont work b/c this employee is relied upon in manages table'
--DELETE FROM employee e where e.id =1012;
\qecho 'this  insertion works bc we are modifying a primary key'
INSERT INTO employee
VALUES
    (1006, 'Antoinette', 'Chicago', 'Amazon', 55000);

--deleting inserted thing
DELETE from employee
WHERE ename = 'Antoinette'



-- 2 Formulating Queries in SQL ****************

-- problem 2.1
\qecho '2.1'
SELECT e.id, e.ename, e.salary
FROM Employee e
WHERE city='Indianapolis' AND (salary>= 30000 AND salary <= 50000);


-- problem 2.2
\qecho 'problem 2.2'

SELECT e.id, e.ename
FROM Employee e,

    (SELECT m.mid, m.eid
    FROM manages m, Employee e
    WHERE m.mid= e.id AND e.city='Bloomington') c

WHERE e.city='Chicago' AND (e.id= c.eid);


-- problem 2.3
\qecho 'problem 2.3'

SELECT DISTINCT e.id, e.ename
FROM Employee e,
    (SELECT m.mid, m.eid, e.city
    FROM Manages m, Employee e
    WHERE m.mid = e.id) C
WHERE e.id = c.eid AND e.city = c.city;


-- problem 2.4
\qecho 'problem 2.4'

SELECT DISTINCT e.id, e.ename
FROM Employee e, Jobskill j1, Jobskill j2, Jobskill j3
WHERE e.id = j1.id AND e.id = j2.id AND e.id = j3.id
    AND j1.skill <> j2.skill AND j2.skill <> j3.skill AND j1.skill <> j3.skill
ORDER BY id;


-- problem 2.5
\qecho 'problem 2.5'

SELECT DISTINCT e.id, e.ename, e.salary

FROM Employee e,
    Manages m,

    -- getting list of employees who have programming skill + their manager
    (SELECT e.id, e.ename, m.mid
    FROM Employee e, Manages m, Jobskill j
    WHERE j.id= e.id AND j.skill='Programming' AND m.eid = e.id)c

WHERE e.id = m.mid AND m.eid = c.mid
ORDER BY id;


-- problem 2.6
\qecho 'problem 2.6'

SELECT DISTINCT e1.id, e2.id
FROM Employee e1, Employee e2, Manages m1, Manages m2
WHERE m1.mid = m2.mid AND e1.id <> e2.id AND
    ((m1.eid = e1.id AND m2.eid = e2.id)
    OR
    (m1.eid = e2.id AND m2.eid = e1.id));


-- problem 2.7 ***********
\qecho 'problem 2.7'

    SELECT DISTINCT c.cname
    FROM company c
EXCEPT
    SELECT DISTINCT e.cname
    FROM employee e
    WHERE	e.city = 'Bloomington';


-- problem 2.8 ***********
\qecho 'problem 2.8'

SELECT distinct c.cname, e.id
FROM Company c, Employee e
WHERE e.cname = c.cname AND e.salary >= ALL(SELECT e.salary
    FROM Employee e );


-- problem 2.9
\qecho 'problem 2.9'

SELECT DISTINCT e.id, e.ename
FROM Employee e
-- getting a list of all ppl with a manager who makes more
-- what we are returning is everyone whois NOT in this list.
where e.id NOT IN
    (SELECT DISTINCT m.eid
from manages m, employee e2, employee e3
where m.mid = e2.id AND m.eid = e3.id AND e2.salary > e3.salary
    )
ORDER BY id;


-- problem 2.10
\qecho 'problem 2.10'

SELECT DISTINCT managers.mid, emp.ename
FROM manages managers, employee emp
WHERE emp.id = managers.mid AND managers.mid NOT IN (SELECT DISTINCT mid
    FROM manages m, employee e, jobskill j
    WHERE e.id = m.mid AND j.id = e.id AND j.skill IN (
        SELECT DISTINCT j2.skill
        FROM jobskill j2
        WHERE j2.id = m.eid)); 



    