# SQL Tapşırıqlarının İzahı və Təhlili

## 1. Ən çətin hesab etdiyiniz SQL sorğusu hansı oldu?
Mənim üçün ən mürəkkəb və analitik düşüncə tələb edən sorğu **Exercise 3.28** oldu. Bu sorğuda müəllimin öz departamentində tədris olunan *bütün* kursları tədris edib-etmədiyini yoxlamaq lazımdır. SQL dilində bir çoxluğun başqa bir çoxluğu tam əhatə etməsini (relational division məntiqini) birbaşa ifadə edən vahid bir operator yoxdur. 

Bu məntiqi qurmaq üçün `NOT EXISTS` və `EXCEPT` (və ya ikiqat `NOT EXISTS`) strukturundan istifadə etmək lazımdır. Yəni, müəllimin aid olduğu departamentin bütün kurslar çoxluğundan həmin müəllimin faktiki tədris etdiyi kurslar çıxıldıqda (`EXCEPT`), geriyə heç bir kurs qalmamalıdır (`NOT EXISTS`). Bu cür mürəkkəb çoxluq fərqi və ikili inkar məntiqini düzgün zəncirləmək sorğunun qurulmasında ən çox vaxt aparan hissə oldu.

## 2. Hansı sorğu üçün alt sorğu (subquery) istifadə etdiniz?
Alt sorğulardan (subqueries) tapşırığın bir çox mərhələsində effektiv şəkildə istifadə etdim:

- **Exercise 3.11 (b):** 2017-ci ildən əvvəl kurs almayan tələbələri tapmaq üçün `WHERE ID NOT IN (SELECT ID FROM takes WHERE year < 2017)` şəklində alt sorğu tətbiq olundu.
- **Exercise 3.11 (d):** Departamentlər üzrə maksimum maaşlar arasından ən kiçiyini tapmaq üçün `FROM` hissəsində alt sorğudan (derived table) istifadə edildi. Əvvəlcə daxili sorğu hər departamentin maks maaşını hesablayır, xarici sorğu isə həmin nəticələrdən minimumu seçir.
- **Exercise 3.25:** `WHERE budget > (SELECT budget FROM department WHERE dept_name = 'Philosophy')` şərtində skalyar (tək dəyər qaytaran) alt sorğudan istifadə edərək Fəlsəfə departamentinin büdcəsi dinamik şəkildə müqayisə edildi.
- **Exercise 3.35:** Maksimum tələbə qeydiyyatı olan bölməni taparkən `WITH` (CTE) bloku daxilində `WHERE num = (SELECT MAX(num) FROM section_counts)` alt sorğusundan istifadə olundu.

## 3. JOIN istifadə etdiyiniz bir nümunəni izah edin.
JOIN əməliyyatına əsas nümunə olaraq **Exercise 3.24** tapşırığını göstərə bilərəm. Bu sorğuda Physics (Fizika) departamentindəki müəllim tərəfindən məsləhət (advising) verilən Accounting (Mühasibatlıq) tələbələrinin adını və ID-sini tapmaq tələb olunurdu.

Bu məsələni həll etmək üçün 3 müxtəlif cədvəl `JOIN` vasitəsilə əlaqələndirildi:
1. `student` (s): Tələbənin məlumatlarını və departamentini saxlayır.
2. `adv
3. isor` (a): Tələbə ID-si (`s_id`) ilə ona təyin olunmuş müəllim ID-sini (`i_id`) bir-birinə bağlayır.
4. `instructor` (i): Məsləhətçi müəllimin məlumatlarını və departamentini saxlayır.

```sql
SELECT s.ID, s.name
FROM student s
JOIN advisor a ON s.ID = a.s_id
JOIN instructor i ON a.i_id = i.ID
WHERE s.dept_name = 'Accounting'
  AND i.dept_name = 'Physics';

##4. SQL sorğularını yazarkən qarşılaşdığınız bir problemi və onun həllini izah edin.
Sorğuları hazırlayarkən qarşılaşdığım əsas problemlərdən biri Exercise 3.33 tapşırığında vaxt formatlarının filtrasiyası zamanı ortaya çıxdı. Məqsəd günortadan sonra (saat 12:00 və ya daha gec) bitən bölməsi olan "Comp. Sci." kurslarını tapmaq idi.

İlk cəhddə time_slot cədvəlində end_hr >= 12 şərtini yazdım. Lakin bu zaman saat tam 12:00-da bitən (yəni günortadan sonra davam etməyən) dərslər də səhvən nəticəyə daxil olurdu. Məsələni həll etmək üçün həm saat (end_hr), həm də dəqiqə (end_min) sütunlarını birlikdə nəzərə alan mürəkkəb məntiqi şərt qurmalı oldum.

Həll yolu: Şərtı aşağıdakı kimi dəqiqləşdirdim:
(ts.end_hr > 12 OR (ts.end_hr = 12 AND ts.end_min > 0))
