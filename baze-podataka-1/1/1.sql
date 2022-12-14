select * from radnik;
select * from projekat;
select * from radproj;

select ime, prz
  from radnik;
  
select distinct ime from radnik;

select mbr, ime, prz
  from radnik
    where plt > 25000;
    
select mbr, ime, prz, plt*12
  from radnik;
  
--select 1 from radnik;

select mbr, ime, prz
  from radnik
    where sef is null;
    
select mbr, ime, prz, plt
  from radnik
    where plt between 20000 and 24000;
    
select ime, prz, god
  from radnik
    where god between '01-jan-1953' and '31-dec-1975';
    
select ime, prz, god
  from radnik
    where god not between '01-jan-1953' and '31-dec-1975';
    
select mbr, ime, prz
  from radnik
    where prz like 'M%';
    
select mbr, ime, prz
  from radnik
    where ime like '_a%';
    
select distinct mbr
  from radproj
    where spr in (10, 20, 30);
    
select distinct mbr
  from radproj
    where spr = 10 or brc in (2, 4, 6);
    
select ime, prz
  from radnik
    where sef is not null
      order by prz desc;
      
select mbr, ime, prz, plt plata
  from radnik
    order by plata desc;
    
select mbr, ime ||' ' ||prz "Ime i prezime", plt * 1.17 Plata
  from radnik;
  
select mbr, ime, prz, plt
  from radnik
    where ime = any('Pera', 'Moma');
    
select mbr, ime, prz, plt
  from radnik
    where ime != all('Pera', 'Moma');
    
select mbr, plt + NULL Plate
  from radnik;
    
select mbr, plt + pre Plate
  from radnik;
  
select mbr, plt + NVL(pre, 0) "Plate sa premijom"
  from radnik;
  
select count(*) from radnik;

select count(distinct sef) from radnik;

select min(plt) minimalna, max(plt) maksimalna
  from radnik;

select count(*), avg(plt) Plata, 12 fk* sum(plt) Godisnja
  from radnik;
  
select sum(pre) from radnik where mbr > 100;

select round(avg(plt) * 1.41, 2)
  from radnik;
  
select * from(
  select mbr, ime from radnik
);

select mbr, rownum
  from radnik;
  
select mbr, plt, rownum from 
  (select * from radnik order by plt desc)
    where rownum <= 10;
    
select mbr, spr from radproj
  where mbr < 40;
  
select mbr, count(spr) from radproj
  where mbr < 40
    group by mbr;
    
select spr, count(mbr), sum(brc)
  from radproj
    group by spr;

select mbr, count(*) from radproj
    group by mbr
      having count(spr) > 2;
      
select mbr, ime, prz, plt
  from radnik
    where plt > (select avg(plt) from radnik)
      order by plt;

select ime, prz
  from radnik
    where mbr in
      (select mbr from radproj where spr = 30);
      
select mbr, ime, prz
  from radnik
    where mbr in (select mbr from radproj where spr = 10) and mbr not in (select mbr from radproj where spr = 30);
  
select ime, prz, god
  from radnik
    where god = (select min(god) from radnik);

select *
  from radnik, radproj;
  
select radnik.mbr, prz, ime, plt, brc
  from radnik, radproj
    where spr = 10 and
    radnik.mbr = radproj.mbr;