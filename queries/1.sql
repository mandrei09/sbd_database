--Top 5 departamente cu cele mai multe mijloace fixe șterse.

select d.COD, d.NUME, count(*) as Numar_mijloace_fixe_sterse
from DEPARTAMENT d
inner join DIVIZIE div on div.ID_DEPARTAMENT = d.ID and div.STERS = 0
inner join CENTRU_DE_COST cc on cc.ID_DIVIZIE = div.ID and cc.STERS = 0
inner join MIJLOC_FIX mf on mf.ID_CENTRU_DE_COST = cc.ID and mf.STERS = 1
where d.STERS = 0
group by d.COD, d.NUME
order by count(*) desc
FETCH FIRST 5 ROWS ONLY;
