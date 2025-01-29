-- Crearea tipului OBJECT pentru mijloace fixe
CREATE OR REPLACE TYPE Import_MF AS OBJECT (
    nume VARCHAR2(200),
    valoare NUMBER(12,2),
    data_achizitionare DATE,
    cod_cdc VARCHAR2(50),  -- Cod centru de cost
    cod_divizie VARCHAR2(50),
    cod_departament VARCHAR2(50),
    cod_companie VARCHAR2(50)
);
/

-- Crearea tipului TABLE pentru lista de mijloace fixe
CREATE OR REPLACE TYPE Lista_Import_MF AS TABLE OF Import_MF;
/

-- Procedura pentru importul mijloacelor fixe
CREATE OR REPLACE PROCEDURE import_mijloace_fixe(
    lista_mijloace IN Lista_Import_MF
) IS
    -- Colecție asociativă pentru a memora codurile entităților deja procesate
    TYPE Associative_Array IS TABLE OF NUMBER INDEX BY VARCHAR2(50);
    companii_verificate Associative_Array;
    departamente_verificate Associative_Array;
    divizii_verificate Associative_Array;
    centre_cost_verificate Associative_Array;

    -- Colecție de tip varray pentru log
    TYPE Log_Messages IS VARRAY(1000) OF VARCHAR2(4000);
    log_mesaje Log_Messages := Log_Messages();

    -- Variabile auxiliare
    v_id_companie NUMBER;
    v_id_departament NUMBER;
    v_id_divizie NUMBER;
    v_id_centru_cost NUMBER;
    v_id_manager_nespecificat NUMBER;

