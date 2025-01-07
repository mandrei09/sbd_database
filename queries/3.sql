--Diviziile grupate in functie de media valorii mijloacelor fixe fata de divizia cu maximul pe media valorii mijloacelor fixe

SELECT
    div.COD,
    div.NUME,
    CASE
        WHEN avg(mf.VALOARE) =
        (
            SELECT MAX(valoare_medie)
            FROM (
                SELECT div.id AS id_divizie, AVG(mf.VALOARE) AS valoare_medie
                FROM DIVIZIE div
                FULL JOIN CENTRU_DE_COST cc ON cc.ID_DIVIZIE = div.ID
                FULL JOIN MIJLOC_FIX mf ON mf.ID_CENTRU_DE_COST = cc.ID
                GROUP BY div.id
        ) vm_pe_div) THEN TO_CHAR(avg(mf.VALOARE)) || ' ='
        ELSE TO_CHAR(avg(mf.VALOARE)) || ' <'
    END AS comparatie
FROM DIVIZIE div
FULL JOIN CENTRU_DE_COST cc ON cc.ID_DIVIZIE = div.ID
FULL JOIN MIJLOC_FIX mf ON mf.ID_CENTRU_DE_COST = cc.ID
WHERE div.STERS = 0
GROUP BY div.COD, div.NUME;