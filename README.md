# Alimentari Parthenope

> This is a university project for the "Database and Laboratory" course at the **University of Naples Parthenope** (2024-2025 academic year), develope by Salvatore Parmendola.

The main goal is the design and implementation of a database for an innovative **Italian e-commerce** platform specializing in the sale of **food boxes**. The system is engineered to efficiently manage box compositions, available ingredients, and customer preferences to streamline and enhance the shopping experience.

---

##  Database Design

The database design supports all core e-commerce functionalities, from customer registration to order and shipment management.

### Functional Requirements

* **Mandatory Registration**: Customers must register to make purchases.
* **Customer Identification**: The system uses the Italian fiscal code (`Codice Fiscale`) as the unique customer identifier.
* **Profile Management**: Customers can manage their personal data and multiple shipping addresses.
* **Product Catalog**: A detailed catalog of boxes is available, including nutritional values and allergens.
* **Shopping Cart**: Each customer has a personal cart to add products, modify quantities, and see the total.
* **Orders**: The platform handles order creation, associating an invoice and a shipment with each transaction. Valid discount codes can be applied during checkout.

### Diagrams

The project includes:
1.  An **Entity-Relationship (E/R) Diagram** modeling key entities like `Cliente` (Customer), `Box`, `Ordine` (Order), `Ingrediente` (Ingredient), and their relationships.
2.  A **Relational Diagram** that translates the E/R model into a concrete database table schema.

### Normalization

The database is normalized to the **Third Normal Form (3NF)** to reduce redundancy and improve data integrity.
* **1NF**: All tables contain atomic values, and each record has a unique primary key.
* **2NF**: No partial dependencies exist in tables with composite primary keys.
* **3NF**: Transitive dependencies are eliminated, ensuring non-key attributes depend directly on the primary key.

---

##  Implementation

The system is implemented using SQL, with a strong focus on Data Definition Language (DDL), Data Manipulation Language (DML), and business logic through procedures, functions, and triggers.

### Table Structure (DDL)

Key tables created to store information include:
* `CLIENTE`: Stores customer registration data, using `CF` as the primary key.
* `RUBRICA_INDIRIZZI`: Manages shipping addresses associated with customers.
* `BOX`: Contains information about the food boxes offered, identified by an `EAN_BOX` code.
* `ORDINE`: Records all orders placed by customers.
* `SPEDIZIONE`: Manages shipping information for each order.
* `FATTURA`: Stores billing details for each order.

### User Roles

Three user roles with distinct privilege levels have been defined:
1.  **Admin**: Has full control over all database tables and functionalities. Can manage customers, employees, products, orders, and system settings.
2.  **Dipendente (Employee)**: Can manage the product catalog, inventory, and the status of orders and shipments. They do not have access to sensitive customer data or financial information.
3.  **Cliente (Customer)**: Can browse the catalog, manage their profile and cart, and place orders. They only have access to their own data.

### Business Logic (Triggers and Procedures)

Various PL/SQL components automate processes and ensure data integrity:
* **Triggers**:
    * `PREZZO_UNITARIO_CARRELLO`: Automatically assigns the price to a product when added to the cart.
    * `CONTROLLO_DISPONIBILITA_BOX`: Checks box availability before adding it to the cart.
    * `PREVENZIONE_CANCELLAZIONE_CLIENTE`: Prevents deleting a customer with associated orders.
    * `INIZIALIZZA_SPEDIZIONE`: Automatically creates a shipping record when an order is placed.
* **Procedures**:
    * `Effettua_ordine`: Manages the final checkout process, moving items from the cart to a confirmed order.
    * `Aggiungi_Cliente`: Registers a new customer, verifying data uniqueness.
    * `mostra_composizione_box`: Displays the ingredients of a specific box.
    * `gestisci_clienti_inattivi`: Manages users who have been inactive for a long time.
* **Views**:
    * `storico_ordini_cliente`: Provides a comprehensive history of customer orders.
    * `box_senza_lattosio`: Lists all boxes that do not contain lactose.
    * `box_alto_contenuto_proteine`: Filters for boxes with a protein content higher than 10 grams.

### Error Handling

The project includes a detailed manual of custom error codes (from `-20000` to `-20099`) to facilitate debugging and exception handling.

***

<br>

# Alimentari Parthenope

> Questo è un progetto universitario sviluppato per il corso di "Basi di Dati e Laboratorio" presso l'**Università degli studi di Napoli Parthenope** (anno accademico 2024-2025), realizzato da Salvatore Parmendola.

L'obiettivo principale è la progettazione e l'implementazione di un database per un innovativo **e-commerce italiano** specializzato nella vendita di **box alimentari**. Il sistema è stato concepito per gestire in modo efficiente la composizione delle box, gli ingredienti disponibili e le preferenze dei clienti, al fine di semplificare e ottimizzare l'esperienza di acquisto.

---

##  Progettazione del Database

Il design del database è stato strutturato per supportare tutte le funzionalità dell'e-commerce, dalla registrazione del cliente fino alla gestione degli ordini e delle spedizioni.