BEGIN
    -- Verificăm dacă lista este goală
    IF lista_mijloace IS NULL OR lista_mijloace.COUNT = 0 THEN
        log_mesaje.EXTEND;
        log_mesaje(log_mesaje.COUNT) := 'Lista de mijloace fixe este goală.';
    ELSE
        -- Verificăm dacă managerul "NSP" există
        BEGIN
            SELECT ID INTO v_id_manager_nespecificat
            FROM ANGAJAT
            WHERE NUME = 'NSP';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Creăm managerul "NSP" dacă nu există
                INSERT INTO Angajat (nume, prenume, id_manager)
                VALUES ('NSP', 'NSP', NULL)
                RETURNING id INTO v_id_manager_nespecificat;
        END;

        -- Iterăm prin lista de mijloace fixe
        FOR i IN 1 .. lista_mijloace.COUNT LOOP
            -- 1. Verificăm dacă compania există (după cod)
            BEGIN
                IF NOT companii_verificate.EXISTS(lista_mijloace(i).cod_companie) THEN
                    SELECT id INTO v_id_companie
                    FROM Companie
                    WHERE cod = lista_mijloace(i).cod_companie;

                    -- Dacă există, salvăm în cache
                    companii_verificate(lista_mijloace(i).cod_companie) := v_id_companie;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Dacă nu există, o creăm
                    INSERT INTO Companie (cod, nume, id_manager)
                    VALUES (lista_mijloace(i).cod_companie, 'Companie necunoscută', v_id_manager_nespecificat)
                    RETURNING id INTO v_id_companie;

                    companii_verificate(lista_mijloace(i).cod_companie) := v_id_companie;
                    log_mesaje.EXTEND;
                    log_mesaje(log_mesaje.COUNT) := 'Compania cu codul ' || lista_mijloace(i).cod_companie || ' a fost creată.';
            END;

            -- 2. Verificăm dacă departamentul există (după cod)
            BEGIN
                IF NOT departamente_verificate.EXISTS(lista_mijloace(i).cod_departament) THEN
                    SELECT id INTO v_id_departament
                    FROM Departament
                    WHERE cod = lista_mijloace(i).cod_departament;

                    departamente_verificate(lista_mijloace(i).cod_departament) := v_id_departament;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Dacă nu există, îl creăm
                    INSERT INTO Departament (cod, nume, id_companie, id_manager)
                    VALUES (lista_mijloace(i).cod_departament, 'Departament necunoscut', v_id_companie, v_id_manager_nespecificat)
                    RETURNING id INTO v_id_departament;

                    departamente_verificate(lista_mijloace(i).cod_departament) := v_id_departament;
                    log_mesaje.EXTEND;
                    log_mesaje(log_mesaje.COUNT) := 'Departamentul cu codul ' || lista_mijloace(i).cod_departament || ' a fost creat.';
            END;

            -- 3. Verificăm dacă divizia există (după cod)
            BEGIN
                IF NOT divizii_verificate.EXISTS(lista_mijloace(i).cod_divizie) THEN
                    SELECT id INTO v_id_divizie
                    FROM Divizie
                    WHERE cod = lista_mijloace(i).cod_divizie;

                    divizii_verificate(lista_mijloace(i).cod_divizie) := v_id_divizie;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Dacă nu există, o creăm
                    INSERT INTO Divizie (cod, nume, id_departament, id_manager)
                    VALUES (lista_mijloace(i).cod_divizie, 'Divizie necunoscută', v_id_departament, v_id_manager_nespecificat)
                    RETURNING id INTO v_id_divizie;

                    divizii_verificate(lista_mijloace(i).cod_divizie) := v_id_divizie;
                    log_mesaje.EXTEND;
                    log_mesaje(log_mesaje.COUNT) := 'Divizia cu codul ' || lista_mijloace(i).cod_divizie || ' a fost creată.';
            END;

            -- 4. Verificăm dacă centrul de cost există (după cod)
            BEGIN
                IF NOT centre_cost_verificate.EXISTS(lista_mijloace(i).cod_cdc) THEN
                    SELECT id INTO v_id_centru_cost
                    FROM Centru_de_Cost
                    WHERE cod = lista_mijloace(i).cod_cdc;

                    centre_cost_verificate(lista_mijloace(i).cod_cdc) := v_id_centru_cost;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Dacă nu există, îl creăm
                    INSERT INTO Centru_de_Cost (cod, nume, id_divizie, id_manager)
                    VALUES (lista_mijloace(i).cod_cdc, 'Centru necunoscut', v_id_divizie, v_id_manager_nespecificat)
                    RETURNING id INTO v_id_centru_cost;

                    centre_cost_verificate(lista_mijloace(i).cod_cdc) := v_id_centru_cost;
                    log_mesaje.EXTEND;
                    log_mesaje(log_mesaje.COUNT) := 'Centrul de cost cu codul ' || lista_mijloace(i).cod_cdc || ' a fost creat.';
            END;

            -- 5. Inserăm mijlocul fix în baza de date
            INSERT INTO Mijloc_fix (nume, data_achizitionare, id_centru_de_cost, VALOARE)
            VALUES (
                lista_mijloace(i).nume,
                lista_mijloace(i).data_achizitionare,
                v_id_centru_cost,
                lista_mijloace(i).valoare
            );
            log_mesaje.EXTEND;
            log_mesaje(log_mesaje.COUNT) := 'Mijlocul fix "' || lista_mijloace(i).nume || '" a fost importat.';
        END LOOP;
    END IF;

    -- Afișăm logurile
    FOR i IN 1 .. log_mesaje.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(log_mesaje(i));
        insert into MESAJE(cod_mesaj, mesaj, tip_mesaj, creat_de, creat_la)
        values(
             SEQ_COD_MESAJ.nextval,
               log_mesaje(i),
               'I',
               USER,
               SYSDATE
        );
    END LOOP;
END;
/
DECLARE
    -- Declaring the list of fixed assets
    lista_mijloace Lista_Import_MF := Lista_Import_MF(
        Import_MF('Mijloc Fix 1', 11, TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'CDC001', 'DIV001', 'DEP001', 'COMP001'),
        Import_MF('Mijloc Fix 2', 12, TO_DATE('2025-01-02', 'YYYY-MM-DD'), 'CDC002', 'DIV002', 'DEP002', 'COMP002'),
        Import_MF('Mijloc Fix 3', 13, TO_DATE('2025-01-03', 'YYYY-MM-DD'), 'CDC003', 'DIV003', 'DEP003', 'COMP003'),
        Import_MF('Mijloc Fix 4', 14, TO_DATE('2025-01-04', 'YYYY-MM-DD'), 'CDC004', 'DIV004', 'DEP004', 'COMP004'),
        Import_MF('Mijloc Fix 5', 15, TO_DATE('2025-01-05', 'YYYY-MM-DD'), 'CDC005', 'DIV005', 'DEP005', 'COMP005')
    );
BEGIN
    -- Calling the procedure to import the fixed assets
    import_mijloace_fixe(lista_mijloace);
END;
/

SELECT * FROM MIJLOC_FIX
