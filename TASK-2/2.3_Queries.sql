---1)
SELECT s.name, s.surname, h.name as hobby_name
FROM student s
         JOIN student_hobby sh ON s.id = sh.id_student
         JOIN hobby h ON h.id = sh.id_hobby
WHERE h.name IN (SELECT h2.name
                 FROM student s2
                          JOIN student_hobby sh2 ON s2.id = sh2.id_student
                          JOIN hobby h2 ON h2.id = sh2.id_hobby
                 WHERE s2.name = 'Gleb'
                   AND s2.surname = 'Valakov');

---2)
SELECT s.name, s.surname, h.name AS hobby_name, sh.date_start, sh.date_finish
FROM student s
         JOIN student_hobby sh ON s.id = sh.id_student
         JOIN hobby h ON h.id = sh.id_hobby
WHERE sh.date_finish = (SELECT MAX(date_finish)
                        FROM student_hobby)
  AND sh.date_start = (SELECT MIN(date_start)
                       FROM student_hobby
                       WHERE date_finish = (SELECT MAX(date_finish)
                                            FROM student_hobby))
LIMIT 1;

---3)
SELECT s.name, s.surname, s.id, s.date_birth
FROM student s
         JOIN student_hobby sh ON s.id = sh.id_student
         JOIN hobby h ON h.id = sh.id_hobby
WHERE s.avg_score > (SELECT AVG(avg_score)
                     FROM student)
  AND (SELECT SUM(risk)
       FROM hobby
       WHERE id IN (SELECT id_hobby
                    FROM student_hobby
                    WHERE id_student = s.id
                      AND date_start <= NOW()
                      AND (date_finish >= NOW() OR date_finish IS NULL))) > 0.9;

--4)
SELECT s.surname,
       s.name,
       s.id,
       s.date_birth,
       h.name                                               AS hobby_name,
       12 * extract(year from age(date_finish, date_start)) AS mounths
FROM student s,
     hobby h
         JOIN student_hobby sh ON h.id = sh.id_hobby
WHERE sh.date_finish IS NOT NULL
  AND s.id = sh.id_student;

--5)
SELECT s.surname, s.name, s.id, s.date_birth, age(s.date_birth)
FROM student s,
     (SELECT sh.id_student
      FROM student_hobby sh
      WHERE sh.date_finish IS NULL
      GROUP BY sh.id_student
      HAVING COUNT(*) > 1) as T1
WHERE T1.id_student = s.id
  AND extract(year from age(NOW(), s.date_birth)) > 4;

--6)
SELECT T1.n_group, avg(T1.avg_score)
FROM (SELECT *
      FROM student s,
           student_hobby sh
      WHERE s.id = sh.id_student
        AND sh.date_finish ISNULL) AS T1
GROUP BY T1.n_group;

--7)
SELECT sh.id_student,
       h.name,
       h.risk,
       (12 * extract(year from age(sh.date_start)) + extract(month from age(sh.date_start))) as months
FROM hobby h,
     student_hobby sh
WHERE h.id = sh.id_hobby
  AND sh.date_finish ISNULL
ORDER BY months DESC
LIMIT 1;

--8)
SELECT h.name, T2.name, T2.surname
FROM hobby h,
     student_hobby sh,
     (SELECT *
      FROM student s,
           (SELECT MAX(avg_score) AS f
            FROM student) AS T1
      WHERE s.avg_score = T1.f) AS T2
WHERE sh.id_student = T2.id
  AND sh.id_hobby = h.id;

--9)
SELECT h.name
FROM hobby h,
     student_hobby sh,
     (SELECT *
      FROM student
      WHERE n_group::varchar ILIKE '2%'
        AND avg_score < 3.5
        AND avg_score >= 2.5) AS T1
WHERE sh.id_student = T1.id
  AND sh.id_hobby = h.id
GROUP BY h.name;

--10)
SELECT substr(T1.course2, 1, 1) as course_number
FROM (SELECT substr(s.n_group::varchar, 1, 1) AS course1, count(*) AS count
      FROM student s,
           (SELECT id_student, count(*) AS count
            FROM student_hobby
            WHERE date_finish ISNULL
            GROUP BY id_student) AS T3
      WHERE T3.count > 1
        AND s.id = T3.id_student
      GROUP BY course1) AS T2,
     (SELECT substr(s.n_group::varchar, 1, 1) AS course2, count(*) AS count
      FROM student s
      GROUP BY course2) AS T1
WHERE T1.course2 = T2.course1
  AND T2.count >= T1.count * 0.5;

--11)
SELECT T2.n_group
FROM (SELECT n_group, count(*) AS count
      FROM student s
      WHERE s.avg_score >= 4
      GROUP BY n_group) AS T1,
     (SELECT n_group, count(*) AS count
      FROM student s
      GROUP BY n_group) AS T2
