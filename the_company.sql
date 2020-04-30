create database THE_COMPANY;
use THE_COMPANY;
set foreign_key_checks = 0;
	drop table if exists Offices;
	drop table if exists Staff;
	drop table if exists Salary;
set foreign_key_checks = 1;

create table Offices(
    `of_id` smallint unsigned not null unique primary key check(`of_id` <= 9999),
    `of_name` varchar(100) not null unique,
    `of_bonus` char(1) not null check(`of_bonus` = 'Y' or `of_bonus` = 'N'),
	`of_bonus_amount` decimal(3, 2) check(`of_bonus_amount` >= 0 and `of_bonus_amount` <= 0.25)
);

create table Staff(
	`st_office_id` smallint unsigned not null,
    `st_empl_id` smallint unsigned not null primary key,
    `st_firstname` varchar(50) not null,
    `st_lastname` varchar(50) not null,
    `st_position` varchar(50) not null,
    `st_startdate` date not null,
    foreign key (`st_office_id`) references Offices(`of_id`)
);

create table Salary(
	`sa_employee_id` smallint unsigned not null,
	`sa_salary` decimal(8, 2) unsigned not null,
    `sa_bonus` char(1) not null check(`sa_bonus` = 'Y' or `sa_bonus` = 'N'),
	`sa_bonus_amount` decimal(3, 2) check(`sa_bonus_amount` >= 0 and `sa_bonus_amount` <= 0.15),
	foreign key (`sa_employee_id`) references Staff(`st_empl_id`)
);

insert into Offices(`of_id`, `of_name`, `of_bonus`, `of_bonus_amount`) values
	(729, 'Orange Israel', 'Y', '0.15'),
	(30, 'Orange France', 'N', '0.0'),
   	(45, 'Orange Japan', 'Y', '0.2');
    
insert into Staff(`st_office_id`, `st_empl_id`, `st_firstname`, `st_lastname`, `st_position`,
`st_startdate`) values
	(729, 1, 'Yonah', 'Rabin', 'CEO', '1993-01-10'),
    (729, 2, 'EIlis', 'Gollancz', 'COO', '1993-01-10'),
    (729, 4, 'Eitan', 'Littauer', 'Senior Developer', '2016-03-22'),
    (729, 7, 'Meyer', 'Levinsky', 'Software Engineer', '2016-03-22'),
    (729, 8, 'Aryeh', 'Marnyansky', 'QA Specialist', '2020-04-01'),
    (729, 12, 'Izreal', 'Ran', 'Product Manager', '2013-12-11'),
    (729, 15, 'Anat', 'Rivkin', 'HR Specialist', '2018-10-01'),
    (729, 17, 'Jessie', 'Meir', 'Accountant', '1997-01-01'),
    
	(30, 203, 'Alva', 'Schwab', 'CEO', '2019-06-08'),
    (30, 207, 'Inès', 'Chevalier', 'COO', '2019-08-15'),
    (30, 209, 'Lucien', 'Jacquard', 'Senior Developer', '2007-01-01'),
    (30, 210, 'Michaël', 'Féret', 'Software Engineer', '2019-09-03'),
    (30, 215, 'Émeline', 'Parmentier', 'QA Specialist', '2014-05-01'),
    (30, 218, 'Camille', 'Vasseur', 'Product Manager', '2019-08-15'),
	(30, 220, 'Ameline', 'Parmentieu', 'HR Specialist', '2017-11-01'),
    (30, 221, 'Noé', 'Rigal', 'Accountant', '2012-02-29'),
    
	(45, 401, 'Morioka', 'Takeru', 'CEO', '2019-01-01'),
    (45, 403, 'Sada', 'Gaho', 'COO', '2016-07-12'),
    (45, 404, 'Moteki', 'Tomi', 'Senior Developer', '2015-11-01'),
    (45, 408, 'Nishimura', 'Kae', 'Software Engineer', '2015-11-01'),
    (45, 410, 'Sando', 'Masatake', 'QA Specialist', '2018-07-15'),
    (45, 411, 'Adina', 'Zangwill', 'Product Manager', '2016-07-12'),
    (45, 415, 'Soon-Ja', 'Chong', 'HR Specialist', '2019-04-08'),
    (45, 417, 'Taira', 'Matabei', 'Accountant', '2008-04-01');
    
