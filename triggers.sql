CREATE OR REPLACE TRIGGER PREZZO_UNITARIO_CARRELLO  
    BEFORE INSERT  
    ON CARRELLO  
    FOR EACH ROW  
BEGIN  
    -- Ricerca del prezzo del box per l'EAN specificato 
    SELECT Prezzo_box  
    INTO :NEW.PREZZO_BOX_UNITARIO_CARRELLO  
    FROM BOX  
    WHERE Ean_box = :NEW.Ean_box; 
 
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        -- Se l'EAN_BOX non esiste nella tabella BOX 
        RAISE_APPLICATION_ERROR(-20000, 'Errore: EAN della box non trovato nella tabella BOX.'); 
 
    WHEN TOO_MANY_ROWS THEN 
        -- Se la query restituisce più di un risultato (dovrebbe essere un errore di integritA dei dati) 
        RAISE_APPLICATION_ERROR(-20001, 'Errore: EAN della box non è univoco nella tabella BOX.'); 
 
    WHEN OTHERS THEN 
        -- Gestione di eventuali altri errori con un messaggio generico 
        RAISE_APPLICATION_ERROR(-20099, 'Errore imprevisto: ' || SQLERRM); 
     
END PREZZO_UNITARIO_CARRELLO; 
/

create or replace trigger CONTROLLO_DISPONIBILITA_BOX  
    before insert  
    on CARRELLO  
    for each row  
DECLARE  
    BOX_DISPONIBILI NUMBER;  
    box_non_disp EXCEPTION;  
    box_ins EXCEPTION;  
    ean_non_valido EXCEPTION;  
    cf_non_valido EXCEPTION; 
    ean_count NUMBER;   
BEGIN  
		-- Controlla se l'EAN fornito esiste  
    SELECT COUNT(*)  
    INTO ean_count  
    FROM box  
    WHERE EAN_BOX = :NEW.EAN_BOX;  
  
    IF ean_count = 0 THEN  
        RAISE ean_non_valido; 
    else           
        SELECT QUANTITA_IN_BOX  
        INTO BOX_DISPONIBILI  
        FROM box  
        WHERE :NEW.EAN_BOX = EAN_BOX;  
         -- Se BOX_DISPONIBILI è nullo, l'EAN non esiste  
        IF BOX_DISPONIBILI = 0  THEN  
            RAISE box_non_disp;  
        ELSIF :NEW.QUANTITA_IN_CARRELLO > BOX_DISPONIBILI THEN  
            RAISE box_ins;  
        END IF;   
    END IF;  
 
    -- Controllo se il CF fornito è valido (esiste nella tabella cliente)  
    DECLARE  
        v_count NUMBER;  
    BEGIN  
        SELECT COUNT(*)  
        INTO v_count  
        FROM cliente  
        WHERE cf = :NEW.CF;  
  
        IF v_count = 0 THEN  
            RAISE cf_non_valido;  
        END IF;  
    END;  
  
EXCEPTION  
    WHEN ean_non_valido THEN  
        RAISE_APPLICATION_ERROR(-20002, 'Box non trovato per l EAN fornito.');  
    WHEN box_non_disp THEN  
        RAISE_APPLICATION_ERROR(-20003, 'Il box selezionato non è disponibile al momento.');  
    WHEN box_ins THEN  
        RAISE_APPLICATION_ERROR(-20004, 'QuantitA insufficiente del box selezionato.');  
    WHEN cf_non_valido THEN  
        RAISE_APPLICATION_ERROR(-20005, 'Codice fiscale non valido o non trovato.');  
    WHEN OTHERS THEN  
        RAISE_APPLICATION_ERROR(-20099, 'Errore imprevisto: ' || SQLERRM);  
END;  
/


CREATE OR REPLACE TRIGGER PREVENZIONE_CANCELLAZIONE_CLIENTE  
    BEFORE DELETE  
    ON CLIENTE  
    FOR EACH ROW  
