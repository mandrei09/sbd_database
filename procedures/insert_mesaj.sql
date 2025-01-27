CREATE SEQUENCE seq_cod_mesaj
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE FUNCTION insert_mesaj(
    message_data    MESSAGE_TYPE
) RETURN NUMBER IS
    v_cod_mesaj NUMBER;
BEGIN
    -- Validate the message type
    IF message_data. NOT IN ('E', 'W', 'I') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipul mesajului este invalid. Valori valide: E, W, I.');
    END IF;

    -- Generate the next value for cod_mesaj
    v_cod_mesaj := seq_cod_mesaj.NEXTVAL;

    -- Insert the message into the Mesaje table
    INSERT INTO Mesaje (
        cod_mesaj,
        mesaj,
        tip_mesaj,
        creat_de,
        creat_la
    ) VALUES (
        v_cod_mesaj,
        message_data.p_mesaj,
        message_data.p_tip_mesaj,
        message_data.p_creat_de,
        SYSDATE
    );

    -- Return the generated cod_mesaj
    RETURN v_cod_mesaj;

EXCEPTION
    WHEN OTHERS THEN
        -- Raise a custom error message for any exception
        RAISE_APPLICATION_ERROR(-20002, 'Eroare la inserarea mesajului: ' || SQLERRM);
END insert_mesaj;
/