insert into Salary(`sa_employee_id`, `sa_salary`, `sa_bonus`, `sa_bonus_amount`) values
	(1, 60000, 'Y', 0.15),
    (2, 50000, 'Y', 0.15),
    (4, 25000, 'N', 0.0),
    (7, 18000, 'N', 0.0),
    (8, 11000, 'Y', 0.1),
    (12, 22000, 'N', 0.0),
    (15, 14000, 'N', 0.0),
    (17, 11000, 'Y', 0.05),
    
	(203, 65000, 'N', 0.0),
    (207, 58000, 'N', 0.0),
    (209, 26000, 'Y', 0.1),
    (210, 21000, 'Y', 0.05),
    (215, 13000, 'N', 0.0),
    (218, 23000, 'N', 0.0),
	(220, 16000, 'Y', 0.05),
    (221, 12000, 'N', 0.0),
    
	(401, 68000, 'Y', 0.1),
    (403, 53000, 'Y', 0.1),
    (404, 25000, 'Y', 0.1),
    (408, 19000, 'N', 0.0),
    (410, 12500, 'N', 0.0),
    (411, 24000, 'Y', 0.1),
    (415, 15000, 'N', 0.0),
    (417, 12500, 'N', 0.0);

-- query #1:
	-- (1) select all offices
	-- (2) select average salary (which includes both office and staff bonuses)
		-- of software specialists in all offices
    -- order results by (2)
drop table if exists q1_avg;
create temporary table q1_avg
select Offices.`of_name`, Offices.`of_bonus_amount`, Salary.`sa_salary`, Salary.`sa_bonus_amount`
	from Offices
    join Staff on Offices.`of_id` = Staff.`st_office_id`
    join Salary on Staff.`st_empl_id` = Salary.`sa_employee_id`
		where Staff.`st_position` in ('Senior Developer', 'Software Engineer', 'QA Specialist', 'Product Manager')
        group by Staff.`st_empl_id`;
select `of_name`,
	round(avg(	-- https://www.w3resource.com/sql/aggregate-functions/avg-with-round.php
		`sa_salary` * (1 + `sa_bonus_amount` + `of_bonus_amount`)
	), 2) as `avg_earnings`
	from q1_avg
		group by `of_name`
		order by `avg_earnings` desc;
    
-- query #2: select foreign (non-Israel) staff members with less than 3-year company experience receiving
	-- office and/or staff salary bonuses in total of 10% or more
select Staff.`st_firstname`, Staff.`st_lastname`
	from Staff
    join Offices on Staff.`st_office_id` = Offices.`of_id`
    join Salary on Staff.`st_empl_id` = Salary.`sa_employee_id`
		where Offices.`of_id` != 729	-- non-Israel staff
			and (Offices.`of_bonus` = 'Y' or Salary.`sa_bonus` = 'Y')
            and Salary.`sa_bonus_amount` + Offices.`of_bonus_amount` >= 0.1	-- bonus >= 10%
            and datediff(now(), Staff.`st_startdate`) < 1095.75	-- 3 years = (3 x 365.25) days
		group by Staff.`st_empl_id`;
        
-- query #3: select three most experienced staff members as of 2019-12-31 inclusive
select Staff.`st_firstname`, Staff.`st_lastname` from Staff
	group by Staff.`st_empl_id`
	order by Staff.`st_startdate` limit 3;
-- issue: there could be two or more staff members with the same `st_startdate`
	-- the proper solution pattern is shown in query #4

-- query #4: select staff member(s) with the longest full name (there could be more than 1 record)
select concat(`st_firstname`, ' ', `st_lastname`) as `longest name` from Staff
	group by `st_empl_id`
    having char_length(`longest name`) = (	-- https://www.mysqltutorial.org/mysql-having.aspx
		select char_length(concat(`st_firstname`, ' ', `st_lastname`)) as `name` from Staff
			group by `st_empl_id`
            order by `name` desc
            limit 0, 1	-- https://www.mysqltutorial.org/mysql-limit.aspx
	)
	order by char_length(`longest name`) desc;
    
-- query #5: select offices, order by the total salary (which includes both office and staff bonuses)
	-- of staff members excluding software specialists
drop table if exists q5_total;
create temporary table q5_total
select Offices.`of_name`, Offices.`of_bonus_amount`, Salary.`sa_salary`, Salary.`sa_bonus_amount`
	from Offices
    join Staff on Offices.`of_id` = Staff.`st_office_id`
    join Salary on Staff.`st_empl_id` = Salary.`sa_employee_id`
		where Staff.`st_position` not in ('Senior Developer', 'Software Engineer', 'QA Specialist', 'Product Manager')
        group by Staff.`st_empl_id`;
select `of_name`, (
		`sa_salary` * (1 + `sa_bonus_amount` + `of_bonus_amount`)
	) as `total_earnings`
	from q5_total
		group by `of_name`
		order by `total_earnings` desc;