# Alimentari Parthenope 

## Introduzione

[cite_start]**Alimentari Parthenope** è un progetto universitario sviluppato per il corso di "Basi di Dati e Laboratorio" presso l'**Università degli studi di Napoli Parthenope** per l'anno accademico 2024-2025[cite: 1, 2, 6]. [cite_start]Il progetto è stato realizzato dagli studenti Santo Femiano e Salvatore Parmendola[cite: 5].

[cite_start]L'obiettivo principale è la progettazione e l'implementazione di un database per un innovativo **e-commerce italiano** specializzato nella vendita di **box alimentari**[cite: 12]. [cite_start]Il sistema è stato concepito per gestire in modo efficiente la composizione delle box, gli ingredienti disponibili e le preferenze dei clienti, al fine di semplificare e ottimizzare l'esperienza di acquisto[cite: 13, 14].

---

## Progettazione del Database

[cite_start]Il design del database è stato strutturato per supportare tutte le funzionalità dell'e-commerce, dalla registrazione del cliente fino alla gestione degli ordini e delle spedizioni[cite: 17, 18].

### Requisiti Funzionali

* [cite_start]**Registrazione Obbligatoria**: I clienti devono essere registrati per poter effettuare acquisti[cite: 19].
* [cite_start]**Identificazione del Cliente**: Il database identifica i clienti tramite il codice fiscale, poiché il servizio opera esclusivamente in Italia[cite: 20].
* [cite_start]**Gestione del Profilo**: I clienti possono inserire e gestire i propri dati anagrafici e gli indirizzi di spedizione[cite: 21, 23, 25].
* [cite_start]**Catalogo Prodotti**: Il sistema offre un catalogo di box completo di dettagli su valori nutrizionali e allergeni[cite: 26].
* [cite_start]**Carrello**: Ogni cliente ha a disposizione un carrello personale per aggiungere prodotti e visualizzare il totale[cite: 28, 29].
* [cite_start]**Ordini**: La piattaforma gestisce la creazione degli ordini, a cui vengono associati una fattura e una spedizione[cite: 30, 31]. [cite_start]È possibile applicare codici sconto validi[cite: 32].

### Diagrammi

Il progetto include:
1.  [cite_start]Un **Diagramma Entità-Relazione (E/R)** che modella le entità chiave come `Cliente`, `Box`, `Ordine`, `Ingrediente` e le loro associazioni[cite: 39].
2.  [cite_start]Un **Diagramma Relazionale** che traduce il modello E/R in uno schema di tabelle concreto per il database[cite: 57].

### Normalizzazione

[cite_start]Il database è stato normalizzato fino alla **Terza Forma Normale (3NF)** per eliminare le ridondanze e migliorare l'integrità dei dati[cite: 308, 316, 325].
* [cite_start]**1NF**: Tutte le tabelle contengono valori atomici e ogni record è identificato da una chiave primaria univoca[cite: 310, 312].
* [cite_start]**2NF**: Non esistono dipendenze parziali; gli attributi non-chiave dipendono interamente dalla chiave primaria composta[cite: 318, 319, 320].
* [cite_start]**3NF**: Sono state eliminate le dipendenze transitive, assicurando che ogni attributo non-chiave dipenda direttamente e unicamente dalla chiave primaria[cite: 327, 328].

---

## Implementazione

Il sistema è stato implementato utilizzando SQL, con un focus sulla definizione dei dati (DDL), sulla manipolazione (DML) e sulla logica di business tramite procedure, funzioni e trigger.

### Struttura delle Tabelle (DDL)

Sono state create diverse tabelle per archiviare le informazioni, tra cui:
* [cite_start]`CLIENTE`: Memorizza i dati di registrazione dei clienti, con il `CF` come chiave primaria[cite: 347].
* [cite_start]`RUBRICA_INDIRIZZI`: Gestisce gli indirizzi di spedizione associati ai clienti[cite: 372].
* [cite_start]`BOX`: Contiene le informazioni sui prodotti (box) offerti, identificati da un codice `EAN_BOX`[cite: 406].
* [cite_start]`INGREDIENTE`: Elenca tutti gli ingredienti disponibili[cite: 477].
* [cite_start]`ORDINE`: Registra gli ordini effettuati dai clienti[cite: 554].
* [cite_start]`SPEDIZIONE`: Gestisce le informazioni di spedizione per ogni ordine[cite: 605].
* [cite_start]`FATTURA`: Archivia i dettagli di fatturazione degli ordini[cite: 582].

### Ruoli Utente

