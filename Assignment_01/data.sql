drop table if exists employee;
drop table if exists company;
drop table if exists jobskill;
drop table if exists manages;

create table employee
(
    id integer PRIMARY KEY,
    ename text,
    city text,
    cname text,
    salary integer
);
create table company
(
    cname text ,
    city text
);
create table jobskill
(
    id integer,
    skill text
);
create table manages
(
    mid integer,
    eid integer
);


-- Data for the employee relation.
INSERT INTO employee
VALUES
    (1001, 'Jean', 'Bloomington', 'Apple', 60000),
    (1002, 'Vidya', 'Indianapolis', 'Apple', 45000),
    (1003, 'Anna', 'Chicago', 'Amazon', 55000),
    (1004, 'Qin', 'Denver', 'Amazon', 55000),
    (1005, 'Aya', 'Chicago', 'Google', 60000),
    (1006, 'Ryan', 'Chicago', 'Amazon', 55000),
    (1007, 'Danielle', 'Indianapolis', 'Netflix', 50000),
    (1008, 'Emma', 'Bloomington', 'Amazon', 50000),
    (1009, 'Hasan', 'Bloomington', 'Apple', 60000),
    (1010, 'Linda', 'Chicago', 'Amazon', 55000),
    (1011, 'Nick', 'NewYork', 'Google', 55000),
    (1012, 'Eric', 'Indianapolis', 'Apple', 50000),
    (1013, 'Lisa', 'Indianapolis', 'Netflix', 55000),
    (1014, 'Deepa', 'Bloomington', 'Apple', 50000),
    (1015, 'Chris', 'Denver', 'Amazon', 60000),
    (1016, 'YinYue', 'Chicago', 'Amazon', 55000),
    (1017, 'Latha', 'Indianapolis', 'Netflix', 60000),
    (1018, 'Arif', 'Bloomington', 'Apple', 50000);

-- Data for the company relation.
INSERT INTO company
VALUES
    ('Apple', 'Bloomington'),
    ('Amazon', 'Chicago'),
    ('Amazon', 'Denver'),
    ('Amazon', 'Columbus'),
    ('Google', 'NewYork'),
    ('Netflix', 'Indianapolis'),
    ('Netflix', 'Chicago'),
    ('Microsoft', 'Bloomington');

-- Data for the jobskill relation.
insert into jobskill
values
    (1001, 'Programming'),
    (1001, 'AI'),
    (1002, 'Programming'),
    (1002, 'AI'),
    (1004, 'AI'),
    (1004, 'Programming'),
    (1005, 'AI'),
    (1005, 'Programming'),
    (1005, 'Networks'),
    (1006, 'Programming'),
    (1006, 'OperatingSystems'),
    (1007, 'OperatingSystems'),
    (1007, 'Programming'),
    (1008, 'Programming'),
    (1009, 'OperatingSystems'),
    (1009, 'Networks'),
    (1010, 'Networks'),
    (1011, 'Networks'),
    (1011, 'OperatingSystems'),
    (1011, 'AI'),
    (1011, 'Programming'),
    (1012, 'AI'),
    (1012, 'OperatingSystems'),
    (1012, 'Programming'),
    (1013, 'Programming'),
    (1013, 'AI'),
    (1013, 'OperatingSystems'),
    (1013, 'Networks'),
    (1014, 'OperatingSystems'),
    (1014, 'AI'),
    (1014, 'Programming'),
    (1014, 'Networks'),
    (1015, 'Programming'),
    (1015, 'AI'),
    (1016, 'Programming'),
    (1016, 'OperatingSystems'),
    (1016, 'AI'),
    (1017, 'Networks'),
    (1017, 'Programming'),
    (1018, 'AI');


-- Data for the manages  relation.
INSERT INTO manages
VALUES
    (1001, 1002),
    (1001, 1009),
    (1001, 1012),
    (1009, 1018),
    (1009, 1014),
    (1012, 1014),
    (1003, 1004),
    (1003, 1006),
    (1003, 1015),
    (1015, 1016),
    (1006, 1008),
    (1006, 1016),
    (1016, 1010),
    (1005, 1011),
    (1013, 1007),
    (1013, 1017);