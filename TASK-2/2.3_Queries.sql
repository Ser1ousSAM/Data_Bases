---1)

SELECT s.name as student_name,
    s.surname as student_surname,
    h.name as hobby_name,
    sh.id_student,
    s.id,
    sh.id_hobby,
    h.id

FROM student s,
    student_hobby sh,
    hobby h

WHERE sh.id_student = s.id AND
    sh.id_hobby = h.id


---1)
SELECT s.name, s.surname, h.name as hobby_name
FROM student s
JOIN student_hobby sh ON s.id = sh.id_student
JOIN hobby h ON h.id = sh.id_hobby
WHERE h.name IN (
  SELECT h2.name
  FROM student s2
  JOIN student_hobby sh2 ON s2.id = sh2.id_student
  JOIN hobby h2 ON h2.id = sh2.id_hobby
  WHERE s2.name = 'Gleb' AND s2.surname = 'Valakov'
);

---2)
SELECT s.name, s.surname, h.name AS hobby_name, sh.date_start, sh.date_finish
FROM student s
JOIN student_hobby sh ON s.id = sh.id_student
JOIN hobby h ON h.id = sh.id_hobby
WHERE sh.date_finish = (
    SELECT MAX(date_finish)
    FROM student_hobby
)
AND sh.date_start = (
    SELECT MIN(date_start)
    FROM student_hobby
    WHERE date_finish = (
        SELECT MAX(date_finish)
        FROM student_hobby
    )
)
LIMIT 1;

---3)
SELECT s.name, s.surname, s.n_group, s.date_birth
FROM student s
JOIN student_hobby sh ON s.id = sh.id_student
JOIN hobby h ON h.id = sh.id_hobby
WHERE s.avg_score > (
    SELECT AVG(avg_score)
    FROM student
)
AND (
    SELECT SUM(risk)
    FROM hobby
    WHERE id IN (
        SELECT id_hobby
        FROM student_hobby
        WHERE id_student = s.id
        AND date_start <= NOW() AND (date_finish >= NOW() OR date_finish IS NULL)
    )
) > 0.9;

SELECT *
FROM student_hobby
    
SELECT *
FROM hobby




