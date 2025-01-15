--Lista mijloacelor fixe active într-un inventar dar șterse în sistem

select mf.ID, mf.COD, mf.NUME, mf.VALOARE from MIJLOC_FIX mf
inner join
(
    select distinct mf.Id as id_mijloc_fix from MIJLOC_FIX mf
    inner join MIJLOC_FIX_INVENTAR MFI on mf.ID = MFI.ID_MIJLOC_FIX
    inner join INVENTAR i on i.ID = mfi.ID_INVENTAR and i.sters = 0
) x on x.id_mijloc_fix = mf.ID
INTERSECT
select mf.ID, mf.COD, mf.NUME, mf.VALOARE from MIJLOC_FIX mf
where mf.STERS = 1
