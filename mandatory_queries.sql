-- Exercise 3.11 (a)
-- Ən azı bir "Comp. Sci." kursu almış tələbələrin ID və adını tapın (təkrarsız)
SELECT DISTINCT s.ID, s.name
FROM student s
JOIN takes t ON s.ID = t.ID
JOIN course c ON t.course_id = c.course_id
WHERE c.dept_name = 'Comp. Sci.';

-- Exercise 3.11 (b)
-- 2017-ci ildən əvvəl təklif olunan heç bir kursu almayan tələbələrin ID və adını tapın
SELECT ID, name
FROM student
WHERE ID NOT IN (
    SELECT ID
    FROM takes
    WHERE year < 2017
);

-- Exercise 3.11 (c)
-- Hər bir departament üzrə müəllimlərin maksimum maaşını tapın
SELECT dept_name, MAX(salary) AS max_salary
FROM instructor
GROUP BY dept_name;

-- Exercise 3.11 (d)
-- Departamentlər üzrə maksimum maaşlar arasından ən aşağı olanı tapın
SELECT MIN(max_salary) AS min_max_salary
FROM (
    SELECT MAX(salary) AS max_salary
    FROM instructor
    GROUP BY dept_name
) AS dept_max_salaries;


-- Exercise 3.15 (a)
-- "Brooklyn"də yerləşən hər bir filialda hesabı olan müştəriləri tapın
SELECT c.customer_name
FROM depositor d
JOIN account a ON d.account_number = a.account_number
JOIN customer c ON d.customer_name = c.customer_name
JOIN branch b ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Brooklyn'
GROUP BY c.customer_name
HAVING COUNT(DISTINCT b.branch_name) = (
    SELECT COUNT(*) 
    FROM branch 
    WHERE branch_city = 'Brooklyn'
);

-- Exercise 3.15 (b)
-- Bankdakı bütün kredit məbləğlərinin ümumi cəmini tapın
SELECT SUM(amount) AS total_loan_amount
FROM loan;

-- Exercise 3.15 (c)
-- "Brooklyn"də yerləşən ən azı bir filialdan daha çox aktivi olan filialların adlarını tapın
SELECT branch_name
FROM branch
WHERE assets > ANY (
    SELECT assets
    FROM branch
    WHERE branch_city = 'Brooklyn'
);


-- Exercise 3.24
-- Physics departamentindəki müəllim tərəfindən məsləhət verilən Accounting tələbələrinin adı və ID-si
SELECT s.ID, s.name
FROM student s
JOIN advisor a ON s.ID = a.s_id
JOIN instructor i ON a.i_id = i.ID
WHERE s.dept_name = 'Accounting'
  AND i.dept_name = 'Physics';


-- Exercise 3.25
-- Büdcəsi Philosophy departamentinin büdcəsindən yüksək olan departamentlərin adları (əlifba sırası ilə)
SELECT dept_name
FROM department
WHERE budget > (
    SELECT budget
    FROM department
    WHERE dept_name = 'Philosophy'
)
ORDER BY dept_name ASC;