DECLARE  
    v_count NUMBER; 
    non_eliminare EXCEPTION;  
BEGIN   
    SELECT COUNT(*)  
    INTO v_count  
    FROM ORDINE  
    WHERE Cf = :OLD.Cf; 
        
    IF v_count > 0 THEN  
        RAISE non_eliminare; 
    END IF; 
 
EXCEPTION 
	WHEN non_eliminare THEN 
	    -- Se esistono ordini associati, solleva un'eccezione per impedire l'eliminazione 
        RAISE_APPLICATION_ERROR(-20006, 'Non puoi eliminare un cliente con ordini associati.'); 
    WHEN OTHERS THEN 
        -- Gestione di errori imprevisti 
        RAISE_APPLICATION_ERROR(-20099, 'Errore durante la verifica degli ordini associati al cliente: ' || SQLERRM); 

END PREVENZIONE_CANCELLAZIONE_CLIENTE; 
/

CREATE OR REPLACE TRIGGER CANCELLAZIONE_ORDINE  
    AFTER UPDATE  
    ON ORDINE  
    FOR EACH ROW  
BEGIN  
    -- Controllo se lo stato dell'ordine è passato a 4 (cancellato) 
    IF :NEW.Stato_ordine = 4 AND :OLD.Stato_ordine != 4 THEN  
        -- Aggiorna le quantità dei box in base alla cancellazione dell'ordine 
        UPDATE BOX  
        SET Quantita_in_box = Quantita_in_box +  
            (SELECT SUM(do.QUANTITA_BOX_DETTAGLI)  
            FROM DETTAGLI_ORDINE do  
            WHERE do.Ean_box = BOX.Ean_box  
            AND do.Id_ordine = :NEW.Id_ordine)  
        WHERE EXISTS (SELECT 1  
            FROM DETTAGLI_ORDINE do  
            WHERE do.Ean_box = BOX.Ean_box  
            AND do.Id_ordine = :NEW.Id_ordine);  
        END IF;  
EXCEPTION  
        WHEN OTHERS THEN  
            RAISE_APPLICATION_ERROR(-20099,  
                'Errore imprevisto durante l’aggiornamento della quantità dei box: ' || SQLERRM);  
END;  
/


CREATE OR REPLACE TRIGGER INIZIALIZZA_SPEDIZIONE  
    AFTER INSERT  
    ON ORDINE  
    FOR EACH ROW  
DECLARE  
    viaCF VARCHAR2(100);  
    civicoCF VARCHAR2(6);  
    capCF NUMBER(5);  
    cittaCF VARCHAR2(100);  
    provinciaCF VARCHAR2(4);
    CF_VUOTO EXCEPTION;
    via_VUOTO EXCEPTION;
    civico_VUOTO EXCEPTION;
    cap_VUOTO EXCEPTION;
    citta_VUOTO EXCEPTION;
    provincia_VUOTO EXCEPTION;

 
