CREATE OR REPLACE TRIGGER TRG_INVENTAR_BEFORE_INSERT
BEFORE INSERT ON INVENTAR
FOR EACH ROW
DECLARE
    lastCode VARCHAR2(20);
    dbUser VARCHAR2(20);
    tableName VARCHAR(20) := 'INVENTAR';
BEGIN
    SELECT ULTIMA_VALOARE INTO lastCode
    FROM Tip_Entitate
    WHERE Nume_Tabela = tableName;

    SELECT USER INTO dbUser FROM dual;

    :NEW.creat_de := dbUser;
    :NEW.modificat_de := dbUser;
    :NEW.cod := 'INV-' || lastCode;
    :NEW.nume := TRIM(:NEW.nume);
    :NEW.info := TRIM(:NEW.info);

    UPDATE Tip_Entitate
    SET ULTIMA_VALOARE = TO_CHAR(TO_NUMBER(lastCode) + 1)
    WHERE Nume_Tabela = tableName;
END;
/
