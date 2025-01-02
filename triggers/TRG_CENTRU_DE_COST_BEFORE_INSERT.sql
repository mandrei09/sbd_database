CREATE OR REPLACE TRIGGER TRG_CENTRU_DE_COST_BEFORE_INSERT
BEFORE INSERT ON CENTRU_DE_COST
FOR EACH ROW
DECLARE
    lastCode VARCHAR2(20);
    dbUser VARCHAR2(20);
    tableName VARCHAR(20) := 'CENTRU_DE_COST';
BEGIN
    SELECT ULTIMA_VALOARE INTO lastCode
    FROM Tip_Entitate
    WHERE Nume_Tabela = tableName;

    SELECT USER INTO dbUser FROM dual;

    :NEW.creat_de := dbUser;
    :NEW.cod := 'CDC-' || lastCode;
    :NEW.nume := TRIM(:NEW.nume);

    UPDATE Tip_Entitate
    SET ULTIMA_VALOARE = TO_CHAR(TO_NUMBER(lastCode) + 1)
    WHERE Nume_Tabela = tableName;
END;
/
