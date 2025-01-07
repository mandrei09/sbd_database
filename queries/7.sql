--Pierderile financiare pentru inventarul cu data minima de incepere

select
    i.nume, mf.NUME,
    COALESCE(abs(mfi.CANTITATE_FINALA - mfi.CANTITATE_INITIALA), 0) * mf.VALOARE as PIERDERI
from INVENTAR i
inner join MIJLOC_FIX_INVENTAR mfi on mfi.ID_INVENTAR = i.ID
inner join MIJLOC_FIX mf on mf.ID = mfi.ID_MIJLOC_FIX and mf.STERS = 0 and mfi.STERS = 0
where
    mfi.ID_CENTRU_DE_COST_FINAL is not null
    and mfi.CANTITATE_FINALA is not null
    and mfi.CANTITATE_FINALA < MFI.CANTITATE_INITIALA
    and i.DATA_INCEPERE = (select min(i.DATA_INCEPERE) from INVENTAR i)
order by i.NUME, abs(mfi.CANTITATE_FINALA - mfi.CANTITATE_INITIALA) * mf.VALOARE desc