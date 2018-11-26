#Napisać polecenie wstawiające nowy departament do tabeli DEPT (numer: 111000; nazwa: „IT”; lokalizacja „Lodz”)
INSERT INTO department (deptno, dname, location)
VALUES (111000, 'IT', 'Lodz');
#Dla chętnych można napisać polecenie które na podstawie istniejących departamentów utworzy takie same ale w lokalizacji „Moscow”
INSERT INTO department (deptno, dname, location)
SELECT deptno + 1, dname, 'Moscow'
FROM department
WHERE NOT location = 'Moscow';
#Napisać polecenie aktualizacji danych w tabeli DEPT które zmieni nazwę departamentu Sales na „SPRZEDAZ”
UPDATE department
SET dname = 'SPRZEDAZ'
WHERE dname = 'SALES';
#Napisać polecenie które skasuje wiersz z numerem 111000 z tabeli DEPT
DELETE
FROM department
WHERE deptno = 111000;
#Napisać zapytanie które wyświetli nazwy departamentów rozpoczynające się od litery S
SELECT dname
FROM department
WHERE dname LIKE 'S%';
#Napisać zapytanie które wyświetli listę lokalizacji departamentów. Lista nie powinna zawierać duplikatów (dla chętnych zrobić to na dwa sposoby)
SELECT DISTINCT location
FROM department;
#Napisać zapytanie które wyświetli listę lokalizacji departamentów. Nazwy departamentów powinny być UPPERCASE
SELECT DISTINCT UPPER(location)
FROM department;
#Napisać zapytanie które wyświetli dla każdego managera liczbę oraz sumaryczne zarobki podwładnych
SELECT COUNT(e.empno) as subordinates, SUM(e.sal) as sum, COALESCE(m.ename, 'CEO')
FROM employee e
       LEFT JOIN employee m ON m.empno = e.mgr
GROUP BY m.ename;
-- ----------------------------------------------------------

#Napisać zapytanie które wyświetli nazwiska pracowników których pensja oscyluje między 2000 a 3000 (dla chętnych wykonać to na dwa sposoby)
SELECT ename
FROM employee
WHERE sal BETWEEN 2000 AND 3000;
#Napisać zapytanie które wyświetli nazwiska którzy nie posiadają managera
SELECT ename
FROM employee
WHERE mgr IS NULL;
#Napisać zapytanie które wyświetli nazwiska zatrudnionych w departamencie Sales - nie ma juz SALES jest SPRZEDAZ
SELECT e.ename
FROM employee e
       JOIN department d on e.deptno = d.deptno
WHERE d.dname = 'SPRZEDAZ';
#Napisać zapytanie które wyświetli sumę zarobków per departament. W przypadku gdy departament nie posiada pracowników należy wyświetlić 0. Posortować nazwy departamentów po nazwie
SELECT COALESCE(SUM(e.sal), 0), d.dname
FROM department d
       LEFT JOIN employee e ON d.deptno = e.deptno
GROUP BY d.deptno;
#Napisać zapytanie które zwróci dane postaci <LOKALIZACJA>,<TYP_PRACOWNIKA>,<SUMA ZAROBKÓW>.
SELECT d.location as LOKALIZACJA, e.job as TYP_PRACOWNIKA, SUM(e.sal) as SUMA_ZAROBKOW
FROM employee e
       JOIN department d on d.deptno = e.deptno
GROUP BY e.job, d.location;
-- --------------------------------------------
#Napisać zapytanie które wyświetli nazwiska pracowników zatrudnionych między 01.01.1992  and 01.01.1996
SELECT ename
FROM employee
WHERE hiredate BETWEEN '1992-01-01' AND '1996-01.01';
#Napisać zapytanie które wyświetli nazwy departamentów posortowane od Z do A, w których suma zarobków pracowników jest większa do 5000
SELECT d.dname, SUM(e.sal) as sum
FROM department d
       JOIN employee e ON e.deptno = d.deptno
GROUP BY d.dname
HAVING SUM(e.sal) > 5000
ORDER BY d.dname DESC;
#Wypisz managera który ma najwiecej pracownikow
SELECT m.ename, COUNT(e.empno) as subordinates
FROM employee e
       LEFT JOIN employee m ON m.empno = e.mgr
GROUP BY m.ename
ORDER BY subordinates DESC
LIMIT 1;
#Wypisz pracowników, których zarobki są mniejsze niz ich managera ale wieksze niz jakiegokolwiek managera
SELECT e.ename
FROM employee e
       LEFT JOIN employee m ON m.empno = e.mgr
WHERE e.sal < m.sal
  AND e.sal > (SELECT MIN(mng.sal)
               FROM employee mng
                      INNER JOIN employee emp ON mng.empno = emp.mgr);
#Napisz zapytanie wyświetlające dane 5 najmniej zarabiajacych osob
SELECT ename, job
FROM employee
ORDER BY sal
LIMIT 5;
#Napisz zapytanie wyświetlające dane pracowników ktorych pensja jest wieksza niz managera
SELECT e.ename
FROM employee e
       LEFT JOIN employee m ON m.empno = e.mgr
WHERE e.sal > m.sal;
