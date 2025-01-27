create OR replace PROCEDURE actualizare_valoare_pierduta_inventar(id_inventar NUMBER) IS

BEGIN
    BEGIN
        SELECT id
        INTO retrieved_id
        FROM Inventar
        WHERE id = id_inventar;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            message_data := MESSAGE_TYPE('Nu exista inventar cu id-ul ' || id_inventar || '!', 'E', USER)
            insert_mesaj(message_data);
    END;
END actualizare_valoare_pierduta_inventar;
/

