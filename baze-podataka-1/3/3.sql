SELECT mbr, ime, prz
FROM radnik
WHERE mbr IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 20
)
UNION 
SELECT mbr, ime, prz
FROM radnik
WHERE plt > (
    SELECT AVG(plt)
    FROM radnik
);

SELECT mbr, ime, prz
FROM radnik
WHERE mbr IN (
    SELECT mbr
    FROM radproj
    WHERE spr = 20
)
UNION ALL
SELECT mbr, ime, prz
FROM radnik
WHERE plt > (
    SELECT AVG(plt)
    FROM radnik
);

SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%' OR ime LIKE 'R%'
INTERSECT
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%' OR prz LIKE 'P%';

SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%' OR prz LIKE 'R%'
MINUS
SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%' OR prz LIKE 'P%';

SELECT ime, prz
FROM radnik
NATURAL JOIN radproj
WHERE spr = 30;

-- presek iz tabela preko uslova ON
SELECT ime, prz
FROM radnik r
INNER JOIN radproj rp
ON r.mbr = rp.mbr
WHERE rp.spr = 30;

SELECT mbr, ime, prz, NVL(nap, 'ne rukovodi projektom') rukovodstvo
FROM radnik r
LEFT OUTER JOIN projekat p
ON r.mbr = p.ruk;

SELECT nap, NVL(mbr, 0)
FROM radproj rp
RIGHT OUTER JOIN projekat p
ON rp.spr = p.spr;

SELECT NVL(rp.mbr, 0) "Mbr radnika", nap
FROM radproj rp
FULL OUTER JOIN projekat p
ON rp.spr = p.spr;

SELECT r.mbr, r.prz, r.ime, NVL(rp.spr, 0), NVL(nap, 'Ne postoji') naziv_projekta
FROM radnik r
LEFT OUTER JOIN radproj rp
ON r.mbr = rp.mbr
LEFT OUTER JOIN projekat p
ON p.spr = rp.spr
ORDER BY mbr asc;

SELECT *
FROM radnik, projekat;

SELECT *
FROM radnik
CROSS JOIN projekat;

SELECT mbr, ime, plt,
CASE
    WHEN plt < 10000 
        THEN 'mala primanja'
    WHEN plt >= 10000 AND plt < 20000
        THEN 'srednje visoka primanja'
    WHEN plt >= 20000 AND plt < 40000
        THEN 'visoka primanja'
    ELSE 'izuzetno velika primanja'
END AS visina_primanja
FROM radnik
ORDER BY
CASE visina_primanja
    WHEN 'izuzetno visoka primanja'
        THEN 1
    WHEN 'visoka primanja'
        THEN 2
    WHEN 'srednja primanja'
        THEN 3
    ELSE 4
END desc, plt asc;

SELECT mbr, ime, plt, sef
FROM radnik
ORDER BY
CASE
    WHEN sef IS NULL
        THEN 1
    ELSE 2
END, plt desc;


INSERT INTO radnik (mbr, ime, prz, plt, sef, god)
    VALUES (201, 'Ana', 'Markovic', 30000, null, '18-aug-71');

INSERT INTO projekat (spr, nap, ruk)
    VALUES (90, 'P1', 201);
    
INSERT INTO radproj (mbr, spr, brc)
    VALUES (201, 90, 5);
    
-- primary key constraint violated
INSERT INTO radnik (mbr, ime, prz, plt, sef, god)
    VALUES (201, 'Nikola', 'Markovic', 45000, null, '17-jul-55');

-- cannot insert null
INSERT INTO radnik (mbr, ime, prz, plt, sef, god)
    VALUES (303, null, 'Markovic', 45000, null, '17-jul-55');

-- check constraint violated (plt  < 500)
INSERT INTO radnik (mbr, ime, prz, plt, sef, god)
    VALUES (2101, 'Nikola', 'Markovic', 500, null, '17-jul-55');

-- unique constraint violated (nap)
INSERT INTO projekat (spr, nap, ruk)
    VALUES (10, 'P1', 31);

-- integrity constraint violated - parent key not found
INSERT INTO projekat (spr, nap, ruk)
    VALUES (39, 'P2', 31);

--ROLLBACK;

INSERT INTO radnik (mbr, ime, prz, plt, sef, god)
    VALUES (2101, 'Nikola', 'Markovic', 10000, null, '17-jul-55');
    
DELETE radnik
WHERE mbr = 2101;

UPDATE radnik
SET plt = 340
WHERE mbr = 2101;

-- FAZE_PROJEKTA ({spr, sfp, rukfp, nafp, datp, {spr + sfp})
-- faze_projekta[spr] C projekat[spr]
-- faze_projekta[rukfp] C radnik[mbr]
CREATE TABLE faze_projekta
(
    spr integer NOT NULL,
    sfp integer NOT NULL,
    rukfp integer,
    nafp varchar2(30),
    datp date,
    
    CONSTRAINT faze_projekta_PK PRIMARY KEY (spr, sfp),
    CONSTRAINT faze_projekta_projekat_FK FOREIGN KEY (spr) REFERENCES projekat (spr),
    CONSTRAINT faze_projekta_radnik_FK FOREIGN KEY (rukfp) REFERENCES radnik (mbr),
    CONSTRAINT faze_projekta_UK UNIQUE (nafp)
);

ALTER TABLE faze_projekta
ADD (datz date);

ALTER TABLE faze_projekta
ADD CONSTRAINT faze_projekta_CH CHECK (datz >= datp);

INSERT INTO faze_projekta (spr, sfp, rukfp, nafp, datp)
    VALUES (10, 13, null, 'Faza 1', '28-dec-2021');

UPDATE faze_projekta
SET datz = '29-dec-2020'
WHERE spr = 10;

DROP TABLE faze_projekta;

rollback;