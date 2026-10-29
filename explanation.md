# SQL Tapşırıqlarının İzahı və Təhlili

## 1. Ən çətin hesab etdiyiniz SQL sorğusu hansı oldu?
Mənim üçün ən mürəkkəb və diqqət tələb edən sorğu **Exercise 3.28** oldu. Bu sorğuda müəllimin öz departamentindəki *bütün* kursları tədris edib-etmədiyini yoxlamaq lazımdır. SQL-də hər hansı bir çoxluğun başqa bir çoxluğu tam əhatə etməsini (universal kvantor / relational division) birbaşa ifadə edən operator yoxdur. Bu məntiqi qurmaq üçün `NOT EXISTS` və `EXCEPT` (və ya ikiqat `NOT EXISTS`) strukturundan istifadə etməli oldum. Departamentin bütün kursları çoxluğundan müəllimin tədris etdiyi kursları çıxdıqda geriyə heç nə qalmamalıdır (`EXCEPT` fərqi boş olmalıdır). Bu cür ikili inkar məntiqini düzgün qurmaq analitik təfəkkür taləb edirdi.

## 2. Hansı sorğu üçün alt sorğu (subquery) istifadə etdiniz?
Alt sorğulardan bir neçə tapşırıqda geniş istifadə etdim. Ən bariz nümunə **Exercise 3.11 (d)** tapşırığıdır. 
Bu sorğuda əvvəlcə hər bir departament üzrə maksimum maaşları tapmaq üçün bir daxili alt sorğu (`FROM` hissəsində subquery) yazıldı:
```sql
(SELECT MAX(salary) AS max_salary FROM instructor GROUP BY dept_name) AS dept_max_salaries
