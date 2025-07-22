
create table CLIENTE 
( 
    CF         VARCHAR2(16)  not null 
        primary key, 
    PASSWORD_C VARCHAR2(32)  not null, 
    EMAIL      VARCHAR2(255) not null UNIQUE,
    DATA_REGISTRAZIONE DATE DEFAULT SYSDATE
);

create table RUBRICA_INDIRIZZI 
( 
    CF        VARCHAR2(16)  not null , 
    STATO     VARCHAR2(10)  not NULL 
        check (Stato IN ('attivo', 'inattivo')), 
    VIA       VARCHAR2(100)             not null, 
    CIVICO    VARCHAR2(6)               not null, 
    CAP       NUMBER(5)                 not null, 
    CITTA     VARCHAR2(100)             not null, 
    PROVINCIA VARCHAR2(4)               not null,
   CONSTRAINT FK_RUBRICA_CLIENTE FOREIGN KEY (CF) REFERENCES CLIENTE(CF)
);

create table DATI_ANAGRAFICI  
(  
    CF           VARCHAR2(16) not NULL UNIQUE,  
    NOME         VARCHAR2(50)  not null,  
    COGNOME      VARCHAR2(50)  not null,  
    DATAN        DATE          not null,  
    NUMERO_TEL_1 VARCHAR2(12)  not null,
   CONSTRAINT FK_DATI_ANAGRAFICI_CLIENTE FOREIGN KEY (CF) REFERENCES CLIENTE(CF)
);

create table BOX 
( 
    EAN_BOX         VARCHAR2(13) PRIMARY KEY, 
    NOME_BOX        VARCHAR2(255) NOT NULL, 
    CATEGORIA_BOX   VARCHAR2(255) DEFAULT NULL, 
    PORZIONI        NUMBER(1)     NOT NULL, 
    QUANTITA_IN_BOX NUMBER(3)     NOT NULL, 
    PREZZO_BOX      NUMBER(5, 2)  NOT NULL 
);

CREATE TABLE VALORI_NUTRIZIONALI (
    EAN_BOX  VARCHAR2(13) not null UNIQUE,
    PROTEINE NUMBER(5, 2) CHECK (PROTEINE >= 0) not null,
    CARBOIDRATI NUMBER(5, 2) CHECK (CARBOIDRATI >= 0) not null,
    ZUCCHERI NUMBER(5, 2) CHECK (ZUCCHERI >= 0) not null,
    FIBRE NUMBER(5, 2) CHECK (FIBRE >= 0) not null,
    GRASSI NUMBER(5, 2) CHECK (GRASSI >= 0) not null,
    SALE NUMBER(5, 2) CHECK (SALE >= 0) not null,
    CHILOCALORIE NUMBER(5) CHECK (CHILOCALORIE >= 0) not null,
    CONSTRAINT FK_VALORI_NUTRIZIONALI_BOX FOREIGN KEY (EAN_BOX) REFERENCES BOX(EAN_BOX)
);

create table ALLERGENI 
( 
    NOME_ALLERGENE        VARCHAR2(255) NOT NULL, 
    DESCRIZIONE_ALLERGENE VARCHAR2(255) DEFAULT NULL, 
    EAN_BOX   VARCHAR2(13)  NOT NULL, 
    CONSTRAINT FK_ALLERGENI_EAN_BOX FOREIGN KEY (EAN_BOX) REFERENCES BOX(EAN_BOX) 
);

create table MAGAZZINO 
( 
    NOME_MAGAZZINO VARCHAR2(20)
        constraint PK_MAGAZZINO 
            primary key, 
    VIA_MAG          VARCHAR2(100) not null, 
    CIVICO_MAG       VARCHAR2(6)   not null, 
    CAP_MAG VARCHAR2(10) CHECK (LENGTH(CAP_MAG) = 5) not null, 
    CITTA_MAG        VARCHAR2(100) not null, 
    PROVINCIA_MAG    VARCHAR2(4)   not null 
);

create table FORNITORE 
( 
    PARTITAIVA    VARCHAR2(11)  not null 
        constraint PK_FORNITORE 
            primary key, 
    NOME_FORNITORE    VARCHAR2(255) not null, 
    VIA_FOR       VARCHAR2(100) not NULL, 
    CIVICO_FOR    VARCHAR2(6)   not NULL, 
    CITTA_FOR     VARCHAR2(100) not NULL, 
    PROVINCIA_FOR VARCHAR2(4)   not NULL, 
    CAP_FOR VARCHAR2(10) CHECK (LENGTH(CAP_FOR) = 5) not null 
);

