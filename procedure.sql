CREATE OR REPLACE PROCEDURE mostra_composizione_box ( 
    p_ean_box IN VARCHAR2  
)  
IS  
    -- Definizione dell'eccezione personalizzata 
    ean_box_non_trovato EXCEPTION; 
 
    -- Variabile per la verifica dell'esistenza dell'EAN della box 
    v_box_count NUMBER; 
 
    -- Definizione del cursore per gli ingredienti 
    CURSOR c_ingredienti IS  
        SELECT DISTINCT i.NOME_INGREDIENTE  
        FROM COMPOSIZIONE_BOX cb  
        JOIN INGREDIENTE i ON cb.EAN_INGREDIENTE = i.EAN_INGREDIENTE  
        WHERE cb.EAN_BOX = p_ean_box;  
 
BEGIN  
    -- Verifica se l'EAN della box esiste nella tabella COMPOSIZIONE_BOX 
    SELECT COUNT(*) INTO v_box_count 
    FROM COMPOSIZIONE_BOX 
    WHERE EAN_BOX = p_ean_box; 
 
    -- Se non esiste, solleva l'eccezione 
    IF v_box_count = 0 THEN 
        RAISE ean_box_non_trovato; 
    END IF; 
 
    -- Visualizzazione dell'EAN della box 
    DBMS_OUTPUT.PUT_LINE('EAN della box: ' || p_ean_box);  
 
    -- Ciclo sugli ingredienti della box 
    FOR rec IN c_ingredienti LOOP  
        DBMS_OUTPUT.PUT_LINE('Ingrediente: ' || rec.NOME_INGREDIENTE );  
    END LOOP;  
 
    -- Conferma delle operazioni 
    COMMIT; 
 
EXCEPTION  
    WHEN ean_box_non_trovato THEN 
        RAISE_APPLICATION_ERROR(-20016, 'Errore: la box con EAN ' || p_ean_box || ' non esiste.');
        ROLLBACK; 
 
    WHEN NO_DATA_FOUND THEN  
        RAISE_APPLICATION_ERROR(-20017, 'Errore: nessun ingrediente trovato per la box con EAN ' || p_ean_box); 
        ROLLBACK; 
 
  WHEN OTHERS THEN 
            -- Gestione di eventuali altri errori con un messaggio generico 
            RAISE_APPLICATION_ERROR(-20099, 'Errore imprevisto: ' || SQLERRM); 
END mostra_composizione_box; 
/


CREATE OR REPLACE PROCEDURE Aggiungi_Cliente(   
    p_CF VARCHAR2,   
    p_PASSWORD_C VARCHAR2,   
    p_EMAIL VARCHAR2   
) AS   
    v_email_count NUMBER;   
    email_esistente EXCEPTION;   
BEGIN   
    -- Verifica se l'email è già esistente   
    SELECT COUNT(*) INTO v_email_count   
    FROM CLIENTE   
    WHERE EMAIL = p_EMAIL;   
   
    IF v_email_count > 0 THEN   
        RAISE email_esistente;   
    ELSE   
        -- Se l'email non è presente, inserisce il nuovo cliente   
        INSERT INTO CLIENTE (CF, PASSWORD_C, EMAIL)   
        VALUES (p_CF, p_PASSWORD_C, p_EMAIL);   
          
        -- Conferma la transazione se l'inserimento ha successo  
        COMMIT;   
    END IF;   
   
EXCEPTION   
    WHEN email_esistente THEN   
        -- Annulla la transazione e segnala l'email già registrata  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20018, 'Email già registrata!');   
   
    WHEN DUP_VAL_ON_INDEX THEN   
        -- Annulla la transazione in caso di codice fiscale duplicato  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20019, 'Codice fiscale già presente nel sistema.');   
           
    WHEN VALUE_ERROR THEN   
        -- Annulla la transazione in caso di errori di valore  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20020, 'Errore nei valori inseriti: verificare la lunghezza dei campi.');   
           
    WHEN NO_DATA_FOUND THEN   
        -- Annulla la transazione in caso di dati mancanti  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20021, 'Errore durante la verifica dei dati.');   
           
    WHEN OTHERS THEN   
        -- Annulla la transazione in caso di errori non previsti  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20099,'Errore imprevisto durante l''inserimento del cliente: ' || SQLERRM);   
END Aggiungi_Cliente; 
/




