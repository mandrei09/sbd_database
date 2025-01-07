select * from CENTRU_DE_COST;

update CENTRU_DE_COST set MODIFICAT_LA = sysdate
where id > 7

select * from MIJLOC_FIX_INVENTAR;

update mijloc_fix_inventar set CANTITATE_FINALA = CANTITATE_INITIALA - DBMS_RANDOM.VALUE(1, 10)
where ID_INVENTAR = 1 and ID_MIJLOC_FIX in (13,14)