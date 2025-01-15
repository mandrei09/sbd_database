--Sa se estimeze valoarea fiecarei companii, in raportul cu mijloacele fixe detinute.
--Estimari:
--Sub 10000 - MIC
--Intre 10000 si 20000 - MEDIU
--Peste 20000 - MARE

SELECT
    C.COD, C.NUME,
    CASE
        WHEN X.valoare_companie < 10000 THEN 'MIC'
        WHEN X.valoare_companie >= 10000 AND  X.valoare_companie < 20000 THEN 'MEDIU'
        ELSE 'MARE'
    END AS Clasificare
FROM COMPANIE C
INNER JOIN
(
    SELECT C.ID AS id_companie, NVL(SUM(MF.VALOARE), 0) as valoare_companie
    from COMPANIE c
    full join DEPARTAMENT d on d.ID_COMPANIE = c.ID and c.STERS = 0
    full join DIVIZIE div on div.ID_DEPARTAMENT = d.ID and d.STERS = 0
    full join CENTRU_DE_COST cc on cc.ID_DIVIZIE = div.ID and div.STERS = 0
    full join MIJLOC_FIX mf on mf.ID_CENTRU_DE_COST = cc.ID and cc.STERS = 0
    group by c.ID
) X ON X.id_companie = C.ID