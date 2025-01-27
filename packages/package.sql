CREATE OR REPLACE PACKAGE pachet_gestiune IS
    -- Proceduri și funcții
    PROCEDURE procesare_angajati_cu_colectii;
    PROCEDURE procesare_cursoare_centru_de_cost;
    FUNCTION numar_angajati_divizie(p_id_divizie NUMBER) RETURN NUMBER;
END pachet_gestiune;
/

CREATE OR REPLACE PACKAGE BODY pachet_gestiune IS
    -- Procedură: Utilizarea colecțiilor
    PROCEDURE procesare_angajati_cu_colectii IS
    BEGIN
        -- Logică (copiată din secțiunea anterioară)
        NULL; -- Exemplu (introduce codul deja creat)
    END procesare_angajati_cu_colectii;

    -- Procedură: Utilizarea cursoarelor
    PROCEDURE procesare_cursoare_centru_de_cost IS
    BEGIN
        -- Logică (copiată din secțiunea anterioară)
        NULL; -- Exemplu (introduce codul deja creat)
    END procesare_cursoare_centru_de_cost;

    -- Funcție: Numărul de angajați activi în divizie
    FUNCTION numar_angajati_divizie(p_id_divizie NUMBER) RETURN NUMBER IS
    BEGIN
        -- Logică (copiată din secțiunea anterioară)
        RETURN 0; -- Exemplu (introduce codul deja creat)
    END numar_angajati_divizie;
END pachet_gestiune;
/
