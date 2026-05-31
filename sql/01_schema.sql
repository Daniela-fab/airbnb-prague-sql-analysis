-- =============================================
-- Projekt: Airbnb Praha - Schema & Loading
-- Autor: Daniela
-- Datum: 2026-05
-- =============================================

-- 1. Výběr databáze
USE airbnb_prague;


-- 2. Kontrola importovaných tabulek
SHOW TABLES;


-- 3. Kontrola struktury tabulek
DESCRIBE listings;
DESCRIBE calendar;
DESCRIBE reviews;


-- 4. Kontrola počtu řádků po importu
SELECT COUNT(*) AS listings_count
FROM listings;

SELECT COUNT(*) AS calendar_count
FROM calendar;

SELECT COUNT(*) AS reviews_count
FROM reviews;


-- 5. Kontrola základních vazeb mezi tabulkami

-- calendar.listing_id by měl odpovídat listings.id
SELECT COUNT(*) AS calendar_without_listing
FROM calendar c
LEFT JOIN listings l
    ON c.listing_id = l.id
WHERE l.id IS NULL;


-- reviews.listing_id by měl odpovídat listings.id
SELECT COUNT(*) AS reviews_without_listing
FROM reviews r
LEFT JOIN listings l
    ON r.listing_id = l.id
WHERE l.id IS NULL;


-- Výsledek:
-- Byly importovány tři hlavní tabulky: listings, calendar a reviews.
-- Tabulka listings obsahuje data o nabídkách.
-- Tabulka calendar obsahuje dostupnost nabídek v čase.
-- Tabulka reviews obsahuje recenze jednotlivých nabídek.
-- Vazby mezi tabulkami jsou ověřeny přes listings.id = calendar.listing_id
-- a listings.id = reviews.listing_id.