--1)
/*
:: - type conversion
*/
SELECT s.n_group,
    count(*) as count_students
FROM student s
GROUP BY s.n_group;

--2)
SELECT s.n_group, MAX(avg_score) as max_avg_scrore
FROM student s
GROUP BY s.n_group;

--3)
SELECT s.surname, COUNT(*) as count_students
FROM student s
GROUP BY s.surname;

--4)
SELECT EXTRACT(YEAR FROM s.date_birth) as birth_year, COUNT(*) as count_students
FROM student s
GROUP BY birth_year
ORDER BY birth_year;

--5)
SELECT SUBSTR(s.n_group::text,1,1) as course_group, AVG(s.avg_score)::real as average_grade
FROM student s
GROUP BY course_group;

--6)
--For example, course = 2
SELECT SUBSTR(s.n_group::text,1,1) as course_group, s.n_group, AVG(s.avg_score)::real as average_grade
FROM student s
WHERE SUBSTR(s.n_group::text,1,1) = '2'
GROUP BY course_group, s.n_group
ORDER BY average_grade DESC
LIMIT 1;

--7)
--For example, <=4.5
SELECT s.n_group, AVG(s.avg_score)::real as average_grade
FROM student s
GROUP BY s.n_group
HAVING AVG(avg_score) <=4.5
ORDER BY average_grade

--8)
SELECT s.n_group,
    COUNT(*),
    MAX(s.avg_score)::real as max_grade,
    AVG(s.avg_score)::real as average_grade,
    MIN(s.avg_score)::real as min_grade
FROM student s
GROUP BY s.n_group

--9)
UPDATE student
SET avg_score=3.9
WHERE id=6;


SELECT s.*
FROM student s
WHERE s.n_group = 3022 AND s.avg_score = (
    SELECT MAX(s.avg_score)
    FROM student s
    WHERE s.n_group = 3022
)

--10)
SELECT s.*
FROM student s,
    (SELECT s.n_group,
        MAX(s.avg_score) as av
    FROM student s
    GROUP BY n_group) as T
WHERE s.n_group = T.n_group AND s.avg_score = T.av

SELECT s.n_group,
    MAX(s.avg_score)
FROM student s
GROUP BY s.n_group

SELECT *
FROM student s