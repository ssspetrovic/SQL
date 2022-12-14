SELECT radnik.mbr, prz, ime, plt, brc
FROM radnik, radproj
WHERE spr = 10 AND
radnik.mbr = radproj.mbr;

SELECT DISTINCT mbr, ime, prz, plt
FROM radnik, projekat
WHERE ruk = mbr;

SELECT DISTINCT mbr, ime, prz, spr
FROM radnik, projekat
WHERE projekat.spr = 10 AND radnik.mbr != projekat.ruk;

SELECT mbr, ime, prz
FROM radnik
WHERE mbr != (SELECT ruk FROM projekat WHERE spr = 10);

SELECT nap
FROM projekat p
WHERE spr IN (SELECT spr FROM radproj WHERE mbr IN
(SELECT mbr FROM radproj WHERE spr = 60));

--SELECT prz, ime, COUNT(spr)
--FROM radnik r, projekat p
--WHERE ruk = mbr
--GROUP BY mbr, prz, ime;

SELECT r.mbr, prz, ime, COUNT(*), SUM(rp.brc)
FROM radnik r, radproj rp
WHERE r.mbr = rp.mbr
group by r.mbr, prz, ime;

SELECT mbr, ime, prz, COUNT(*)
FROM radnik r, projekat p
WHERE r.mbr = p.ruk
group by r.mbr, ime, prz;

SELECT ime, prz, COUNT(rp.spr) bp
FROM radnik r, radproj rp
WHERE r.mbr = rp.mbr AND
r.mbr in (SELECT ruk FROM projekat)
GROUP BY r.mbr, prz, ime;

SELECT ime, prz, COUNT(distinct rp.spr)
FROM radnik r, projekat p, radproj rp
WHERE rp.mbr = r.mbr AND p.ruk = r.mbr
GROUP BY r.mbr, ime, prz;

SELECT nap
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, nap
HAVING SUM(brc) > 15;

SELECT p.spr, nap
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, p.nap
HAVING COUNT(rp.mbr) > 2;

SELECT nap, p.spr
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, p.nap
HAVING AVG(brc) > (SELECT AVG(brc) FROM radproj);

SELECT nap, p.spr
FROM projekat p, radproj rp
WHERE p.spr = rp.spr
GROUP BY p.spr, p.nap
HAVING AVG(brc) >= ALL(SELECT AVG(brc) FROM radproj GROUP BY spr);

SELECT r1.mbr, r1.ime, r1.prz, r1.plt
FROM radnik r1, radnik r2
WHERE r1.plt > r2.plt AND r2.mbr = 40;

SELECT r1.ime, r1.prz, r1.plt
FROM radnik r1, radnik r2, projekat p, radproj rp
WHERE r1.mbr = rp.mbr
  AND rp.spr = p.spr
  AND p.ruk = r2.mbr
  AND r1.plt + 1000 < r2.plt;
  
SELECT r.mbr, ime, prz, plt, brc
FROM radnik r, radproj rp1
WHERE r.mbr = rp1.mbr
  AND rp1.brc > (SELECT AVG(brc) FROM radproj rp2 WHERE rp2.spr = rp1.spr);
  
SELECT ime, prz, god
FROM radnik r
WHERE NOT EXISTS
(SELECT mbr FROM radnik r1 WHERE r1.god < r.god);

SELECT r.mbr, ime, prz
FROM radnik r
WHERE NOT EXISTS
(SELECT * FROM radproj rp WHERE r.mbr = rp.mbr and rp.spr = 10);

SELECT mbr, ime, prz
FROM radnik r
WHERE NOT EXISTS
(SELECT * from radproj rp WHERE r.mbr = rp.mbr);

SELECT mbr, ime, prz
FROM radnik r
WHERE NOT EXISTS
  (SELECT * from projekat p WHERE r.mbr = p.ruk);

SELECT DISTINCT mbr, ime, prz, god
FROM radnik r, projekat p
WHERE r.mbr = p.ruk AND NOT EXISTS
  (SELECT mbr from radnik r1, projekat p1
    WHERE r1.mbr = p1.ruk
      AND r1.god > r.god);
      
SELECT mbr, ime, prz
FROM radnik
WHERE mbr IN 
  (SELECT mbr FROM radproj WHERE spr = 20)
  UNION ALL
  (SELECT mbr, ime, prz FROM radnik
    WHERE plt > (SELECT AVG(plt) FROM radnik));
    
SELECT mbr, ime, prz FROM radnik
  WHERE prz LIKE 'M%' OR prz LIKE 'R%'
INTERSECT
SELECT mbr, ime, prz FROM radnik
  WHERE prz like 'M%'OR prz LIKE 'P%';

SELECT mbr, ime, prz
FROM radnik
WHERE prz LIKE 'M%' OR prz LIKE 'R%'
  MINUS
SELECT mbr, ime, prz FROM radnik
  WHERE prz LIKE 'M%' OR prz LIKE 'P%';
  
SELECT ime, prz
FROM radnik NATURAL JOIN radproj
WHERE spr = 30;