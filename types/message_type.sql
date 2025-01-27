CREATE OR REPLACE TYPE MESSAGE_TYPE AS OBJECT (
    p_mesaj     VARCHAR2(2000),
    p_tip_mesaj VARCHAR2(1),
    p_creat_de  VARCHAR2(100)
);