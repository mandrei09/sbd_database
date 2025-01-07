CREATE OR REPLACE TRIGGER TRG_ANGAJAT_BEFORE_INSERT
BEFORE INSERT ON ANGAJAT
FOR EACH ROW
DECLARE
    lastCode VARCHAR2(20);
    dbUser VARCHAR2(20);
    tableName VARCHAR(20) := 'ANGAJAT';
BEGIN
    -- Get the last employee code from Tip_Entitate
    SELECT ULTIMA_VALOARE
    INTO lastCode
    FROM Tip_Entitate
    WHERE Nume_Tabela = tableName;

    SELECT User INTO dbUser FROM dual;

    :NEW.creat_de := dbUser;
    :NEW.modificat_de := dbUser;

    :NEW.COD := 'ANGJ-' || lastCode;

    :NEW.NUME := TRIM(:NEW.NUME);
    :NEW.PRENUME := TRIM(:NEW.PRENUME);
    :NEW.EMAIL := LOWER(TRIM(:NEW.NUME)) || '.' || LOWER(TRIM(:NEW.PRENUME)) || '@sbd.ro';

    UPDATE Tip_Entitate
    SET ULTIMA_VALOARE = TO_CHAR(TO_NUMBER(lastCode) + 1)
    WHERE Nume_Tabela = tableName;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in trg_angajat_update: ' || SQLERRM);
END;
/