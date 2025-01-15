--Sa se afiseze pentru fiecare divizie codurile centrelor de cost care nu au suferit modificari de cand au fost introduse in sistem
--Pentru fiecare divizie, sa se afiseze o singura linie

SELECT
    d.ID AS divizie_id,
    d.Nume AS divizie_nume,
    LISTAGG(cc.Nume, ' | ') WITHIN GROUP (ORDER BY cc.Id) AS Centre_De_Cost
FROM
    DIVIZIE d
INNER JOIN
    CENTRU_DE_COST cc ON cc.ID_DIVIZIE = d.ID AND cc.STERS = 0
WHERE
    d.STERS = 0 and d.CREAT_LA = d.MODIFICAT_LA
GROUP BY
    d.ID, d.Nume
ORDER BY
    d.ID;

