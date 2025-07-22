CREATE or replace VIEW storico_ordini_cliente AS
SELECT o.cf AS cf_cliente,o.id_ordine,d.ean_box,d.QUANTITA_BOX_DETTAGLI,d.PREZZO_BOX_DETTAGLI,o.data_ordine, o.totale_prezzo,o.totale_quantita,o.stato_ordine,o.id_sconto
FROM ordine o
JOIN dettagli_ordine d ON o.id_ordine = d.id_ordine;
/


CREATE or replace VIEW box_senza_lattosio AS
SELECT b.EAN_BOX, b.NOME_BOX, b.CATEGORIA_BOX, b.PORZIONI, b.QUANTITA_IN_BOX, b.PREZZO_BOX
FROM box b
WHERE b.EAN_BOX NOT IN (
    SELECT EAN_BOX
    FROM Allergeni
    WHERE UPPER(NOME_ALLERGENE) = 'LATTOSIO'
);
/


CREATE or replace VIEW box_alto_contenuto_proteine AS
SELECT distinct b.EAN_BOX, b.NOME_BOX, b.CATEGORIA_BOX, b.PORZIONI,v.PROTEINE,b.QUANTITA_IN_BOX, b.PREZZO_BOX
FROM box b
JOIN valori_nutrizionali v ON b.EAN_BOX = v.EAN_BOX
WHERE v.PROTEINE > 10; 
/

CREATE or replace VIEW dati_cliente AS
SELECT c.CF as cf_cliente,c.PASSWORD_C,c.EMAIL,d.NOME,d.COGNOME,d.DATAN,d.NUMERO_TEL_1,r.STATO,r.VIA,r.CIVICO,r.CAP,r.CITTA,r.PROVINCIA
FROM cliente c
JOIN RUBRICA_INDIRIZZI r ON c.CF = r.CF
JOIN DATI_ANAGRAFICI d ON c.CF = d.CF
where r.stato ='attivo';
/