BEGIN  
    -- Controllo che il CF non sia nullo o vuoto 
    IF :NEW.CF IS NULL OR :NEW.CF = '' THEN 
        RAISE CF_VUOTO; 
    END IF;  
        -- Recupero dell'indirizzo attivo per il cliente 
        SELECT via, civico, cap, citta, provincia  
        INTO viaCF, civicoCF, capCF, cittaCF, provinciaCF  
        FROM RUBRICA_INDIRIZZI  
        WHERE CF = :NEW.CF AND STATO = 'attivo'; 
 
        -- Controllo che i valori dell'indirizzo siano validi 
        IF viaCF IS NULL OR TRIM(viaCF) = '' THEN 
            RAISE via_VUOTO; 
        END IF; 
 
        IF civicoCF IS NULL OR TRIM(civicoCF) = '' THEN 
            RAISE civico_VUOTO; 
        END IF; 
 
        IF capCF IS NULL OR capCF <= 0 THEN 
            RAISE cap_VUOTO; 
        END IF; 
 
        IF cittaCF IS NULL OR TRIM(cittaCF) = '' THEN 
            RAISE citta_VUOTO; 
        END IF; 
 
        IF provinciaCF IS NULL OR TRIM(provinciaCF) = '' THEN 
            RAISE provincia_VUOTO; 
        END IF; 
 
        -- Inserimento della spedizione con i dettagli recuperati 
        INSERT INTO SPEDIZIONE(corriere, stato_spedizione, id_ordine, VIA_SPEDIZIONE, CIVICO_SPEDIZIONE, CAP_SPEDIZIONE, CITTA_SPEDIZIONE, PROVINCIA_SPEDIZIONE)  
        VALUES ('Bartolini', 1, :NEW.ID_ORDINE, viaCF, civicoCF, capCF, cittaCF, provinciaCF); 
 
    EXCEPTION
        WHEN CF_VUOTO THEN
            RAISE_APPLICATION_ERROR(-20008, 'Errore: Il Codice Fiscale non può essere nullo o vuoto.'); 
        WHEN via_VUOTO THEN
            RAISE_APPLICATION_ERROR(-20009, 'Errore: La via non può essere nulla o vuota.');
        WHEN civico_VUOTO THEN
            RAISE_APPLICATION_ERROR(-20010, 'Errore: Il civico non può essere nullo o vuoto.');
        WHEN cap_VUOTO THEN 
            RAISE_APPLICATION_ERROR(-20011, 'Errore: Il CAP deve essere un numero valido maggiore di zero.');
        WHEN citta_VUOTO THEN 
            RAISE_APPLICATION_ERROR(-20012, 'Errore: La città non può essere nulla o vuota.');
        WHEN provincia_VUOTO THEN
            RAISE_APPLICATION_ERROR(-20013, 'Errore: La provincia non può essere nulla o vuota.'); 
        
        WHEN NO_DATA_FOUND THEN 
            -- Nessun indirizzo attivo trovato per il cliente 
            RAISE_APPLICATION_ERROR(-20014, 'Errore: Nessun indirizzo attivo trovato per il cliente con CF ' || :NEW.CF); 
 
        WHEN TOO_MANY_ROWS THEN 
            -- Più di un indirizzo attivo trovato per il cliente 
            RAISE_APPLICATION_ERROR(-20015, 'Errore: Più di un indirizzo attivo trovato per il cliente con CF ' || :NEW.CF); 
 
        WHEN OTHERS THEN 
            -- Gestione di errori imprevisti 
            RAISE_APPLICATION_ERROR(-20099, 'Errore imprevisto durante l''inizializzazione della spedizione: ' || SQLERRM); 

END INIZIALIZZA_SPEDIZIONE; 
/




CREATE OR REPLACE TRIGGER verifica_registrazione_clienti
BEFORE INSERT ON cliente
FOR EACH ROW
DECLARE
    cf_duplicato EXCEPTION;
    email_duplicata EXCEPTION;
    cf_count INTEGER;
    email_count INTEGER;
BEGIN
    -- Verifica l'unicità del CF
    SELECT COUNT(*) INTO cf_count 
    FROM cliente
    WHERE cf = :NEW.cf;

    IF cf_count > 0 THEN
        RAISE cf_duplicato;
    END IF;

    -- Verifica l'unicità dell'email
    SELECT COUNT(*) INTO email_count 
    FROM cliente
    WHERE email = :NEW.email;

    IF email_count > 0 THEN
        RAISE email_duplicata;
    END IF;

EXCEPTION
    WHEN cf_duplicato THEN
        RAISE_APPLICATION_ERROR(-20022, 'Errore: il codice fiscale inserito è già registrato.');
    WHEN email_duplicata THEN
        RAISE_APPLICATION_ERROR(-20018, 'Errore: l''email inserita è già registrata.');
   WHEN OTHERS THEN  
        RAISE_APPLICATION_ERROR(-20099, 'Errore sconosciuto: ' || SQLERRM); 
END;
/