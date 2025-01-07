--Situatia scriptic vs faptic in cazul tuturor inventarelor din sistem.


select NUME, DATA_INCEPERE, DATA_FINALIZARE,
       scriptic.numar_mf as SCRIPTIC,
       faptic.numar_mf as FAPTIC
from INVENTAR i
left join
(
    select ID_INVENTAR, count(ID_MIJLOC_FIX) as numar_mf
    from MIJLOC_FIX_INVENTAR
    where ID_CENTRU_DE_COST_INITIAL is not null
    group by ID_INVENTAR
) scriptic on scriptic.ID_INVENTAR = i.ID
left join
(
    select ID_INVENTAR, count(ID_MIJLOC_FIX) as numar_mf
    from MIJLOC_FIX_INVENTAR
    where ID_CENTRU_DE_COST_FINAL is not null
    group by ID_INVENTAR
) faptic on faptic.ID_INVENTAR = i.ID
where i.STERS = 0


