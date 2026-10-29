-- Exercise 3.26
-- Bir kursu ən azı iki dəfə təkrarən götürən (ən azı 3 dəfə dinləmiş) tələbələr
SELECT course_id, ID
FROM takes
GROUP BY course_id, ID
HAVING COUNT(*) >= 3
ORDER BY course_id ASC;

-- Exercise 3.27
-- Ən azı 3 fərqli kursu ən azı bir dəfə təkrarən götürən (ən azı 2 dəfə keçən) tələbələr
SELECT ID
FROM (
    SELECT ID, course_id
    FROM takes
    GROUP BY ID, course_id
    HAVING COUNT(*) >= 2
) AS repeated_courses
GROUP BY ID
HAVING COUNT(course_id) >= 3;

-- Exercise 3.28
-- Öz departamentində tədris olunan bütün kursları tədris edən müəllimlər
SELECT i.ID, i.name
FROM instructor i
WHERE NOT EXISTS (
    SELECT c.course_id
    FROM course c
    WHERE c.dept_name = i.dept_name
    EXCEPT
    SELECT t.course_id
    FROM teaches t
    WHERE t.ID = i.ID
)
ORDER BY i.name ASC;

-- Exercise 3.31
-- Tədris etdiyi heç bir kursda heç vaxt "A" qiyməti verməyən müəllimlər
SELECT i.ID, i.name
FROM instructor i
WHERE i.ID NOT IN (
    SELECT t.ID
    FROM teaches t
    JOIN takes tk ON t.course_id = tk.course_id 
                 AND t.sec_id = tk.sec_id 
                 AND t.semester = tk.semester 
                 AND t.year = tk.year
    WHERE tk.grade = 'A'
);

-- Exercise 3.32
-- Yalnız hər hansı kursda ən azı bir digər qeyri-null qiymət vermiş müəllimlər (A verməyənlər)
SELECT i.ID, i.name
FROM instructor i
WHERE i.ID NOT IN (
    SELECT t.ID
    FROM teaches t
    JOIN takes tk ON t.course_id = tk.course_id 
                 AND t.sec_id = tk.sec_id 
                 AND t.semester = tk.semester 
                 AND t.year = tk.year
    WHERE tk.grade = 'A'
)
AND i.ID IN (
    SELECT t.ID
    FROM teaches t
    JOIN takes tk ON t.course_id = tk.course_id 
                 AND t.sec_id = tk.sec_id 
                 AND t.semester = tk.semester 
                 AND t.year = tk.year
    WHERE tk.grade IS NOT NULL
);

-- Exercise 3.33
-- Günortadan sonra (saat 12:00 və ya daha gec) bitən bölməsi olan "Comp. Sci." kursları
SELECT DISTINCT c.course_id, c.title
FROM course c
JOIN section s ON c.course_id = s.course_id
JOIN time_slot ts ON s.time_slot_id = ts.time_slot_id
WHERE c.dept_name = 'Comp. Sci.'
  AND (ts.end_hr > 12 OR (ts.end_hr = 12 AND ts.end_min > 0));

-- Exercise 3.34
-- Hər bir bölmədəki tələbələrin sayı
SELECT course_id, sec_id, year, semester, COUNT(ID) AS num
FROM takes
GROUP BY course_id, sec_id, year, semester
ORDER BY course_id, sec_id, year, semester;

-- Exercise 3.35
-- Maksimum qeydiyyatı olan bölmə/bölmələr
WITH section_counts AS (
    SELECT course_id, sec_id, year, semester, COUNT(ID) AS num
    FROM takes
    GROUP BY course_id, sec_id, year, semester
)
SELECT course_id, sec_id, year, semester, num
FROM section_counts
WHERE num = (SELECT MAX(num) FROM section_counts);
