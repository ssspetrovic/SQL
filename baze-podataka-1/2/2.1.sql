SELECT r.mbr, prz, ime, plt, brc
FROM radnik r, radproj rp
WHERE r.mbr = rp.mbr AND spr = 10;

SELECT DISTINCT mbr, ime, prz, plt
FROM radnik, projekat
WHERE mbr = ruk;

SELECT ime, prz, spr, ruk, mbr
FROM radnik, projekat
WHERE spr = 10 AND mbr != ruk;

SELECT ime, prz
FROM radnik
WHERE mbr != (
    SELECT ruk
    FROM projekat
    WHERE spr = 10
);

SELECT nap
FROM projekat
WHERE spr IN (
    SELECT spr
    FROM radproj
    WHERE mbr IN (
        SELECT mbr
        FROM radproj
        WHERE spr = 60
    )
);

SELECT ime, prz, COUNT(spr)
FROM radnik, projekat
WHERE mbr = ruk
GROUP BY mbr, ime, prz;

SELECT r.mbr, prz, ime, SUM(brc)
FROM radnik r, radproj rp
WHERE r.mbr = rp.mbr
GROUP BY r.mbr, prz, ime;

SELECT ime, prz, COUNT(DISTINCT rp.spr) "Broj projekata"
FROM radnik r, projekat p, radproj rp
WHERE r.mbr = ruk AND r.mbr = rp.mbr
GROUP BY r.mbr, ime, prz;
-- ili
SELECT ime, prz, COUNT(rp.spr) bp
FROM radnik r, radproj rp
WHERE r.mbr = rp.mbr
AND r.mbr IN (
    SELECT ruk
    FROM projekat
)
GROUP BY r.mbr, prz, ime;

SELECT nap
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, nap
HAVING SUM(brc) > 15;
-- ili
SELECT nap
FROM projekat
WHERE spr IN (
    SELECT spr
    FROM radproj
    GROUP BY spr
    HAVING SUM(brc) > 15
);

SELECT p.spr, nap
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, nap
HAVING COUNT(mbr) > 2;

SELECT nap, p.spr
FROM projekat p, radproj rp
WHERE p.spr = rp.spr 
GROUP BY p.spr, nap
HAVING AVG(brc) > (
    SELECT AVG(brc)
    FROM radproj
);


-- poredimo prosecnu vrednost svakog projekta 
SELECT nap, p.spr
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, nap
HAVING AVG(brc) >= ALL(
    SELECT AVG(brc)
    FROM radproj
    GROUP BY spr
);

SELECT r1.mbr, r1.ime, r1.prz, r1.plt
FROM radnik r1, radnik r2
WHERE r1.plt > r2.plt
AND r2.mbr = 40;

SELECT DISTINCT r1.mbr, r1.ime, r1.prz, r1.plt
FROM radnik r1, radnik r2, projekat p, radproj rp
WHERE r1.mbr = rp.mbr
AND p.spr = rp.spr
AND r2.mbr = p.ruk
AND r1.plt < 1000 + r2.plt;

SELECT DISTINCT radnik.mbr, ime, prz, plt
FROM radnik, radproj rp1
WHERE radnik.mbr = rp1.mbr
AND rp1.brc > (
    SELECT AVG(brc)
    FROM radproj rp2
    WHERE rp2.spr = rp1.spr
);

SELECT ime, prz
FROM radnik r
WHERE NOT EXISTS (
    SELECT *
    FROM radnik r1
    WHERE r1.god < r.god  -- gde ne postoji radnik koji ima manju godinu rodjenja (stariji)
);

SELECT mbr, ime, prz
FROM radnik
WHERE NOT EXISTS (
    SELECT *
    FROM radproj
    WHERE radproj.mbr = radnik.mbr
    AND radproj.spr = 10
);

SELECT *
FROM radnik r
WHERE NOT EXISTS (
    SELECT *
    FROM radproj rp
    WHERE r.mbr = rp.mbr
);

SELECT r.mbr, r.ime, r.prz
FROM radnik r
WHERE NOT EXISTS (
    SELECT *
    FROM projekat
    WHERE projekat.ruk = r.mbr
);

SELECT DISTINCT mbr, r.ime, r.prz, r.god
FROM radnik r, projekat p
WHERE r.mbr = p.ruk
AND NOT EXISTS (
    SELECT *
    FROM radnik r1
    WHERE r1.god < r.god
);

-- UNION vraca kombinovana resenja iz vise SELECT-a BEZ DUPLIKATA
SELECT r.mbr, r.ime, r.prz
FROM radnik r
WHERE r.mbr IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 20
) UNION (
    SELECT mbr, ime, prz
    FROM radnik
    WHERE plt > ( 
        SELECT AVG(plt)
        FROM radnik
    )
);

-- UNION ALL vraca kombinovana resenja iz vise SELECT-a SA DUPLIKATIMA
SELECT r.mbr, r.ime, r.prz
FROM radnik r
WHERE r.mbr IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 20
) UNION ALL (
    SELECT mbr, ime, prz
    FROM radnik
    WHERE plt > ( 
        SELECT AVG(plt)
        FROM radnik
    )
);

-- INTERSECT vraca samo one podatke iz SELECT-a koji se nalaze u OBA SELECT-a
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%'
OR prz LIKE 'R%'
INTERSECT
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%'
OR prz LIKE 'P%';

-- MINUS vraca rezultate iz prvog SELECT-a koji ne postoje u DRUGOM SELECT-u
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%'
OR prz LIKE 'R%'
MINUS
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%'
OR prz LIKE 'P%';

-- NATURAL JOIN vraca redove iz tabela koje imaju iste vrednosti u kolonama istog naziva
SELECT ime, prz
FROM radnik
NATURAL JOIN radproj
WHERE spr = 30;