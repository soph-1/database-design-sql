# Database Design – Organizzazione Eventi

## 📌 Overview

Progetto universitario per la gestione di eventi e pacchetti di acquisto che dimostra la progettazione di un database relazionale completo e ben strutturato.

L'applicazione include:

- Gestione di utenti, artisti, categorie e eventi
- Pacchetti disponibili per ogni evento
- Acquisti con calcolo automatico del prezzo e controllo disponibilità
- Promozioni e sconti gestiti tramite codici promo

Lo schema ER completo è incluso nella repository per mostrare le relazioni tra le tabelle e la struttura del database.

## 🛠 Tecnologie utilizzate

- **SQL / MySQL**
- **InnoDB** per la gestione di vincoli e transazioni
- **Trigger** e **Stored Procedures** per automatizzare controlli e aggiornamenti

## 🎯 Obiettivi del progetto

- Progettare un database relazionale efficiente e normalizzato
- Gestire correttamente vincoli di integrità (PK, FK)
- Automatizzare controlli su pacchetti e promozioni tramite trigger
- Fornire dati di esempio per testare acquisti, eventi e promozioni
- Mostrare visivamente la struttura del database tramite schema ER

## 📂 Struttura della Repository

```
database-design-sql/
│
├── script.sql         → Script SQL completo con tabelle, trigger e dati
├── schemaER.png       → Diagramma Entity-Relationship
├── docs/
│   └── relazione.pdf  → Relazione tecnica completa
└── README.md
```

## 🚀 Come usare

1. Clona il repository:
```bash
git clone https://github.com/tuo-username/database-design-sql.git
```

2. Apri MySQL o un DBMS compatibile

3. Esegui lo script `script.sql` per creare il database, le tabelle, i trigger e inserire i dati di esempio

4. Visualizza lo schema ER in `schemaER.png`

5. Testa query, acquisti e promozioni direttamente sul database

## 📖 Relazione Tecnica

Per una spiegazione dettagliata della progettazione del database, della struttura delle tabelle e dei meccanismi di automazione implementati, consultare il documento tecnico in `docs/relazione.pdf` che copre:

- **Analisi tecnica**: Descrizione della struttura del database e delle relazioni tra le tabelle
- **Progettazione del schema**: Normalizzazione, vincoli di integrità e chiavi primarie/esterne
- **Trigger e Stored Procedures**: Spiegazione dell'automazione di controlli e calcoli

## ⚠️ Disclaimer

Questo progetto è stato sviluppato esclusivamente a scopo didattico e formativo.

Tutti i dati di utenti, eventi e pacchetti sono **fittizi** e utilizzati esclusivamente a titolo esemplificativo. L'autore non si assume alcuna responsabilità per l'uso improprio del codice o delle informazioni contenute in questa repository.
Progetto realizzato a scopo didattico e formativo.

**GitHub**: [Link al profilo]

Per domande, suggerimenti o feedback, sentiti libero di aprire una issue o di contattarmi.
