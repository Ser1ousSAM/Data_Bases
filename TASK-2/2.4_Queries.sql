--1)
DELETE
FROM student
WHERE date_birth IS NULL;

--2)
UPDATE student
SET date_birth = '01-01-1999'
WHERE date_birth IS NULL;

--3)
DELETE
FROM student
WHERE id = 21;


--4)
UPDATE hobby
SET risk = risk - 0.1
WHERE risk > 0.1
  and id = (SELECT h.id
            FROM hobby h
            ORDER BY h.risk DESC
            LIMIT 1);

--5)
UPDATE student
SET score = score + 0.01
WHERE id IN (SELECT sh.student_id
             FROM student_hobby sh
             WHERE sh.hobby_id IN (SELECT id
                                   FROM hobby));

--6)
DELETE
FROM student_hobby
WHERE date_finish IS NOT NULL;

--7)
INSERT INTO student_hobby (student_id, hobby_id, date_start, date_finish)
VALUES (4, 5, '2009-11-15', null);

--8)
DELETE
FROM student_hobby
WHERE id in (SELECT id
             FROM student_hobby as sh,
                  (SELECT hobby_id, student_id, min(date_start) AS m_d
                   FROM student_hobby
                   GROUP BY hobby_id, student_id
                   HAVING count(*) > 1) AS last_times
             WHERE sh.hobby_id = last_times.hobby_id
               AND sh.student_id = last_times.student_id
               AND sh.date_start = last_times.m_d);

--9)
INSERT INTO hobby (name, risk)
VALUES ('бальные танцы', 0.5);

INSERT INTO hobby (name, risk)
VALUES ('вышивание крестиком', 0.3);

UPDATE student_hobby
SET hobby_id = CASE
                   WHEN hobby_id = 3
                       THEN 10
                   WHEN hobby_id = 1
                       THEN 9
                   ELSE hobby_id
    END;

SELECT s.name, s.surname, sh.hobby_id, h.name
from student s
         JOIN student_hobby sh on s.id = sh.student_id
         JOIN hobby h on sh.hobby_id = h.id;

--10)
INSERT INTO hobby (name, risk)
VALUES ('учёба', 0.2);

--11)
--Можно ли в одном запросе, если нет хобби, то добавить?

UPDATE student_hobby
SET hobby_id = 11
WHERE student_id in (select s.id from student s where score < 3.2)
  and date_finish is null;

INSERT INTO student_hobby(student_id, hobby_id, date_start)
SELECT s.id, 11 AS id_h, now() AS now
from student AS s
         LEFT JOIN student_hobby sh on s.id = sh.student_id
WHERE score < 3.2
GROUP BY s.id, id_h, now;

--12)
UPDATE student
SET n_group = n_group + 1000
WHERE n_group / 1000 < 4;

--13) 0_o -> 3 the same
DELETE
FROM student
WHERE id = 2;

--14)
UPDATE student
SET score = 5.00
WHERE student.id IN (SELECT DISTINCT s.id
                     FROM student s
                              JOIN student_hobby sh ON s.id = sh.student_id
                              JOIN hobby h ON sh.hobby_id = h.id
                     WHERE EXTRACT(YEAR FROM age(now(), date_start)) >= 10);

--15)
DELETE
FROM student_hobby
WHERE student_id IN (SELECT s.id
                     FROM student s
                              JOIN student_hobby sh ON s.id = sh.student_id
                     WHERE sh.date_start < s.date_birth);
