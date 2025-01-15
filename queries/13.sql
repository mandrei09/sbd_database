--Sa se afiseze toate inventarele care au fost adaugate in db in mod gresit, alaturi de o codalitate de contact pentru managerul companiei
--pentru care se face invetarul.

--Nereguli:
--Data de finalizare < data de incepere sau oricare dintre ele nu este introdusa
--Durata de executie a inventarului depaseste 2 saptamani
--Niciun mijlloc fix asignat pe invetar

select  i.COD, i.NUME, c.NUME as nume_companie, a.EMAIL as email_manager, 'Eroare la data de incepere sau cea de finalizare a inventarului!' as cauza
from INVENTAR i
inner join COMPANIE c on i.ID_COMPANIE = c.ID
inner join ANGAJAT a on a.ID = c.ID_MANAGER
where (DATA_INCEPERE is null) or (DATA_FINALIZARE is null) or (DATA_FINALIZARE < DATA_INCEPERE) or (DATA_FINALIZARE - DATA_INCEPERE > 14)
union  all
select  i.COD, i.NUME, c.NUME as nume_companie, a.EMAIL as email_manager, 'Nu exista niciun mijloc fix in inventar!' as cauza
from INVENTAR i
inner join COMPANIE c on i.ID_COMPANIE = c.ID
inner join ANGAJAT a on a.ID = c.ID_MANAGER
left join
(
    select i.id, count(*) as numar_mf
    from INVENTAR i
    inner join MIJLOC_FIX_INVENTAR mfi on mfi.ID_INVENTAR = i.ID
    where mfi.STERS = 0
    group by i.id
) x on x.ID = i.ID
where x.ID is null

