--Top 3 manageri cu cele mai multe mijloace fixe înregistrate dupa 2017.

select
    a.EMAIL as email_angajat,
    COALESCE(COMP.numar_mf, DEP.numar_mf, DIV.numar_mf, CC.numar_mf, 0) as numar_mf
from ANGAJAT a
left join
(
    select a.id as id_angajat, count(mf.ID) as numar_mf
    from Angajat a
    inner join Companie c on c.ID_MANAGER = a.ID and a.STERS = 0
    full join DEPARTAMENT d on d.ID_COMPANIE = c.ID
    full join DIVIZIE div on div.ID_DEPARTAMENT = d.ID and div.STERS = 0
    full join CENTRU_DE_COST cc on cc.ID_DIVIZIE = div.ID and cc.STERS = 0
    full join MIJLOC_FIX mf on mf.ID_CENTRU_DE_COST = cc.ID and mf.STERS = 0
    where mf.DATA_ACHIZITIONARE > TO_DATE('01-JAN-2017', 'DD-MON-YYYY')
    group by a.id
    having a.id is not null
) comp on comp.id_angajat = a.ID
left join
(
    select a.id as id_angajat, count(mf.ID) as numar_mf
    from Angajat a
    inner join DEPARTAMENT d on d.ID_MANAGER = a.ID
    full join DIVIZIE div on div.ID_DEPARTAMENT = d.ID and div.STERS = 0
    full join CENTRU_DE_COST cc on cc.ID_DIVIZIE = div.ID and cc.STERS = 0
    full join MIJLOC_FIX mf on mf.ID_CENTRU_DE_COST = cc.ID and mf.STERS = 0
    where mf.DATA_ACHIZITIONARE > TO_DATE('01-JAN-2017', 'DD-MON-YYYY')
    group by a.id
    having a.id is not null
) dep on dep.id_angajat = a.ID
left join
(
    select a.id as id_angajat, count(mf.ID) as numar_mf
    from Angajat a
    inner join DIVIZIE div on div.ID_MANAGER = a.ID and div.STERS = 0
    full join CENTRU_DE_COST cc on cc.ID_DIVIZIE = div.ID and cc.STERS = 0
    full join MIJLOC_FIX mf on mf.ID_CENTRU_DE_COST = cc.ID and mf.STERS = 0
    where mf.DATA_ACHIZITIONARE > TO_DATE('01-JAN-2017', 'DD-MON-YYYY')
    group by a.id
    having a.id is not null
) div on div.id_angajat = a.ID
left join
(
    select a.id as id_angajat, count(mf.ID) as numar_mf
    from Angajat a
    inner join CENTRU_DE_COST cc on cc.ID_MANAGER = a.ID and cc.STERS = 0
    full join MIJLOC_FIX mf on mf.ID_CENTRU_DE_COST = cc.ID and mf.STERS = 0
    where mf.DATA_ACHIZITIONARE > TO_DATE('01-JAN-2017', 'DD-MON-YYYY')
    group by a.id
    having a.id is not null
) cc on cc.id_angajat = a.ID
order by COALESCE(COMP.numar_mf, DEP.numar_mf, DIV.numar_mf, CC.numar_mf, 0) desc
fetch next 3 rows only;