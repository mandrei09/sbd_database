insert into Mijloc_fix_inventar(id_inventar, id_mijloc_fix, id_centru_de_cost_initial, id_centru_de_cost_final, cantitate_initiala, cantitate_finala)
select
    5,
    id,
    ID_CENTRU_DE_COST,
    null,
    CAST(VALOARE / 100 + 0.5 as Number(10)),
    null
from mijloc_fix