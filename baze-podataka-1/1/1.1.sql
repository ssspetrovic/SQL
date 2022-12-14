SELECT * FROM radnik;
SELECT * FROM projekat;
SELECT * FROM radproj;

SELECT ime, prz
FROM radnik;

SELECT DISTINCT ime
FROM radnik;

SELECT mbr, ime, prz
FROM radnik
WHERE plt > 25000;

SELECT mbr, ime, prz, plt * 12 Godisnja
FROM radnik;

SELECT mbr, ime, prz
FROM radnik
WHERE sef IS NULL;

SELECT mbr, ime, prz, plt
FROM radnik
WHERE plt BETWEEN 20000 AND 24000;

SELECT ime, prz, god
FROM radnik
WHERE god 
BETWEEN '01-jan-1953'
    AND '31-dec-1975';

SELECT ime, prz, god
FROM radnik
WHERE god
    NOT BETWEEN '01-jan-1953'
    AND '31-dec-1975';
    
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%';

SELECT mbr, ime, prz
FROM radnik
WHERE ime NOT LIKE 'A%';

SELECT mbr, ime, prz
FROM radnik
WHERE ime LIKE '_a%';

SELECT DISTINCT ime
FROM radnik
WHERE ime LIKE 'E%';

SELECT ime, prz
FROM radnik
WHERE   prz LIKE '%e%'
    OR  prz LIKE 'E%';
    
SELECT mbr, spr
FROM radproj
WHERE spr IN (10, 20, 30);

SELECT DISTINCT mbr
FROM radproj
WHERE   spr = 10
    OR  brc IN (2, 4, 6);
    
SELECT mbr, ime, prz
FROM radnik
WHERE ime NOT IN ('Ana', 'Sanja');

SELECT mbr, ime, prz
FROM radnik
WHERE sef IS NOT NULL
ORDER BY prz;

SELECT mbr, ime, prz, plt
FROM radnik
ORDER BY plt DESC;

SELECT mbr, ime || ' ' || prz "Ime i prezime", plt * 1.17 Plate
FROM radnik;

SELECT mbr, ime, prz
FROM radnik
WHERE LOWER(prz) LIKE '%' || LOWER(ime) || '%';

SELECT mbr, ime, prz, plt
FROM radnik
WHERE ime = ANY ('Pera', 'Moma');

SELECT mbr, ime, prz, plt
FROM radnik
WHERE ime != ANY  ('Pera', 'Moma');

SELECT mbr, plt + NULL
FROM radnik;

SELECT mbr, ime, prz, plt + pre
FROM radnik;

SELECT mbr, ime, prz, plt + NVL(pre, 0) "Plata sa premijom"
FROM radnik;

SELECT COUNT (*)
FROM radnik;

SELECT COUNT (DISTINCT sef)
FROM radnik;

SELECT MIN(plt) Minimalna, MAX(plt) Maksimalna
FROM radnik;

SELECT COUNT (mbr), SUM(plt) "Suma plata"
FROM radnik;

SELECT COUNT (mbr), ROUND(AVG(plt), 2) "Prosecna plata", 12 * SUM(plt) "Godisnja plata"
FROM radnik;

SELECT ROUND(AVG(plt) * 1.41, 2)
FROM radnik;

SELECT * FROM (
    SELECT mbr, ime
    FROM radnik
);

SELECT mbr, ime, prz, ROWNUM
FROM radnik
WHERE ROWNUM <= 10;

SELECT mbr, ime, prz, plt, ROWNUM
FROM radnik
WHERE ROWNUM <= 10
ORDER BY plt DESC;

-- prvo vrsimo sortiranje prema plati pa tek onda selektujemo 10 redova
SELECT mbr, ime, prz, plt, ROWNUM
FROM (
    SELECT *
    FROM radnik
    ORDER BY plt desc
)
WHERE ROWNUM <= 10;

SELECT mbr, spr
FROM radproj
WHERE mbr < 40;

-- ako hocemo da grupisemo sve projekte na kojima radi odredjeni radnik (jedinstveni mbr)
SELECT mbr, COUNT(spr) "Broj projekata"
FROM radproj
WHERE mbr < 50
GROUP BY mbr;

SELECT spr, COUNT(mbr) "Broj radnika", SUM(brc) "Angazovanje na projektu"
FROM radproj
GROUP BY spr;

SELECT mbr, COUNT(spr) "Broj projekata"
FROM radproj
GROUP BY mbr
HAVING COUNT(spr) > 2
ORDER BY mbr;

SELECT ime, prz, plt,
    (SELECT ROUND(AVG(plt), 2) FROM radnik) AS prosecna_plata,
    ABS((SELECT ROUND(AVG(plt), 2) FROM radnik) - plt) AS razlika
FROM radnik;

SELECT mbr, ime, prz, plt
FROM radnik
WHERE plt > (
    SELECT AVG(plt)
    FROM radnik
)
ORDER BY PLT ASC;

SELECT ime, prz
FROM radnik
WHERE mbr IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 30
);

-- ovaj nacin ne moze jer ne hvata oba uslova odjednom, vec samo prvi
SELECT mbr, ime, prz
FROM radnik
WHERE mbr IN (
    SELECT mbr
    FROM radproj
    WHERE   spr = 10 AND
            spr != 30
);

SELECT mbr, ime, prz
FROM radnik
WHERE mbr IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 10
) AND mbr NOT IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 30
);

SELECT ime, prz, god
FROM radnik
WHERE god = (
    SELECT MIN(GOD)
    FROM radnik
);

SELECT r.mbr, prz, ime, plt, brc, spr
FROM radnik r, radproj rp
WHERE   r.mbr = rp.mbr
AND     rp.spr = 10;