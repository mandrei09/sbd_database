CREATE OR REPLACE TRIGGER TRG_COMPANIE_BEFORE_INSERT
BEFORE INSERT ON COMPANIE
FOR EACH ROW
DECLARE
    lastCode VARCHAR2(20);
    dbUser VARCHAR2(20);
    tableName VARCHAR(20) := 'COMPANIE';
BEGIN
    SELECT ULTIMA_VALOARE
    INTO lastCode
    FROM Tip_Entitate
    WHERE Nume_Tabela = tableName;

    SELECT User INTO dbUser FROM dual;

    :NEW.CREAT_DE := dbUser;
    :NEW.modificat_de := dbUser;
    :NEW.COD := 'CMP-' || lastCode;
    :NEW.NUME := TRIM(:NEW.NUME);

    UPDATE Tip_Entitate
    SET ULTIMA_VALOARE = TO_CHAR(TO_NUMBER(lastCode) + 1)
    WHERE Nume_Tabela = tableName;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in TRG_COMPANIE_BEFORE_INSERT: ' || SQLERRM);
END;
/