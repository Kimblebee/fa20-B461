

-- 2 Formulating Queries in SQL

-- problem 2.1

SELECT e.id, e.ename, e.salary
FROM Employee e
WHERE city='Indianapolis' AND (salary>= 30000 AND salary <= 50000);


-- problem 2.2

SELECT e.id, e.ename
FROM Employee e,

    (SELECT m.mid, m.eid
    FROM manages m, Employee e
    WHERE m.mid= e.id AND e.city='Chicago') c

WHERE e.city='Bloomington' AND (e.id= c.eid);


-- problem 2.3

SELECT DISTINCT e.id, e.ename
FROM Employee e,
    (SELECT m.mid, m.eid, e.city
    FROM Manages m, Employee e
    WHERE m.mid = e.id) C
WHERE e.id = c.eid AND e.city = c.city;


-- problem 2.4

SELECT DISTINCT e.id, e.ename
FROM Employee e, Jobskill j1, Jobskill j2, Jobskill j3
WHERE e.id = j1.id AND e.id = j2.id AND e.id = j3.id
    AND j1.skill <> j2.skill AND j2.skill <> j3.skill AND j1.skill <> j3.skill
ORDER BY id;


-- problem 2.5

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

SELECT DISTINCT e1.id, e2.id
FROM Employee e1, Employee e2, Manages m1, Manages m2
WHERE m1.mid = m2.mid AND e1.id <> e2.id AND
    ((m1.eid = e1.id AND m2.eid = e2.id)
    OR
    (m1.eid = e2.id AND m2.eid = e1.id));


-- problem 2.7