### Requisiti Funzionali

* **Registrazione Obbligatoria**: I clienti devono essere registrati per poter effettuare acquisti.
* **Identificazione del Cliente**: Il database identifica i clienti tramite il `Codice Fiscale`, poiché il servizio opera esclusivamente in Italia.
* **Gestione del Profilo**: I clienti possono inserire e gestire i propri dati anagrafici e più indirizzi di spedizione.
* **Catalogo Prodotti**: Il sistema offre un catalogo di box completo di dettagli su valori nutrizionali e allergeni.
* **Carrello**: Ogni cliente ha a disposizione un carrello personale per aggiungere prodotti, modificare le quantità e visualizzare il totale.
* **Ordini**: La piattaforma gestisce la creazione degli ordini, a cui vengono associati una fattura e una spedizione. È possibile applicare codici sconto validi.

### Diagrammi

Il progetto include:
1.  Un **Diagramma Entità-Relazione (E/R)** che modella le entità chiave come `Cliente`, `Box`, `Ordine`, `Ingrediente` e le loro associazioni.
2.  Un **Diagramma Relazionale** che traduce il modello E/R in uno schema di tabelle concreto per il database.

### Normalizzazione

Il database è stato normalizzato fino alla **Terza Forma Normale (3NF)** per eliminare le ridondanze e migliorare l'integrità dei dati.
* **1NF**: Tutte le tabelle contengono valori atomici e ogni record è identificato da una chiave primaria univoca.
* **2NF**: Non esistono dipendenze parziali; gli attributi non-chiave dipendono interamente dalla chiave primaria composta.
* **3NF**: Sono state eliminate le dipendenze transitive, assicurando che ogni attributo non-chiave dipenda direttamente e unicamente dalla chiave primaria.

---

##  Implementazione

Il sistema è stato implementato utilizzando SQL, con un focus sulla definizione dei dati (DDL), sulla manipolazione (DML) e sulla logica di business tramite procedure, funzioni e trigger.

### Struttura delle Tabelle (DDL)

Sono state create diverse tabelle per archiviare le informazioni, tra cui:
* `CLIENTE`: Memorizza i dati di registrazione dei clienti, con il `CF` come chiave primaria.
* `RUBRICA_INDIRIZZI`: Gestisce gli indirizzi di spedizione associati ai clienti.
* `BOX`: Contiene le informazioni sui prodotti (box) offerti, identificati da un codice `EAN_BOX`.
* `ORDINE`: Registra gli ordini effettuati dai clienti.
* `SPEDIZIONE`: Gestisce le informazioni di spedizione per ogni ordine.
* `FATTURA`: Archivia i dettagli di fatturazione degli ordini.

### Ruoli Utente

Sono stati definiti tre ruoli utente con diversi livelli di privilegi:
1.  **Admin**: Ha il controllo completo su tutte le tabelle e funzionalità del database. Può gestire clienti, dipendenti, prodotti, ordini e la configurazione del sistema.
2.  **Dipendente**: Può gestire il catalogo prodotti, l'inventario e lo stato degli ordini e delle spedizioni. Non ha accesso ai dati personali sensibili dei clienti o alle informazioni finanziarie.
3.  **Cliente**: Può consultare il catalogo, gestire il proprio profilo e il carrello, ed effettuare ordini. Ha accesso solo ai propri dati.

### Logica di Business (Trigger e Procedure)

Sono stati implementati vari componenti PL/SQL per automatizzare i processi e garantire l'integrità dei dati:
* **Trigger**:
    * `PREZZO_UNITARIO_CARRELLO`: Assegna automaticamente il prezzo a un prodotto quando viene aggiunto al carrello.
    * `CONTROLLO_DISPONIBILITA_BOX`: Verifica la disponibilità di una box prima di inserirla nel carrello.
    * `PREVENZIONE_CANCELLAZIONE_CLIENTE`: Impedisce l'eliminazione di un cliente se ha ordini associati.
    * `INIZIALIZZA_SPEDIZIONE`: Crea automaticamente un record di spedizione dopo la creazione di un ordine.
* **Procedure**:
    * `Effettua_ordine`: Gestisce il processo di acquisto finale, spostando i prodotti dal carrello a un ordine confermato.
    * `Aggiungi_Cliente`: Registra un nuovo cliente nel sistema, verificando l'unicità dei dati.
    * `mostra_composizione_box`: Mostra gli ingredienti contenuti in una specifica box.
    * `gestisci_clienti_inattivi`: Invia avvisi o cancella i clienti che non hanno effettuato ordini per un lungo periodo.
* **Viste (Views)**:
    * `storico_ordini_cliente`: Fornisce una panoramica completa degli ordini effettuati dai clienti.
    * `box_senza_lattosio`: Mostra un elenco di box che non contengono lattosio.
    * `box_alto_contenuto_proteine`: Filtra le box con un contenuto proteico superiore a 10 grammi.

### Gestione degli Errori

Il progetto include un manuale dettagliato di codici di errore personalizzati (da `-20000` a `-20099`) per facilitare il debug e la gestione delle eccezioni nel database.