WHERE T2.n_group = T1.n_group
  AND T1.count / 0.6 >= T2.count;

--12)
SELECT T1.course, count(*) AS course
FROM (SELECT substr(s.n_group::varchar, 1, 1) AS course, h.name
      FROM student s,
           student_hobby sh,
           hobby h
      WHERE sh.id_student = s.id
        AND sh.id_hobby = h.id
      GROUP BY course, h.name) AS T1
GROUP BY T1.course;

--13)
SELECT s.id,
       s.name,
       s.surname,
       s.date_birth,
       s.avg_score,
       s.n_group,
       substr(s.n_group::varchar, 1, 1) AS course
FROM student s,
     student_hobby sh,
     hobby h
WHERE sh.id_hobby = h.id
  AND sh.id_student = s.id
  AND sh.date_finish ISNULL
  AND s.avg_score >= 4.5
ORDER BY course, s.date_birth;

--14)
CREATE OR REPLACE VIEW V14 AS
SELECT s.*, extract(year from age(sh.date_start)) AS years
FROM student s,
     student_hobby sh,
     hobby h
WHERE sh.id_hobby = h.id
  AND sh.id_student = s.id
  AND sh.date_finish ISNULL
  AND extract(year from age(sh.date_start)) >= 5;

--15)
SELECT h.name, count(*) AS hobby_name
FROM student_hobby sh
         INNER JOIN hobby h ON h.id = sh.id_hobby
GROUP BY h.name;

--16)
SELECT sh.id_hobby, h.name, count(*) AS human_count
FROM student_hobby sh
         INNER JOIN hobby h on h.id = sh.id_hobby
GROUP BY sh.id_hobby, h.name
ORDER BY human_count DESC
LIMIT 1;

--17)
SELECT s.*
FROM student s
         INNER JOIN student_hobby sh on s.id = sh.id_student
         INNER JOIN (SELECT sh.id_hobby
                     FROM student_hobby sh
                     GROUP BY sh.id_hobby
                     ORDER BY count(*) DESC
                     LIMIT 1) foo ON sh.id_hobby = foo.id_hobby;

--18)
SELECT h.id, h.risk, h.name
FROM hobby h
ORDER BY h.risk DESC
LIMIT 3;

--19)
SELECT s.n_group, s.name, s.surname, h.name, age(sh.date_start) AS years
FROM student s
         INNER JOIN student_hobby sh on s.id = sh.id_student
         INNER JOIN hobby h on h.id = sh.id_hobby
WHERE sh.date_finish ISNULL
ORDER BY years DESC
LIMIT 10;

--20)
SELECT s.n_group
FROM student s
         INNER JOIN (SELECT s.n_group, s.name, s.surname, h.name, age(sh.date_start) AS years
                     FROM student s
                              INNER JOIN student_hobby sh on s.id = sh.id_student
                              INNER JOIN hobby h on h.id = sh.id_hobby
                     WHERE sh.date_finish ISNULL
                     ORDER BY years DESC
                     LIMIT 10) T1 ON s.n_group = T1.n_group
GROUP BY s.n_group;

--21)
CREATE OR REPLACE VIEW V21 AS
SELECT s.id, s.name, s.surname, s.avg_score
FROM student s
ORDER BY s.avg_score;

--22)
CREATE OR REPLACE VIEW V22 AS
WITH T1 AS (SELECT substr(s.n_group::varchar, 1, 1) AS n_course, h.name as h_name, COUNT(*) AS c_students
            FROM student s,
                 student_hobby sh,
                 hobby h
            WHERE s.id = sh.id_student
              AND sh.id_hobby = h.id
            GROUP BY substr(s.n_group::varchar, 1, 1), h.name)
SELECT f2.n_course, T1.h_name, f2.max_c_students
FROM (SELECT n_course, MAX(c_students) AS max_c_students
      FROM T1
      GROUP BY n_course) AS f2,
     T1
WHERE T1.c_students = f2.max_c_students
  AND T1.n_course = f2.n_course;

--23)
CREATE OR REPLACE VIEW V23 AS
WITH T1 AS (SELECT h.id, substr(s.n_group::varchar, 1, 1), COUNT(*)
            FROM student s,
                 student_hobby sh,
                 hobby h
            WHERE substr(s.n_group::varchar, 1, 1) = '2'
              AND s.id = sh.id_student
              AND sh.id_hobby = h.id
            GROUP BY h.id, substr(s.n_group::varchar, 1, 1)
            ORDER BY COUNT(*) DESC),
     T2 AS (SELECT h.name, h.risk
            FROM T1,
                 hobby AS h
            WHERE h.id = T1.id
            ORDER BY h.risk DESC)
SELECT T2.*
FROM (SELECT MAX(T2.risk) AS max_risk
      FROM T2) as T3,
     T2
