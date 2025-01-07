-- Ierarhia angajatilor pentru companiile care au in nume cel putin 2 cuvinte

SELECT a.NUME, a.PRENUME, a.EMAIL
FROM Angajat a
inner join COMPANIE c on c.ID_MANAGER = a.ID and INSTR(lower(c.NUME), ' ') > 0
START WITH
    a.ID_MANAGER IS NULL
CONNECT BY
    PRIOR a.ID = a.ID_MANAGER;