create table INGREDIENTE 
( 
    EAN_INGREDIENTE    VARCHAR2(13) not null 
        constraint PK_INGREDIENTE 
            primary key, 
    DESC_INGREDIENTE   VARCHAR2(255) default NULL, 
    NOME_INGREDIENTE   VARCHAR2(255) not NULL, 
    PREZZO_INGREDIENTE NUMBER(5, 2)  not NULL, 
    PARTITAIVA         VARCHAR2(11)  not NULL, 
     CONSTRAINT FK_INGREDIENTE  FOREIGN KEY (PARTITAIVA) REFERENCES FORNITORE(PARTITAIVA) 
);

CREATE TABLE INGREDIENTE_MAGAZZINO (
    DATA_INGRESSO DATE DEFAULT NULL,
    LOTTO VARCHAR2(10) DEFAULT NULL,
    QUANTITA_INGREDIENTE NUMBER(5) NOT NULL,
    EAN_INGREDIENTE VARCHAR2(13) NOT NULL,
    NOME_MAG VARCHAR2(20) NOT NULL,
    CONSTRAINT FK_INGREDIENTE_MAG_EAN_INGREDIENTE FOREIGN KEY (EAN_INGREDIENTE) REFERENCES INGREDIENTE(EAN_INGREDIENTE),
    CONSTRAINT FK_INGREDIENTE_MAG_NOME_MAG FOREIGN KEY (NOME_MAG) REFERENCES MAGAZZINO(NOME_MAGAZZINO),
    CONSTRAINT PK_INGREDIENTE_MAGAZZINO PRIMARY KEY (EAN_INGREDIENTE, NOME_MAG)  -- Chiave primaria composta
);

CREATE TABLE COMPOSIZIONE_BOX (
    EAN_BOX VARCHAR2(13) NOT NULL,
    EAN_INGREDIENTE VARCHAR2(13) NOT NULL,
    CONSTRAINT FK_COMP_EAN_BOX FOREIGN KEY (EAN_BOX) REFERENCES BOX(EAN_BOX),
    CONSTRAINT FK_COMP_EAN_INGREDIENTE FOREIGN KEY (EAN_INGREDIENTE) REFERENCES INGREDIENTE(EAN_INGREDIENTE),
    CONSTRAINT PK_COMPOSIZIONE_BOX PRIMARY KEY (EAN_BOX, EAN_INGREDIENTE)  -- Chiave primaria composta
);


CREATE TABLE CARRELLO (
    CF                         VARCHAR2(16)   NOT NULL,  -- Codice Fiscale del cliente
    EAN_BOX                    VARCHAR2(13)   NOT NULL,  -- Codice del prodotto
    QUANTITA_IN_CARRELLO       NUMBER(3)      NOT NULL,  -- Quantità del prodotto
    PREZZO_BOX_UNITARIO_CARRELLO NUMBER(5, 2) NOT NULL,  -- Prezzo unitario del prodotto
    CONSTRAINT FK_CARRELLO_CF  FOREIGN KEY (CF) REFERENCES CLIENTE(CF),
    CONSTRAINT FK_CARRELLO_EAN_BOX FOREIGN KEY (EAN_BOX) REFERENCES BOX(EAN_BOX),
    CONSTRAINT PK_CARRELLO PRIMARY KEY (CF, EAN_BOX)  -- Chiave primaria composta da CF e EAN_BOX
);

CREATE TABLE SCONTI 
( 
    ID_SCONTO     NUMBER(11) 
        CONSTRAINT PK_SCONTI 
            PRIMARY KEY, 
    VALORE        NUMBER(3) not NULL, 
    INIZIO_SCONTO DATE       not NULL, 
    FINESCONTO    DATE       not NULL,
    CONSTRAINT CHK_DATE_SCONTI 
        CHECK (INIZIO_SCONTO < FINESCONTO)
);

create table ORDINE 
( 
    ID_ORDINE       VARCHAR2(30)
		constraint PK_ORDINE 
			primary key, 
    DATA_ORDINE     DATE         default NULL, 
    TOTALE_PREZZO   NUMBER(5, 2) not null, 
    TOTALE_QUANTITA NUMBER(2)    not null, 
    STATO_ORDINE    NUMBER(1)    default NULL check (Stato_ordine IN (1, 2, 3, 4)), 
    CF   VARCHAR2(16) NOT NULL, 
    CONSTRAINT FK_ID_ORDINE_ORDINE  FOREIGN KEY (CF) REFERENCES CLIENTE(CF), 
    ID_SCONTO       NUMBER(11)   NOT NULL,
    CONSTRAINT FK_ORDINE_ID_SCONTO  FOREIGN KEY (ID_SCONTO ) REFERENCES SCONTI(ID_SCONTO )
);