Sono stati definiti tre ruoli utente con diversi livelli di privilegi:
1.  [cite_start]**Admin**: Ha il controllo completo su tutte le tabelle e funzionalità del database[cite: 151]. [cite_start]Può gestire clienti, dipendenti, prodotti, ordini e la configurazione del sistema[cite: 151, 153, 156, 158].
2.  [cite_start]**Dipendente**: Può gestire il catalogo prodotti, l'inventario e lo stato degli ordini e delle spedizioni[cite: 171, 174, 176, 178]. [cite_start]Non ha accesso ai dati personali sensibili dei clienti o alle informazioni finanziarie[cite: 179, 180].
3.  [cite_start]**Cliente**: Può consultare il catalogo, gestire il proprio profilo e il carrello, ed effettuare ordini[cite: 199, 200, 202, 204]. [cite_start]Ha accesso solo ai propri dati[cite: 204, 205].

### Logica di Business (Trigger e Procedure)

Sono stati implementati vari componenti PL/SQL per automatizzare i processi e garantire l'integrità dei dati:
* **Trigger**:
    * [cite_start]`PREZZO_UNITARIO_CARRELLO`: Assegna automaticamente il prezzo a un prodotto quando viene aggiunto al carrello[cite: 699].
    * [cite_start]`CONTROLLO_DISPONIBILITA_BOX`: Verifica la disponibilità di una box prima di inserirla nel carrello[cite: 752].
    * [cite_start]`PREVENZIONE_CANCELLAZIONE_CLIENTE`: Impedisce l'eliminazione di un cliente se ha ordini associati[cite: 776].
    * [cite_start]`INIZIALIZZA_SPEDIZIONE`: Crea automaticamente un record di spedizione dopo la creazione di un ordine[cite: 857].
* **Procedure**:
    * [cite_start]`Effettua_ordine`: Gestisce il processo di acquisto finale, spostando i prodotti dal carrello a un ordine confermato[cite: 1018].
    * [cite_start]`Aggiungi_Cliente`: Registra un nuovo cliente nel sistema, verificando l'unicità dei dati[cite: 1124].
    * [cite_start]`mostra_composizione_box`: Mostra gli ingredienti contenuti in una specifica box[cite: 1083].
    * [cite_start]`gestisci_clienti_inattivi`: Invia avvisi o cancella i clienti che non hanno effettuato ordini per un lungo periodo[cite: 1344].
* **Viste (Views)**:
    * [cite_start]`storico_ordini_cliente`: Fornisce una panoramica completa degli ordini effettuati dai clienti[cite: 897].
    * [cite_start]`box_senza_lattosio`: Mostra un elenco di box che non contengono lattosio[cite: 906].
    * [cite_start]`box_alto_contenuto_proteine`: Filtra le box con un contenuto proteico superiore a 10 grammi[cite: 912].

### Gestione degli Errori

[cite_start]Il progetto include un manuale dettagliato di codici di errore personalizzati (da -20000 a -20099) per facilitare il debug e la gestione delle eccezioni nel database[cite: 1379].

***

# Project Summary: Alimentari Parthenope (English)

## Introduction

[cite_start]**Alimentari Parthenope** is a university project developed for the "Database and Laboratory" course at the **University of Naples Parthenope** for the 2024-2025 academic year[cite: 1, 2, 6]. [cite_start]The project was created by students Santo Femiano and Salvatore Parmendola[cite: 5].

[cite_start]The main objective is the design and implementation of a database for an innovative **Italian e-commerce** platform specializing in the sale of **food boxes**[cite: 12]. [cite_start]The system is designed to efficiently manage the composition of the boxes, available ingredients, and customer preferences to simplify and optimize the user shopping experience[cite: 13, 14].

---

## Database Design

[cite_start]The database design is structured to support all e-commerce functionalities, from customer registration to order and shipment management[cite: 17, 18].

### Functional Requirements

* [cite_start]**Mandatory Registration**: Customers must be registered to make purchases[cite: 19].
* [cite_start]**Customer Identification**: The database uses the Italian fiscal code (`Codice Fiscale`) as a unique identifier for customers, as the service operates exclusively in Italy[cite: 20].
* [cite_start]**Profile Management**: Customers can enter and manage their personal data and shipping addresses[cite: 21, 23, 25].
* [cite_start]**Product Catalog**: The system provides a catalog of boxes with details on nutritional values and allergens[cite: 26].
* [cite_start]**Shopping Cart**: Each customer has a personal shopping cart to add products and view the total[cite: 28, 29].
* [cite_start]**Orders**: The platform manages order creation, associating an invoice and a shipment with each one[cite: 30, 31]. [cite_start]Valid discount codes can be applied[cite: 32].

