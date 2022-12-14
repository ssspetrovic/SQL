CREATE TABLE faze_projekta
(
    sfp INTEGER NOT NULL,
    spr INTEGER NOT NULL,
    rukfp integer,
    nafp VARCHAR2(30),
    datp DATE,
    CONSTRAINT FAZE_PROJEKTA_PK PRIMARY KEY (spr, sfp),
    CONSTRAINT FAZE_PROJEKTA_PROJEKAT_FK FOREIGN KEY (spr)
        REFERENCES projekat (spr),
    CONSTRAINT FAZE_PROJEKTA_FK_RADNIK_FK FOREIGN KEY (rukfp)
        REFERENCES radnik (mbr),
    CONSTRAINT FAZE_PROJEKTA_UK UNIQUE (nafp)
);

ALTER TABLE faze_projekta
ADD datz DATE;

ALTER TABLE faze_projekta
ADD CONSTRAINT FAZE_PROJEKTA_CH CHECK (datz > datp);

DELETE FAZE_PROJEKTA;    
DROP TABLE faze_projekta;

INSERT INTO faze_projekta (sfp, spr, rukfp, nafp, datp, datz)
    VALUES (1, 30, 80, 'Prva faza', '13-JUN-2020', '12-JUN-2021');

INSERT INTO faze_projekta (sfp, spr, rukfp, nafp, datp, datz)
    VALUES (2, 30, 90, 'Druga faza', '15-JUL-2021', '20-AUG-2021');
    
INSERT INTO faze_projekta (sfp, spr, rukfp, nafp, datp, datz)
    VALUES (3, 80, 40, 'Faza X', '28-DEC-2020', '10-JUN-2021');
    
SELECT p.spr, p.nap, r.ime AS ruk_ime, r.prz AS ruk_prz, r.sef AS sef, NVL(fp.nafp, 'nema faze') AS faza, NVL(r2.ime, '-') AS rukfp_ime, NVL(r2.prz, '-') AS rukfp_prz
FROM projekat p
LEFT OUTER JOIN radnik r
ON r.mbr = p.ruk
LEFT OUTER JOIN faze_projekta fp
ON fp.spr = p.spr
LEFT OUTER JOIN radnik r2
ON fp.rukfp = r2.mbr;

ROLLBACK;
DROP TABLE faze_projekta;

WITH projinfo AS (
    SELECT rp.spr, COUNT(MBR) AS rp_br
    FROM radproj rp
    GROUP BY rp.spr
)
SELECT r.mbr, r.prz, r.ime, rp.spr, pi.rp_br - 1
FROM radnik r, radproj rp, projinfo pi
WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;

WITH projinfo AS (
    SELECT spr, SUM(brc) AS brc_suma
    FROM radproj
    GROUP BY spr
)
SELECT r.mbr, r.ime, rp.spr, ROUND((rp.brc / brc_suma), 2) AS udeo
FROM radnik r, radproj rp, projinfo pi
WHERE r.mbr = rp.mbr AND rp.spr = pi.spr;

WITH projinfo AS (
    SELECT spr, AVG(brc) pi_prosek
    FROM radproj
    GROUP BY spr
)
SELECT DISTINCT r.mbr, r.ime, r.prz, r.plt
FROM radnik r, radproj rp, projinfo pi
WHERE   r.mbr = rp.mbr
AND     rp.spr = pi.spr
AND     rp.brc > pi.pi_prosek;
-- ILI
with projinfo as (
select spr, avg(brc) prosek
from radproj group by spr)
select distinct r.mbr, r.ime, r.prz, r.plt
from radnik r, radproj rp, projinfo pi
where r.mbr=rp.mbr and rp.spr=pi.spr
group by r.mbr, r.ime, r.prz, r.plt, pi.spr
having avg(rp.brc)>(select prosek from projinfo pi2
where pi2.spr=pi.spr);

WITH projinfo AS (
    SELECT spr, AVG(brc) AS prosek
    FROM radproj
    GROUP BY spr
)
SELECT DISTINCT r.mbr, r.ime, r.prz, r.plt
FROM radnik r, radproj rp, projinfo pi
WHERE r.mbr = rp.mbr
AND rp.spr = pi.spr
AND rp.brc > (
    SELECT AVG(prosek)
    FROM projinfo
);

WITH rukovodilac AS (
    SELECT mbr, ime, prz, spr
    FROM radnik, projekat
    WHERE radnik.mbr = projekat.ruk
),
    projinfo AS (
    SELECT spr, COUNT(mbr) AS br_radnika
    FROM radproj
    GROUP BY spr
)
SELECT ru.mbr, ru.ime, ru.prz, SUM(pi.br_radnika)
FROM rukovodilac ru, projinfo pi
WHERE ru.spr = pi.spr
GROUP BY ru.mbr, ru.ime, ru.prz;

with angaz_po_radnicima (mbr, sbrc) as (
select r.mbr, nvl(sum(rp.brc), 0)
from radnik r, radproj rp
where r.mbr = rp.mbr (+)
group by r.mbr),
angaz_sefova (mbr, prz, ime, brrad, brsat) as (
select distinct r.sef, r1.prz, r1.ime, count(*), a.sbrc
from radnik r, radnik r1, angaz_po_radnicima a
where r.Sef = r1.Mbr and r.Sef = a.Mbr
group by r.Sef, r1.Prz, r1.Ime, a.SBrc)
select sum(brsat) as ukangsef
from angaz_sefova;

CREATE OR REPLACE VIEW
plate_radnika (ime, prezime, plata) AS (
    SELECT ime, prz, plt
    FROM radnik
);

CREATE OR REPLACE VIEW
angazovanje_radnika (mbr, ukupan_broj_sati) AS (
    SELECT r.mbr, NVL(SUM(rp.brc), 0)
    FROM radnik r, radproj rp
    WHERE r.mbr = rp.mbr (+)
    GROUP BY r.mbr
);

CREATE OR REPLACE VIEW
angaz_sefova (mbr, prz, ime, br_radnika, br_casova) AS (
    SELECT r.sef, r1.prz, r1.ime, COUNT(*), ar.ukupan_broj_sati
    FROM radnik r, radnik r1, angazovanje_radnika ar
    WHERE r.sef = r1.mbr
    AND r.sef = ar.mbr
    GROUP BY r.sef, r1.prz, r1.ime, ar.ukupan_broj_sati
);