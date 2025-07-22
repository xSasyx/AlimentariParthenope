-- Utente: Admin

CREATE USER admin_ alimentari IDENTIFIED BY admin; 
GRANT ALL PRIVILEGES TO admin_alimentari; 

-- L’utente admin è l’utente che rappresenta gli amministratori del sistema dell’e-commerce. 
-- Gli admin hanno accesso completo a tutte le tabelle e funzionalità del database.
-- Possono visualizzare, inserire, aggiornare e cancellare dati in qualsiasi tabella, 
-- garantendo il controllo totale sull’intero sistema. Questo include la gestione dei 
-- clienti, dei dipendenti e dei fornitori, nonché la supervisione degli ordini, del 
-- magazzino e delle spedizioni. Gli admin possono gestire i profili dei clienti e dei 
-- dipendenti, modificandone attributi come password, indirizzi e altri dettagli personali 
-- o lavorativi. Inoltre, hanno la possibilità di creare, aggiornare e rimuovere account di 
-- dipendenti e clienti. 

-------------------------------------------------------------

--Utente: Dipendente 

CREATE USER dipendente IDENTIFIED BY Password_dipendente; 

GRANT CONNECT TO dipendente; 

GRANT CREATE SESSION TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON BOX TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON VALORI_NUTRIZIONALI TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON ALLERGENI TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON COMPOSIZIONE_BOX TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON INGREDIENTE TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON INGREDIENTE_MAGAZZINO TO dipendente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON MAGAZZINO TO dipendente; 

GRANT SELECT, UPDATE ON FORNITORE TO dipendente; 

GRANT SELECT, UPDATE ON ORDINE TO dipendente; 

GRANT SELECT ON DETTAGLI_ORDINE TO dipendente; 

GRANT SELECT, UPDATE ON SPEDIZIONE TO dipendente; 


-- L’utente dipendente è l’utente che rappresenta i dipendenti operativi dell’e-commerce. 
-- I dipendenti hanno accesso alle tabelle che gestiscono il catalogo dei prodotti, inclusi i dettagli relativi ai valori nutrizionali, 
-- agli allergeni e alla composizione dei box.Possono inserire nuovi prodotti, aggiornare quelli esistenti e rimuovere prodotti obsoleti. 
-- Questo accesso consente loro di mantenere aggiornato il catalogo in base alle esigenze aziendali.

-------------------------------------------------------------
--Utente: Cliente 


CREATE USER cliente IDENTIFIED BY password_cliente; 

GRANT CREATE SESSION TO cliente;  

GRANT SELECT ON BOX TO cliente; 

GRANT SELECT ON VALORI_NUTRIZIONALI TO cliente; 

GRANT SELECT ON ALLERGENI TO cliente; 

GRANT SELECT ON INGREDIENTI TO cliente 

GRANT SELECT ON COMPOSIZIONE_BOX TO cliente 

GRANT SELECT ON SCONTI TO cliente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON CLIENTE TO cliente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON DATI_ANAGRAFICI TO cliente; 

GRANT SELECT, INSERT, UPDATE, DELETE ON RUBRICA_INDIRIZZI TO cliente;  

GRANT SELECT, INSERT, UPDATE, DELETE ON CARRELLO TO cliente; 

GRANT SELECT ON ORDINE TO cliente; 

GRANT SELECT ON DETTAGLI_ORDINE TO cliente; 

GRANT SELECT ON SPEDIZIONE TO cliente; 

GRANT SELECT ON FATTURA TO cliente; 
GRANT SELECT ON box_senza_lattosio TO cliente; 

GRANT SELECT ON box_alto_contenuto_proteine TO cliente; 

GRANT EXECUTE ON effettua_ordine TO cliente; 

GRANT EXECUTE ON mostra_box_da_ingrediente TO cliente; 
GRANT EXECUTE ON Aggiungi_Dati_Anagrafici TO cliente; 
GRANT EXECUTE ON Aggiungi_Indirizzo TO cliente; 

GRANT EXECUTE ON mostra_composizione_box TO cliente; 

-- L’utente cliente è l’utente che rappresenta i clienti registrati dell’e-commerce. 
-- I clienti possono consultare il catalogo dei prodotti disponibili, visualizzandone i dettagli,
-- come le informazioni nutrizionali e gli allergeni associati, ma non possono in alcun modo 
-- modificare o inserire nuovi prodotti nel sistema. 
 