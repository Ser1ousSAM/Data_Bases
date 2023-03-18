--1)
SELECT (s.name, s.surname, s.avg_score)
FROM student s
WHERE avg_score>=4 AND avg_score<=4.5;

--2)
SELECT s.*
FROM student s
WHERE CAST(s.n_group as varchar) LIKE '3022';

/*
--% - любое кол-во символов
--_ - 1 любой символ
ILIKE - insensetive LIKE
*/

--3)
SELECT s.*
FROM student s
ORDER BY s.n_group DESC, s.name;

--4)
SELECT s.*
FROM student s
WHERE s.avg_score > 4
ORDER BY s.avg_score DESC;

--5)
SELECT h.name, h.risk
FROM hobby h
LIMIT 2;

--6)
/*Is DATE is not null by DEFAULT?*/
ALTER TABLE student_hobby
ALTER COLUMN date_start
DROP NOT NULL;

ALTER TABLE student_hobby
ALTER COLUMN date_finish
DROP NOT NULL;

UPDATE student_hobby
SET date_start = '2017-09-20',
    date_finish = NULL
WHERE id_student=5;

SELECT st_h.id_hobby, st_h.id_student
FROM student_hobby st_h
WHERE
st_h.date_start > '2015-09-20' AND st_h.date_finish IS NULL;

/*
IS means '=' for NULL
*/

SELECT st_h.*
FROM student_hobby st_h;

--7)
SELECT s.*
FROM student s
WHERE s.avg_score>=4.5
ORDER BY s.avg_score DESC;

--8)
--using LIMIT here
SELECT s.*
FROM student s
WHERE s.avg_score>=4.5
ORDER BY s.avg_score DESC
LIMIT 2;

--9)
SELECT h.name,
    CASE 
        WHEN h.risk>=8 THEN 'very high'
        WHEN h.risk>=6
            AND h.risk<8 THEN 'high'
        WHEN h.risk>=4 
            AND h.risk<6 THEN 'middle'
        WHEN h.risk>=2
            AND h.risk<4 THEN 'low'
        WHEN h.risk<2 THEN 'very low'
    END
FROM hobby h;

--10)
SELECT h.name, h.risk
FROM hobby h
ORDER BY h.risk DESC
LIMIT 3;