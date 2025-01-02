CREATE OR REPLACE TRIGGER trg_tip_entitate_insert
AFTER CREATE ON SCHEMA
BEGIN
    IF ora_dict_obj_type = 'TABLE' THEN
        BEGIN
            INSERT INTO Tip_Entitate (NUME_TABELA, ULTIMA_VALOARE)
            VALUES (ora_dict_obj_name, '1');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error inserting into Tip_Entitate: ' || SQLERRM);
        END;
    END IF;
END;