CREATE OR REPLACE PROCEDURE Aggiungi_Indirizzo(  
    p_CF VARCHAR2,  
    p_VIA VARCHAR2,  
    p_CIVICO VARCHAR2,  
    p_CAP NUMBER,  
    p_CITTA VARCHAR2,  
    p_PROVINCIA VARCHAR2  
) AS  
    v_cliente_count NUMBER;  
    cliente_esistente EXCEPTION;  
BEGIN  
    -- Controllo se il cliente esiste nella tabella CLIENTE  
    SELECT COUNT(*)  
    INTO v_cliente_count  
    FROM CLIENTE  
    WHERE CF = p_CF;  
  
    IF v_cliente_count = 0 THEN  
        RAISE cliente_esistente;  
    ELSE  
        -- Disattiva tutti gli indirizzi precedenti del cliente  
        UPDATE RUBRICA_INDIRIZZI  
        SET STATO = 'inattivo'  
        WHERE CF = p_CF AND STATO = 'attivo';  
  
        -- Inserisce il nuovo indirizzo come "attivo"  
        INSERT INTO RUBRICA_INDIRIZZI (CF, STATO, VIA, CIVICO, CAP, CITTA, PROVINCIA)  
        VALUES (p_CF, 'attivo', p_VIA, p_CIVICO, p_CAP, p_CITTA, p_PROVINCIA);  
          
        -- Conferma la transazione se tutte le operazioni sono eseguite correttamente  
        COMMIT;  
    END IF;  
  
EXCEPTION  
    WHEN cliente_esistente THEN  
        -- Annulla la transazione e segnala che il cliente non è stato trovato  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20005, 'Cliente non trovato, impossibile aggiungere indirizzo.');  
      
    WHEN VALUE_ERROR THEN  
        -- Annulla la transazione in caso di errori di formato  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20020, 'Errore di formato: Verifica che il CAP e gli altri dati siano corretti.');  
      
    WHEN OTHERS THEN  
        -- Annulla la transazione in caso di errori non previsti  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20099, 'Errore sconosciuto: ' || SQLERRM);  
END Aggiungi_Indirizzo;
/



CREATE OR REPLACE PROCEDURE Aggiungi_Dati_Anagrafici(  
    p_CF VARCHAR2,  
    p_NOME VARCHAR2,  
    p_COGNOME VARCHAR2,  
    p_DATA_NASCITA DATE,  
    p_NUMERO_TEL_1 NUMBER  
) AS  
    v_cliente_count NUMBER;  
    cliente_non_trovato EXCEPTION;  
BEGIN  
    -- Controllo se il cliente esiste nella tabella CLIENTE  
    SELECT COUNT(*)  
    INTO v_cliente_count  
    FROM CLIENTE  
    WHERE CF = p_CF;  
  
    IF v_cliente_count = 0 THEN  
        RAISE cliente_non_trovato;  
    ELSE  
        -- Inserisce i dati anagrafici per il cliente  
        INSERT INTO DATI_ANAGRAFICI (CF, NOME, COGNOME, DATAN, NUMERO_TEL_1)  
        VALUES (p_CF, p_NOME, p_COGNOME, p_DATA_NASCITA, p_NUMERO_TEL_1);  
          
        -- Conferma la transazione se l'inserimento è avvenuto con successo  
        COMMIT;  
    END IF;  
  
EXCEPTION  
    WHEN cliente_non_trovato THEN  
        -- Annulla la transazione e segnala che il cliente non è stato trovato  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20005, 'Cliente non trovato, impossibile aggiungere dati anagrafici.');  
      
    WHEN DUP_VAL_ON_INDEX THEN  
        -- Annulla la transazione in caso di dati duplicati  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20022, 'Errore: I dati anagrafici per questo cliente esistono già.');  
      
    WHEN VALUE_ERROR THEN  
        -- Annulla la transazione in caso di errori di formato  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20020, 'Errore di formato: Verifica che i dati inseriti siano corretti.');  
      
    WHEN OTHERS THEN  
        -- Annulla la transazione per qualsiasi altro errore imprevisto  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20099, 'Errore sconosciuto: ' || SQLERRM);  
END Aggiungi_Dati_Anagrafici;
/



CREATE OR REPLACE PROCEDURE mostra_box_da_ingrediente(p_ean_ing IN VARCHAR2)
IS
    -- Eccezioni personalizzate
    ingrediente_non_trovato EXCEPTION;
    nessuna_box_trovata EXCEPTION;

    -- Variabili per le verifiche
    v_ingrediente_count NUMBER := 0;
    v_box_count NUMBER := 0;

    -- Cursore per selezionare i box che contengono l'ingrediente
    CURSOR c_box IS
        SELECT i.NOME_INGREDIENTE, cb.EAN_BOX
        FROM COMPOSIZIONE_BOX cb
        JOIN INGREDIENTE i ON cb.EAN_INGREDIENTE = i.EAN_INGREDIENTE
        WHERE cb.EAN_INGREDIENTE = p_ean_ing;

