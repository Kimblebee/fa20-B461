-- worked with 
/* 
Louis L.
zunaeed S.
Jackson E.
Ben Reichert
*/
--\qecho 'problem 1'
    SELECT DISTINCT w.pid
    from worksfor w
        INNER JOIN company c on (w.cname = c.cname)
    WHERE c.city = 'Bloomington'
INTERSECT
    (SELECT distinct k.pid1
    from knows k
        INNER JOIN person p on (p.pid = k.pid2)
    WHERE p.city = 'Chicago')
order by pid;

\qecho 'Problem 2'

(SELECT j.skill
FROM jobskill j)
EXCEPT(
WITH
    E1
    AS
    (
        select distinct e1.skill, e1.pid, e1.cname
        from (personskill s natural join worksfor w )
     e1),
            E2 AS
(select distinct e1.skill
from E1 e1
where e1.cname = 'Yahoo' or e1.cname = 'Netflix')
SELECT e2.skill
FROM E2 e2
);

\qecho 'Problem 3'
    SELECT DISTINCT c.cname
    FROM company c
INTERSECT
    SELECT DISTINCT wf1.cname
    FROM personskill ps1 INNER JOIN personskill ps2 ON 
    (ps1.skill = ps2.skill) INNER JOIN worksfor wf1 ON
     (wf1.pid = ps1.pid) INNER JOIN worksfor wf2 ON 
     (wf2.pid = ps2.pid AND wf1.cname = wf2.cname)
    WHERE ps1.pid <> ps2.pid
order by cname;

-- 1.4
\qecho 'Problem 4'
    SELECT DISTINCT p.pid, p.name
    FROM person p
        INNER JOIN worksfor w ON (w.cname = 'Google')
        INNER JOIN person p2 ON (p2.pid = w.pid)
        INNER JOIN knows k ON (p.pid = k.pid1 AND p2.pid = k.pid2)
EXCEPT
    SELECT DISTINCT p1.pid, p1.name
    FROM person p1 INNER JOIN knows k on (k.pid1 = p1.pid)
        INNER JOIN Person p2 ON (k.pid2 = p2.pid) INNER JOIN
        Worksfor w on (w.pid = p2.pid and w.cname = 'Amazon')
        INNER JOIN personskill ps on (ps.skill = 'Programming')
    WHERE p2.pid = ps.pid
order by pid;

\qecho 'Problem 5'


    SELECT DISTINCT p.pid, p.name
    FROM Person p, WorksFor wf
    WHERE p.pid = wf.pid AND wf.cname = 'IBM'
EXCEPT
    SELECT DISTINCT p1.pid, p1.name
    FROM Person p1
        INNER JOIN PersonSkill ps1 ON (p1.pid = ps1.pid)
        INNER JOIN WorksFor wf1 ON (p1.pid = wf1.pid)
        INNER JOIN WorksFor wf2 ON (wf1.cname = 'IBM' AND wf2.cname = 'IBM')
        INNER JOIN Person p2 ON (p2.pid = wf2.pid)
        INNER JOIN PersonSkill ps2 ON (p2.pid = ps2.pid)
    WHERE wf1.salary < wf2.salary
order by pid;


\qecho 'Problem 6'
    SELECT p.pid, p.name
    FROM person p
EXCEPT
    SELECT k.pid1, p.name
    from knows k INNER JOIN worksfor w on (k.pid2 = w.pid)
        INNER JOIN person p on (p.pid = k.pid1)
    where w.salary >55000
order by pid;

\qecho 'problem 7'
    SELECT c.cname
    FROM company c
EXCEPT
    SELECT w.cname
    from worksfor w
    WHERE w.salary >= 55000
order by cname;



--'Problem 8'
\qecho 'Problem 8'
    SELECT DISTINCT js1.skill, js2.skill
    FROM person p1, jobskill js1, personskill sk1, jobskill js2
    WHERE p1.pid = sk1.pid and sk1.skill = js1.skill
intersect
    SELECT distinct js1.skill, js2.skill
    FROM person p1, person p2, personskill sk, jobskill js1, jobskill js2
    WHERE js1.skill = sk.skill and sk.pid = p2.pid and sk.skill = js2.skill and p2.pid != p1.pid;



