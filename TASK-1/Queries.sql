---BEGIN CREATE
CREATE TABLE student (
    id serial PRIMARY KEY NOT NULL,
    name varchar(255),
    surname varchar(255)
    n_group integer NOT NULL,
    date_birth date,
    city varchar(255),
    email varchar(100),
    avg_score float;
);

CREATE TABLE student_hobby (
    id serial FOREIGN KEY NOT NULL,
    id_student integer REFERENCES student (id) NOT NULL,
    id_hobby integer REFERENCES hobby (id),
    date_start date,
    date_finish date;
);

CREATE TABLE hobby (
    id serial FOREIGN KEY NOT NULL,
    name varchar(255),
    risk integer;
);

---END CREATE

---BEGIN INSERT
INSERT INTO student
VALUES (1, 'Valera', 'Borov', 2201, '2000-09-01', 'Moscow', NULL, 4.1),
       (2, 'Denis', 'Dirov', 2202, '2000-09-01', 'Sochi', NULL, 4.8),
       (3, 'Gleb', 'Valakov', 2203, '2000-09-01', 'Kostroma', NULL, 3.8),
       (4, 'Jorgh', 'Bush', 2201, '2000-09-01', 'Washington', NULL, 4.5),
       (5, 'Egor', 'Cheremov', 3020, '2000-09-01', 'Gelenjik', NULL, 4.2),
       (6, 'Egor', 'Cheremov', 3020, '2000-09-01', 'Gelenjik', NULL, 4.2),
       (7, 'Yan', 'Vishnev', 3022, '2002-09-01', 'Astana', NULL, 3.6),
       (8, 'Vasya', 'Pupkin', 3022, '2000-08-02', 'Kaliningrad', NULL, 3.4),
       (9, 'Nickolay', 'Sobolev', 3020, '2001-07-04', 'Voronegh', NULL, 5.0),
       (10, 'Stasyan', 'Ziganshin', 3020, '2001-06-03', 'Harkov', NULL, 4.3),
       (11, 'Kirill', 'Vagnerov', 3022, '2002-10-10', 'Kiev', NULL, 3.9);

INSERT INTO student_hobby (id_student, id_hobby, date_start, date_finish)
VALUES (1, 1, '2010-09-01', '2012-09-01'),
       (2, 2, '2009-02-03', '2011-09-01'),
       (3, 4, '2007-08-04', '2010-09-01'),
       (4, 3, '2022-01-05', '2023-09-01'),
       (5, 2, '2019-02-06', '2021-09-01'),
       (6, 3, '2015-03-07', '2018-09-01'),
       (7, 4, '2014-04-08', '2017-09-01'),
       (8, 1, '2017-05-09', '2019-09-01'),
       (9, 2, '2020-07-01', '2022-09-01'),
       (10, 4, '2010-07-10', '2015-09-01'),
       (11, 1, '2013-08-21', '2019-09-01');

---END INSERT

DELETE
FROM student_hobby
WHERE id_student=1;

UPDATE student
SET name='Egor',
    surname='Anisimov',
    n_group=2201,
    date_birth='2000-09-01',
    city='Vladivostok',
    email=NULL,
    avg_score=4.7
WHERE id=5;


SELECT *
FROM student
ORDER BY id;