CREATE TABLE DETTAGLI_ORDINE (
    ID_ORDINE VARCHAR2(30) NOT NULL,
    EAN_BOX VARCHAR2(13) NOT NULL,
    QUANTITA_BOX_DETTAGLI NUMBER(2) NOT NULL,
    PREZZO_BOX_DETTAGLI NUMBER(4, 2) NOT NULL,
    CONSTRAINT FK_DETTAGLI_ORDINE_ID_ORDINE FOREIGN KEY (ID_ORDINE) REFERENCES ORDINE(ID_ORDINE),
    CONSTRAINT FK_DETTAGLI_ORDINE_EAN_BOX FOREIGN KEY (EAN_BOX) REFERENCES BOX(EAN_BOX),
    CONSTRAINT PK_DETTAGLI_ORDINE PRIMARY KEY (ID_ORDINE, EAN_BOX)  -- Chiave primaria composta
);



create table FATTURA 
( 
    METODO_PAGAMENTO VARCHAR2(50)  default NULL, 
    DATA_PAGAMENTO   DATE          default NULL, 
    IMPORTO          NUMBER(10, 2) default NULL, 
    ID_ORDINE        VARCHAR2(30)   not NULL UNIQUE,
    CONSTRAINT FK_FATTURA_ID_ORDINE FOREIGN KEY (ID_ORDINE) REFERENCES ORDINE(ID_ORDINE)
);

create table SPEDIZIONE 
(  
    CORRIERE         VARCHAR2(100) not NULL, 
    STATO_SPEDIZIONE VARCHAR2(10)  not NULL check (Stato_spedizione IN ('1', '2', '3','4')), -- 1 in lavorazione , 2 spedito , 3 consegnato, 4 cancellata 
    ID_ORDINE        VARCHAR2(30)    not NULL UNIQUE,
    CONSTRAINT FK_SPEDIZIONE_ID_ORDINE FOREIGN KEY (ID_ORDINE) REFERENCES ORDINE(ID_ORDINE), 
    VIA_SPEDIZIONE                 VARCHAR2(100) not null, 
    CIVICO_SPEDIZIONE           VARCHAR2(6)   not null, 
    CAP_SPEDIZIONE                NUMBER(5)     not null, 
    CITTA_SPEDIZIONE             VARCHAR2(100) not null, 
    PROVINCIA_SPEDIZIONE    VARCHAR2(4)   not null 
);

create FUNCTION calcola_importo_scontato( 
    prezzo_iniziale   IN NUMBER, 
    sconto_percentuale IN NUMBER 
) 
RETURN NUMBER 
IS 
    prezzo_finale NUMBER; 
BEGIN 
    -- Verifica se lo sconto è valido (deve essere compreso tra 0 e 100) 
    IF sconto_percentuale < 0 OR sconto_percentuale > 100 THEN 
        RETURN NULL; 
    ELSE 
        -- Calcolo del prezzo finale applicando lo sconto 
        prezzo_finale := prezzo_iniziale - (prezzo_iniziale * (sconto_percentuale / 100)); 
        RETURN prezzo_finale; 
    END IF; 
END; 
/

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
        -- l'e-commerce si affida esclusivamente a Bartolini
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
        RAISE_APPLICATION_ERROR(-20018, 'Errore: l email inserita è già registrata.');
   WHEN OTHERS THEN  
        RAISE_APPLICATION_ERROR(-20099, 'Errore sconosciuto: ' || SQLERRM); 
END;
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

CREATE OR REPLACE FUNCTION Genera_Id_Ordine(p_cf VARCHAR2, p_data DATE) 
RETURN VARCHAR2 
IS
    v_id_ordine VARCHAR2(50);
BEGIN
    -- Formattazione della data con ore, minuti e secondi
    v_id_ordine := p_cf || TO_CHAR(p_data, 'YYYYMMDDHHMISS');
    RETURN v_id_ordine;
END;
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
           CALCOLA_IMPORTO_SCONTATO(importo_da_scontare ,percentuale_sconto),  --richiamo funzione
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


