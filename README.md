# Database Design – Organizzazione Eventi

## Descrizione
Progetto universitario per la gestione di eventi e pacchetti di acquisto.  
Include la progettazione di un database relazionale completo con:  
- Gestione di utenti, artisti, categorie e eventi  
- Pacchetti disponibili per ogni evento  
- Acquisti con calcolo automatico del prezzo e controllo disponibilità  
- Promozioni e sconti gestiti tramite codici promo  

Lo schema ER completo è incluso nella repository per mostrare le **relazioni tra le tabelle** e la struttura del database.

## Tecnologie utilizzate
- **SQL / MySQL**  
- **InnoDB** per la gestione di vincoli e transazioni  
- **Trigger** e **Stored Procedures** per automatizzare controlli e aggiornamenti  


## Obiettivi del progetto
- Progettare un database relazionale efficiente e normalizzato  
- Gestire correttamente vincoli di integrità (PK, FK)  
- Automatizzare controlli su pacchetti e promozioni tramite trigger  
- Fornire dati di esempio per testare acquisti, eventi e promozioni  
- Mostrare visivamente la struttura del database tramite schema ER  

## Come usare
1. Clona il repository:
```bash
git clone https://github.com/tuo-username/database-design-sql.git
2. Apri MySQL o un DBMS compatibile  
3. Esegui lo script `script.sql` per creare il database, le tabelle, i trigger e inserire i dati di esempio  
4. Visualizza lo schema ER con Draw.io (`schema_er.drawio`) o l’immagine (`schema_er.png`)  
5. Testa query, acquisti e promozioni direttamente sul database  

## Struttura del repository
