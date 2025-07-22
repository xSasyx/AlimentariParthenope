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