BEGIN
    -- Verifica se l'EAN ingrediente esiste nella tabella INGREDIENTE
    SELECT COUNT(*) INTO v_ingrediente_count
    FROM INGREDIENTE
    WHERE EAN_INGREDIENTE = p_ean_ing;

    IF v_ingrediente_count = 0 THEN
        -- Se l'ingrediente non esiste, solleva un'eccezione
        RAISE ingrediente_non_trovato;
    END IF;

    -- Verifica se l'EAN ingrediente è presente nella tabella COMPOSIZIONE_BOX
    SELECT COUNT(*) INTO v_box_count
    FROM COMPOSIZIONE_BOX
    WHERE EAN_INGREDIENTE = p_ean_ing;

    IF v_box_count = 0 THEN
        -- Se l'ingrediente esiste in INGREDIENTE ma non è in nessun box
        RAISE nessuna_box_trovata;
    END IF;

    -- Visualizzazione dell'EAN dell'ingrediente
    DBMS_OUTPUT.PUT_LINE('EAN di ingrediente: ' || p_ean_ing);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------');

    -- Ciclo per visualizzare tutti i box che contengono l'ingrediente
    FOR rec IN c_box LOOP
        DBMS_OUTPUT.PUT_LINE('Nome ingrediente: ' || rec.NOME_INGREDIENTE);
        DBMS_OUTPUT.PUT_LINE('EAN Box: ' || rec.EAN_BOX);
        
    
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
END LOOP;

EXCEPTION
    WHEN ingrediente_non_trovato THEN
        RAISE_APPLICATION_ERROR(-20023, 'Errore: l''ingrediente con EAN ' || p_ean_ing || ' non esiste in INGREDIENTE.'); 
    WHEN nessuna_box_trovata THEN
        RAISE_APPLICATION_ERROR(-20024, 'Errore: l''ingrediente con EAN ' || p_ean_ing || ' esiste in INGREDIENTE ma non è presente in alcuna box.'); 
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099, 'Errore sconosciuto: ' || SQLERRM); 
END mostra_box_da_ingrediente;
/


CREATE OR REPLACE PROCEDURE AGGIUNGI_BOX_CARRELLO (P_CF IN VARCHAR2,P_EAN_BOX IN VARCHAR2,P_QUANTITA IN number) 
   as 
   v_cf_count number;
   v_ean_box_count number;
   cliente_non_esistente EXCEPTION;
   ean_box_non_esistente EXCEPTION;
  BEGIN

  --Controllo se cf esiste
  SELECT COUNT(*)  
    INTO v_cf_count  
    FROM CLIENTE  
    WHERE CF = P_CF;  
  
    IF v_cf_count = 0 THEN  
        RAISE cliente_non_esistente;  
    END IF;

   --Controllo se Ean_box esiste
   SELECT COUNT(*)  
    INTO v_ean_box_count  
    FROM Box  
    WHERE ean_box = p_EAN_BOX;  
  
    IF v_ean_box_count = 0 THEN  
        RAISE ean_box_non_esistente;  
    END IF;
   
    --Aggiungi nel carrello
    insert into carrello(CF,EAN_BOX,QUANTITA_IN_CARRELLO)values
               (P_CF,P_EAN_BOX,P_QUANTITA);
    COMMIT;
    EXCEPTION  
    WHEN cliente_non_esistente THEN  
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Cliente non esiste');  
    WHEN ean_box_non_esistente THEN  
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Ean box non disponibile');  
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20099, 'Errore sconosciuto: ' || SQLERRM); 
  END AGGIUNGI_BOX_CARRELLO;
/

CREATE OR REPLACE PROCEDURE gestisci_clienti_inattivi AS
    -- Variabili contatori
    avvisi_inviati NUMBER := 0;
    clienti_cancellati NUMBER := 0;
