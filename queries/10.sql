--Companiile care au inventar dar nu au departamente
select c.COD, c.NUME
from COMPANIE c
inner join INVENTAR i on i.ID_COMPANIE = c.ID
where c.STERS = 0
MINUS
select c.cod, c.nume
from COMPANIE c
right join
(
    select distinct d.ID_COMPANIE
    from DEPARTAMENT d
    where d.STERS = 0
) x on c.ID = x.id_companie
