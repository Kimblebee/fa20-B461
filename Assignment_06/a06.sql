-- worked with will boland, kenjie moore, zunaeed salahuddin, jackson ennis, michael abbott, 
--
create or replace function setdifference(A anyarray, B anyarray)
returns anyarray as
$$
select array( select unnest(A) except select unnest(B) order by 1);
$$ language sql;
--
create or replace function setintersection(A anyarray, B anyarray)
returns anyarray as
$$
select array( select unnest(A) intersect select unnest(B) order by 1);
$$ language sql;
--
create or replace function setdifference(A anyarray, B anyarray)
returns anyarray as
$$
select array( select unnest(A) except select unnest(B) order by 1);
$$ language sql;
-- 
create or replace function setdifference(A anyarray, B anyarray)
returns anyarray as
$$
select array( select unnest(A) except select unnest(B) order by 1);
$$ language sql;
--
create or replace function subset(A anyarray, B anyarray)
returns boolean as
$$
select A <@ B;
$$ language sql;

--
create or replace function isIn(x anyelement, A anyarray)
returns boolean as
$$
select x = SOME(A);
$$ language sql;

\qecho "Question 1.a"

drop view if exists cityHasCompany;
create or replace view cityHasCompany as
select distinct cl.city, array(select distinct c.cname
                                from company c, companylocation cl2
                                where cl2.cname = c.cname and cl2.city = cl.city) as companies
                                from companyLocation cl
                                order by city;
  select * from cityHasCompany;

\qecho "Question 1.b"
drop view if exists companyLocations;
create or replace view companyLocations as
select distinct c.cname, array(select distinct cl.city
                                from companylocation cl
                                where cl.cname = c.cname) as locations
                                from company c
                                order by cname;
select * from companyLocations;
    
\qecho "Question 1.c"
drop view if exists knowsPersons;
create or replace view knowsPersons as
select distinct p1.pid, array(select distinct k.pid2
                                from knows k
                                where k.pid1 = p1.pid
                                order by pid2) as persons
        from person p1
        order by pid;
select * from knowsPersons;
\qecho "Question 1.d"
drop view if exists isKnownByPersons;
create or replace view isKnownByPersons as
select distinct p1.pid, array(select distinct k.pid1
                                from knows k
                                where k.pid2 = p1.pid
                                order by pid1) as persons
        from person p1
        order by pid;
select * from isKnownByPersons;



\qecho "Question 1.e"
create or replace view personHasSkills as
	select distinct p.pid, array(select distinct ps.skill
								from PersonSkill ps
								where p.pid = ps.pid
								order by ps.skill) AS skills
	from Person p
	order by p.pid;
select * from personHasSkills;

\qecho "Question 1.f"
create or replace view skillOfPersons as
	select distinct js.skill as skills, array(select distinct ps.pid
										from PersonSkill ps
										where ps.skill = js.skill
										order by ps.pid) AS persons
	from jobskill js
	order by js.skill;
 select * from skillOfPersons;

-- CANNOT USE Knows, companyLocation, personSkill
-- CAN USE person, company, jobSkill, worksFor, 
-- skillOfPersons, personHasSkills, isKnownByPersons,
-- knowsPersons, companyLocations, cityHasCompanies, companyEmployees
\qecho "Question 2.a"
select distinct k.pid, p.name
from knowsPersons k, worksfor w1, worksfor w2, person p
    where isIn(w1.pid, k.persons) 
      and isIn(w2.pid, k.persons) 
      and w1.cname = 'Amazon' 
      and w2.cname = 'Amazon'
      and w1.pid <> w2.pid 
      and p.pid = k.pid;

--2b
\qecho "Question 2.b"
-- selecting all people who work for amazon
select distinct p.pid, p.name
  from Person p, knowsPersons k
  where p.pid = k.pid 
  and subset(array(select w.pid 
                    from worksfor w 
                    where w.cname = 'Amazon' 
                      and  w.salary <= 40000), k.persons)
  order by p.pid;

\qecho "question 2.c" 
select unnest(setdifference((select array(select distinct js.skill from jobSkill js)), 
  
  (select array(select distinct unnest(phs.skills)
    from personHasSkills phs, worksfor wf, companyLocation c
    where c.city = 'Bloomington' and phs.pid = wf.pid and wf.cname = c.cname)))) as var\;


\qecho 'question 2.d'
select unnest(setdifference(array(select skill from jobskill), array (select distinct unnest (phs.skills) as skill from worksfor wf, personhasskills phs
where (phs.pid = wf.pid and cardinality(array(select wf2.pid from worksfor wf2 where wf2.cname = wf.cname)) >= 5)) ));


\qecho "question 2.e"
select ps.pid
from personhasskills ps
where subset(ps.skills,(select array(select distinct unnest(ps1.skills) 
    from personhasskills ps1, worksfor w
    where ps1.pid = w.pid and w.cname = 'Amazon' and w.salary < 50000)));

\qecho "question 2.f"
select p.pid
from person p
where cardinality((select distinct (phs.skills)
                            from personHasSkills phs
                            where phs.pid = p.pid )) = 3;
                            
\qecho "question 2.g"
select p1.pid, p1.name, array(select distinct p2.pid 
                              from person p2, knowsPersons kp, worksfor w
                              where kp.pid = p1.pid   and
                              w.pid = p2.pid and w.cname = 'Amazon'
                              and
                              isIn(p2.pid, (select kp.persons 
                                                from knowspersons kp 
                                                where kp.pid = p1.pid)))
                                                from person p1;

\qecho "question 2.h"
select count(1) from(select distinct p1.pid, p2.pid
                  from isknownbypersons p1, knowspersons p2 
                  where cardinality(setdifference(p1.persons, p2.persons)) >0) as lol;

\qecho 'question 2.i'
SELECT DISTINCT phs.pid, setintersection((SELECT ARRAY(SELECT DISTINCT UNNEST(phs.skills) AS skills
FROM worksfor wf, personHasSkills phs
WHERE (wf.cname = 'Amazon' OR wf.cname = 'Google') AND phs.pid = wf.pid) as skills), phs.skills)
FROM personHasSkills phs; 




-- CANNOT USE Knows, companyLocation, personSkill
-- CAN USE person, company, jobSkill, worksFor, 
-- skillOfPersons, personHasSkills, isKnownByPersons,
-- knowsPersons, companyLocations, cityHasCompanies, companyEmployees