BEGIN
    -- Inizio della transazione
    SAVEPOINT inizio_procedura;
    
    -- Invio avvisi ai clienti inattivi da più di un anno
    FOR cliente IN (
        SELECT CF
        FROM cliente
        WHERE NOT EXISTS (
            SELECT 1
            FROM ordine o
            WHERE o.CF = cliente.CF
        )
        AND data_registrazione <= ADD_MONTHS(SYSDATE, -12)  -- Più di un anno fa
    ) LOOP
        BEGIN
            -- Simulazione di invio avviso
            DBMS_OUTPUT.PUT_LINE('Avviso inviato al cliente ID: ' || cliente.CF);
            avvisi_inviati := avvisi_inviati + 1;
        EXCEPTION
            WHEN OTHERS THEN
                raise_application_error(-20099,'Errore durante l''invio dell''avviso al cliente ID: ' || cliente.CF || ' - ' || SQLERRM);
        END;
    END LOOP;
    
    -- Cancellazione dei clienti inattivi da più di due anni
    BEGIN
        -- Cancella i record dalla tabella carrello per i clienti senza ordini e inattivi da più di 2 anni
        DELETE FROM carrello
        WHERE CF IN (
            SELECT CF
            FROM cliente
            WHERE NOT EXISTS (
                SELECT 1
                FROM ordine o
                WHERE o.CF = cliente.CF
            )
            AND data_registrazione <= ADD_MONTHS(SYSDATE, -24)  -- Più di 2 anni fa
        );
        
        -- Cancella dalla rubrica degli indirizzi per i clienti senza ordini e inattivi da più di 2 anni
        DELETE FROM rubrica_indirizzi
        WHERE CF IN (
            SELECT CF
            FROM cliente
            WHERE NOT EXISTS (
                SELECT 1
                FROM ordine o
                WHERE o.CF = cliente.CF
            )
            AND data_registrazione <= ADD_MONTHS(SYSDATE, -24)  -- Più di 2 anni fa
        );
        
        -- Cancella dai dati anagrafici per i clienti senza ordini e inattivi da più di 2 anni
        DELETE FROM dati_anagrafici
        WHERE CF IN (
            SELECT CF
            FROM cliente
            WHERE NOT EXISTS (
                SELECT 1
                FROM ordine o
                WHERE o.CF = cliente.CF
            )
            AND data_registrazione <= ADD_MONTHS(SYSDATE, -24)  -- Più di 2 anni fa
        );
        
        -- Cancella dalla tabella cliente per i clienti senza ordini e inattivi da più di 2 anni
        DELETE FROM cliente
        WHERE NOT EXISTS (
            SELECT 1
            FROM ordine o
            WHERE o.CF = cliente.CF
        )
        AND data_registrazione <= ADD_MONTHS(SYSDATE, -24);  -- Più di 2 anni fa
        
        -- Aggiorna il contatore dei clienti cancellati
        clienti_cancellati := SQL%ROWCOUNT;
        
        -- Se non ci sono cancellazioni
        IF clienti_cancellati = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nessun cliente inattivo da più di 2 anni da cancellare.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20099,'Errore durante la cancellazione dei clienti inattivi da più di 2 anni: ' || SQLERRM);
            ROLLBACK TO inizio_procedura;
    END;
    
    -- Conferma delle modifiche
    COMMIT;
    
    -- Messaggi di riepilogo
    DBMS_OUTPUT.PUT_LINE('Numero di avvisi inviati a clienti inattivi da più di 1 anno: ' || avvisi_inviati);
    DBMS_OUTPUT.PUT_LINE('Numero di clienti inattivi da più di 2 anni cancellati: ' || clienti_cancellati);
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20099,'Errore generale durante l''esecuzione della procedura: ' || SQLERRM);
        ROLLBACK;
END gestisci_clienti_inattivi;
/


create or replace PROCEDURE Effettua_ordine (p_cf IN VARCHAR2,sconto in number,Metodo_pag in varchar2)  
IS  
    importo_da_scontare NUMBER(10,2);  
    percentuale_sconto number;  
    v_id_ordine VARCHAR2(50); -- ID con CF e timestamp  
    v_totale_prezzo NUMBER(10,2);  
    v_totale_quantita NUMBER;  
    v_count NUMBER;  
    v_count_sconto NUMBER;
    v_data_ordine DATE;
    v_prodotti_non_disponibili VARCHAR2(4000);  
    carrello_vuoto EXCEPTION;  
    quantita_insufficiente EXCEPTION;  
    sconto_non_valido EXCEPTION;  
