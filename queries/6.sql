--Diferentele de cantitate ale produselor si suma acestora pentru inventarele care au data de
-- finalizare in 2 luni fata de data sistemului

select i.nume, mf.NUME,
       abs(mfi.CANTITATE_FINALA - mfi.CANTITATE_INITIALA) as DIFERENTE,
       sum(abs(mfi.CANTITATE_FINALA - mfi.CANTITATE_INITIALA)) over(partition by i.ID) as SUMA_DIFERENTE_PER_INVENTAR
from INVENTAR i
inner join MIJLOC_FIX_INVENTAR mfi on mfi.ID_INVENTAR = i.ID
inner join MIJLOC_FIX mf on mf.ID = mfi.ID_MIJLOC_FIX and mf.STERS = 0 and mfi.STERS = 0
where
    mfi.ID_CENTRU_DE_COST_FINAL is not null
    and mfi.CANTITATE_INITIALA != mfi.CANTITATE_FINALA
    and add_months(sysdate, 2) < i.DATA_FINALIZARE
order by i.NUME, abs(mfi.CANTITATE_FINALA - mfi.CANTITATE_INITIALA) desc