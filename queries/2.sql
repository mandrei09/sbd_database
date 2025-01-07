--Lista centrelor de cost care au fost modificate de la prima introducere in sistem, împreună cu numărul de mijloace fixe atribuite.

select cc.cod, cc.nume, cc.MODIFICAT_LA, x.CountMF as NumarMF
from centru_de_cost cc
inner join
(
    select ID_CENTRU_DE_COST, count(*) as CountMF
    from MIJLOC_FIX
    where STERS = 0
    group by ID_CENTRU_DE_COST
) X on X.ID_CENTRU_DE_COST = cc.ID
where (cc.CREAT_LA is not null and cc.MODIFICAT_LA is not null)
  and cc.MODIFICAT_LA > cc.CREAT_LA