### Diagrams

The project includes:
1.  [cite_start]An **Entity-Relationship (E/R) Diagram** that models key entities such as `Cliente` (Customer), `Box`, `Ordine` (Order), `Ingrediente` (Ingredient), and their relationships[cite: 39].
2.  [cite_start]A **Relational Diagram** that translates the E/R model into a concrete table schema for the database[cite: 57].

### Normalization

[cite_start]The database is normalized up to the **Third Normal Form (3NF)** to eliminate redundancy and improve data integrity[cite: 308, 316, 325].
* [cite_start]**1NF**: All table values are atomic, and each record is identified by a unique primary key[cite: 310, 312].
* [cite_start]**2NF**: There are no partial dependencies; non-key attributes are fully dependent on the composite primary key[cite: 318, 319, 320].
* [cite_start]**3NF**: Transitive dependencies have been eliminated, ensuring that every non-key attribute is directly and solely dependent on the primary key[cite: 327, 328].

---

## Implementation

The system is implemented using SQL, with a focus on Data Definition Language (DDL), Data Manipulation Language (DML), and business logic through procedures, functions, and triggers.

### Table Structure (DDL)

Several tables have been created to store information, including:
* [cite_start]`CLIENTE`: Stores customer registration data, with `CF` (fiscal code) as the primary key[cite: 347].
* [cite_start]`RUBRICA_INDIRIZZI`: Manages shipping addresses associated with customers[cite: 372].
* [cite_start]`BOX`: Contains information about the products (boxes) offered, identified by an `EAN_BOX` code[cite: 406].
* [cite_start]`INGREDIENTE`: Lists all available ingredients[cite: 477].
* [cite_start]`ORDINE`: Records orders placed by customers[cite: 554].
* [cite_start]`SPEDIZIONE`: Manages shipping information for each order[cite: 605].
* [cite_start]`FATTURA`: Stores billing details for orders[cite: 582].

### User Roles

Three user roles with different privilege levels have been defined:
1.  [cite_start]**Admin**: Has full control over all database tables and functionalities[cite: 151]. [cite_start]Can manage customers, employees, products, orders, and system settings[cite: 151, 153, 156, 158].
2.  [cite_start]**Dipendente (Employee)**: Can manage the product catalog, inventory, and the status of orders and shipments[cite: 171, 174, 176, 178]. [cite_start]Does not have access to sensitive customer personal data or financial information[cite: 179, 180].
3.  [cite_start]**Cliente (Customer)**: Can browse the catalog, manage their profile and shopping cart, and place orders[cite: 199, 200, 202, 204]. [cite_start]Has access only to their own data[cite: 204, 205].

### Business Logic (Triggers and Procedures)

Various PL/SQL components have been implemented to automate processes and ensure data integrity:
* **Triggers**:
    * [cite_start]`PREZZO_UNITARIO_CARRELLO`: Automatically assigns the price to a product when it is added to the cart[cite: 699].
    * [cite_start]`CONTROLLO_DISPONIBILITA_BOX`: Checks the availability of a box before adding it to the cart[cite: 752].
    * [cite_start]`PREVENZIONE_CANCELLAZIONE_CLIENTE`: Prevents the deletion of a customer if they have associated orders[cite: 776].
    * [cite_start]`INIZIALIZZA_SPEDIZIONE`: Automatically creates a shipping record after an order is created[cite: 857].
* **Procedures**:
    * [cite_start]`Effettua_ordine`: Manages the final checkout process, moving products from the cart to a confirmed order[cite: 1018].
    * [cite_start]`Aggiungi_Cliente`: Registers a new customer in the system, verifying data uniqueness[cite: 1124].
    * [cite_start]`mostra_composizione_box`: Displays the ingredients contained in a specific box[cite: 1083].
    * [cite_start]`gestisci_clienti_inattivi`: Sends warnings to or deletes customers who have not placed orders for a long period[cite: 1344].
* **Views**:
    * [cite_start]`storico_ordini_cliente`: Provides a complete overview of orders placed by customers[cite: 897].
    * [cite_start]`box_senza_lattosio`: Displays a list of boxes that do not contain lactose[cite: 906].
    * [cite_start]`box_alto_contenuto_proteine`: Filters for boxes with a protein content higher than 10 grams[cite: 912].

### Error Handling

[cite_start]The project includes a detailed manual of custom error codes (from -20000 to -20099) to facilitate debugging and exception handling in the database[cite: 1379].
