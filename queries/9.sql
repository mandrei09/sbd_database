--Listează toate companiile care au maxim 3 divizii si minim un angajat alocat.


select UPPER(c.nume), z.numar_divizii, x.numar_angajati
from DIVIZIE div
inner join
(
    select ID_DIVIZIE, count(ID_ANGAJAT) as numar_angajati
    from ANGAJAT_CENTRU_DE_COST acc
    inner join CENTRU_DE_COST cc on cc.ID = acc.ID_CENTRU_DE_COST
    inner join DIVIZIE div on div.ID = cc.ID_DIVIZIE
    where acc.STERS = 0
    group by ID_DIVIZIE
) X on X.ID_DIVIZIE = div.ID and X.numar_angajati > 0
inner join
(
    select div.id as id_divizie, c.id as id_companie
    from COMPANIE c
    inner join DEPARTAMENT d on d.ID_COMPANIE = c.ID
    inner join DIVIZIE div on div.ID_DEPARTAMENT = d.ID
) Y ON Y.id_divizie = div.ID
inner join
(
    select c.id as id_companie, count(div.id) as numar_divizii from DIVIZIE div
    inner join DEPARTAMENT d on d.id = div.ID_DEPARTAMENT
    inner join COMPANIE c on c.id = d.ID_COMPANIE
    group by c.id
) Z on z.id_companie = y.id_companie and Z.numar_divizii < 4
INNER JOIN COMPANIE c on c.ID = z.id_companie

-- select *
-- from COMPANIE c
-- inner join DEPARTAMENT d on d.ID_COMPANIE = c.ID
-- inner join DIVIZIE div on div.ID_DEPARTAMENT = d.ID
-- WHERE C.NUME = 'ENDAVA'