WHERE T2.risk = T3.max_risk;

--24)
CREATE OR REPLACE VIEW V24 AS
SELECT s.n_group / 1000 as n_course, T1.students_perfect, COUNT(*) AS student_count
FROM student s
         FULL JOIN (SELECT s.n_group / 1000 as course, COUNT(*) AS students_perfect
                    FROM student s
                    WHERE s.avg_score = '5'
                    GROUP BY course) AS T1 ON T1.course = s.n_group / 1000
GROUP BY s.n_group / 1000, T1.students_perfect;

--25)
CREATE OR REPLACE VIEW V25 AS
SELECT h.name, T1.count
FROM hobby h,
     (SELECT sh.id_hobby, COUNT(*) AS count
      FROM student_hobby sh
      GROUP BY sh.id_hobby) as T1
WHERE h.id = T1.id_hobby
  AND T1.count = (SELECT MAX(T2.count)
                  FROM hobby h,
                       (SELECT sh.id_hobby, COUNT(*) AS count
                        FROM student_hobby sh
                        GROUP BY sh.id_hobby) as T2
                  WHERE h.id = T2.id_hobby);

--26)
/* updatable views must satisfy following conditions:
    The view must have exactly one entry in its FROM list, which must be a table or another updatable view.

    The view definition must not contain WITH, DISTINCT, GROUP BY, HAVING, LIMIT, or OFFSET clauses at the top level.

    The view definition must not contain set operations (UNION, INTERSECT or EXCEPT) at the top level.

    All columns in the view's select list must be simple references to columns of the underlying relation. They cannot be expressions, literals or functions. System columns cannot be referenced, either.

    No column of the underlying relation can appear more than once in the view's select list.

    The view must not have the security_barrier property.
*/
--For instance:
CREATE VIEW V26_Updatable AS
SELECT *
FROM student s
WHERE s.avg_score >= 4.5;

--27)
SELECT substr(s.name, 1, 1) AS letter,
       MIN(s.avg_score)     AS min_score,
       AVG(s.avg_score)     AS avg_score,
       MAX(s.avg_score)     AS max_score
FROM student s
WHERE s.avg_score > 3.6
GROUP BY letter;

--28)
SELECT s.n_group / 1000 as couse, s.surname, MAX(s.avg_score), MIN(s.avg_score)
FROM student s
GROUP BY s.surname, s.n_group / 1000;

--29)
SELECT EXTRACT(year FROM s.date_birth)        as year_of_birth,
       COUNT(DISTINCT student_hobby.id_hobby) AS hobby_count
FROM student s
         JOIN student_hobby ON s.id = student_hobby.id_student
GROUP BY year_of_birth;

--30)
SELECT substr(s.name, 1, 1) AS letter,
       MIN(h.risk)          AS min_risk,
       MAX(h.risk)          AS max_risk
FROM student s,
     hobby h,
     student_hobby sh
WHERE sh.id_student = s.id
  AND sh.id_hobby = h.id
GROUP BY letter;

--31)
SELECT EXTRACT(month FROM s.date_birth) as month_of_birth,
       AVG(s.avg_score)
FROM student s,
     hobby h,
     student_hobby sh
WHERE sh.id_student = s.id
  AND sh.id_hobby = h.id
  AND h.name = 'Basketball'
GROUP BY month_of_birth;

--32)
SELECT s.name, s.surname, s.n_group
FROM student s
         JOIN student_hobby ON s.id = student_hobby.id_student;

--33)
SELECT s.surname,
       CASE
           WHEN STRPOS(s.surname, 'ov') = 0
               THEN 'not found'
           ELSE STRPOS(s.surname, 'ov')::text
           END AS idx
FROM student s;

--34)
UPDATE student s
SET surname = RPAD(s.surname, 10, '#')
WHERE LENGTH(s.surname) < 10;

--35)
UPDATE student s
SET surname = REPLACE(s.surname, '#', '');

--36)
SELECT date_part('day', '2018-04-30'::date) AS days_in_april_2018;

--37)
SELECT case
           when date_part('dow', now()) <= 5 then date_trunc('week', now()) + interval '5 days'
           else date_trunc('week', now()) + interval '12 days'
           end AS nearest_saturday;

--38)
SELECT CEIL(EXTRACT(year FROM CURRENT_DATE) / 100.0) as century,
       EXTRACT(week FROM CURRENT_DATE)               as week_number,
       EXTRACT(doy FROM CURRENT_DATE)                as day_of_year;

--39)
SELECT s.name,
       s.surname,
       h.name,
       CASE
           WHEN sh.date_finish IS NULL THEN 'занимается'
           ELSE 'закончил'
           END AS hobby_statement
FROM student s
         JOIN student_hobby sh ON s.id = sh.id_student
         JOIN hobby h ON h.id = sh.id_hobby;
--40)
