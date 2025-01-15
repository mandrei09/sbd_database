--Obțineți toți angajații care sunt asociați cu toate centrele de cost dintr-o anumită divizie

select a.ID, a.NUME, a.PRENUME, a.EMAIL
from ANGAJAT a
inner join
(
    SELECT DISTINCT ac.id_angajat
    FROM Angajat_Centru_De_Cost ac
    WHERE NOT EXISTS (
        SELECT cc.id
        FROM Centru_de_Cost cc
        inner join DIVIZIE div on div.ID = cc.ID_DIVIZIE and div.STERS = 0
        where div.COD = 'DIV-1'
          AND cc.sters = 0
          AND NOT EXISTS (
              SELECT 1
              FROM Angajat_Centru_De_Cost ac2
              WHERE ac2.id_angajat = ac.id_angajat
                AND ac2.id_centru_de_cost = cc.id
          )
    )
) X on x.ID_ANGAJAT = a.ID