BEGIN  
     -- Controllo sconto  
    SELECT COUNT(*)   
    INTO v_count_sconto   
    FROM SCONTI   
    WHERE ID_SCONTO = sconto;  
  
    IF v_count_sconto = 0 THEN  
        RAISE sconto_non_valido;  
    END IF;  
  
    SELECT  VALORE  
    INTO percentuale_sconto  
    FROM SCONTI  
    WHERE ID_SCONTO = sconto;  
       
    -- Verifica carrello vuoto e ottiene totali  
    SELECT COUNT(*), SUM(Quantita_in_carrello * PREZZO_BOX_UNITARIO_CARRELLO), SUM(Quantita_in_carrello)  
    INTO v_count, v_totale_prezzo, v_totale_quantita  
    FROM carrello  
    WHERE cf = p_cf;  
  
    IF v_count = 0 THEN  
        RAISE carrello_vuoto;  
    END IF;  
    
    -- Ottieni data corrente
    v_data_ordine := CURRENT_DATE;

    -- Genera ID ordine con timestamp
    v_id_ordine := Genera_Id_Ordine(p_cf, v_data_ordine);

    -- Blocco delle righe della tabella box  
    FOR r IN (SELECT c.Ean_box, c.Quantita_in_carrello AS richiesta  
              FROM carrello c  
              WHERE c.cf = p_cf)  
    LOOP  
        -- Tentativo di bloccare la riga corrispondente nella tabella box  
        UPDATE box b  
        SET quantita_in_box = quantita_in_box - r.richiesta  
        WHERE b.Ean_box = r.Ean_box  
        AND b.quantita_in_box >= r.richiesta;  
  
        -- Verifica se il numero di righe aggiornate è zero  
        IF SQL%ROWCOUNT = 0 THEN  
            v_prodotti_non_disponibili := v_prodotti_non_disponibili ||  
                r.Ean_box || ' (richiesti: ' || r.richiesta || '); ';  
        END IF;  
    END LOOP;  
  
    -- Se ci sono prodotti non disponibili, genera un errore  
    IF v_prodotti_non_disponibili IS NOT NULL THEN  
        RAISE quantita_insufficiente;  
    END IF;  
  
      
    -- Inserisce l'ordine e ottiene l'ID  
    INSERT INTO ordine (  
        id_ordine,Data_ordine, Totale_prezzo, Totale_quantita, Stato_ordine, Cf,ID_SCONTO  
    ) VALUES ( 
        v_id_ordine, 
        CURRENT_DATE,  
        NVL(v_totale_prezzo, 0),  
        NVL(v_totale_quantita, 0),  
        1,  
        p_cf,  
        sconto  
    ) RETURNING Id_ordine,TOTALE_PREZZO INTO v_id_ordine,importo_da_scontare;  
  
    -- Inserisce i dettagli e pulisce il carrello in un'unica transazione  
    INSERT INTO dettagli_ordine (  
        Id_ordine, Ean_box, QUANTITA_BOX_DETTAGLI,PREZZO_BOX_DETTAGLI  
    )  
    SELECT v_id_ordine, Ean_box, Quantita_in_carrello, PREZZO_BOX_UNITARIO_CARRELLO  
    FROM carrello  
    WHERE cf = p_cf;  
  
    DELETE FROM carrello WHERE cf = p_cf;  
  
    --Creazione fattura  
     insert into FATTURA(  
            metodo_pagamento, data_pagamento, importo, id_ordine  
     ) values(  
           Metodo_pag,  
           current_date,  
           CALCOLA_IMPORTO_SCONTATO(importo_da_scontare ,percentuale_sconto),  
           v_id_ordine  
    );  
       
    COMMIT;  
    DBMS_OUTPUT.PUT_LINE('Ordine Id:' || v_id_ordine ||' Cliente: ' || p_cf || ' Completato con successo.');  
  
EXCEPTION  
    WHEN sconto_non_valido THEN  
        RAISE_APPLICATION_ERROR(-20025, 'Sconto non valido ');  
    WHEN carrello_vuoto THEN  
        RAISE_APPLICATION_ERROR(-20026, 'Il carrello è vuoto');  
    WHEN quantita_insufficiente THEN  
        ROLLBACK;  
        RAISE_APPLICATION_ERROR(-20004, 'Quantità insufficiente per i seguenti prodotti: ' || v_prodotti_non_disponibili);  
    WHEN OTHERS THEN
        ROLLBACK;      
        RAISE_APPLICATION_ERROR(-20099, 'Errore durante l''elaborazione dell''ordine: ' || SQLERRM); 
END;
/


CREATE OR REPLACE PROCEDURE aggiorna_sconti_scaduti IS
BEGIN
    UPDATE SCONTI
    SET VALORE = NULL
    WHERE FINESCONTO < SYSDATE AND VALORE IS NOT NULL;
END;
/