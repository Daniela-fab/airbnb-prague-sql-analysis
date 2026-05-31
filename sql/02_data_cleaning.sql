-- =============================================
-- Projekt: Airbnb Praha - Data Cleaning
-- Autor: Daniela
-- Datum: 2026-05
-- ============================================
-- 0. Kontrola řádků před čištěním
SELECT COUNT(*) FROM listings;
SELECT COUNT(*) FROM calendar;
SELECT COUNT(*) FROM reviews;
-- ============================================
-- 1. Kontrola NULL hodnot
-- ============================================
-- 1.1 LISTINGS:
-- Cíl: Kontrola NULL hodnot u klíčových sloupců
SELECT
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS null_id,
    COUNT(CASE WHEN host_id IS NULL THEN 1 END) AS null_host_id,
    COUNT(CASE WHEN room_type IS NULL THEN 1 END) AS null_room_type,
    COUNT(CASE WHEN price IS NULL THEN 1 END) AS null_price,
    COUNT(CASE WHEN review_scores_rating IS NULL THEN 1 END) AS null_rating,
    COUNT(CASE WHEN availability_365 IS NULL THEN 1 END) AS null_availability_365,
    COUNT(CASE WHEN number_of_reviews IS NULL THEN 1 END) AS null_number_of_reviews,
    COUNT(CASE WHEN minimum_nights IS NULL THEN 1 END) AS null_min_nights,
    COUNT(CASE WHEN maximum_nights IS NULL THEN 1 END) AS null_max_nights,
    cOUNT(CASE WHEN accommodates IS NULL THEN 1 END) AS null_accommodates,
    COUNT(CASE WHEN beds IS NULL THEN 1 END) AS null_beds,
    COUNT(CASE WHEN bedrooms IS NULL THEN 1 END) AS null_bedrooms
FROM listings;

SELECT id, name, room_type, accommodates, bedrooms, beds
FROM listings
WHERE beds IS NULL
   OR bedrooms IS NULL;

/* Výsledek:
- Sloupec price má 474 NULL hodnot - budou odstraněny, protože cena je klíčová pro analýzu
- Sloupec review_scores_rating má 132 NULL hodnot - budou ověřeny logickou kontrolou sloupců v sekci 7
-- Sloupec beds obsahuje 10 NULL hodnot - Hodnoty budou ponechány jako NULL, protože je nelze spolehlivě dopočítat.
-- Sloupec bedrooms obsahuje 5 NULL hodnot - Hodnoty budou ponechány jako NULL, protože je nelze spolehlivě dopočítat.
*/

-- 1.2 CALENDAR
-- Cíl: Kontrola NULL hodnot u klíčových sloupců
SELECT
    COUNT(CASE WHEN listing_id IS NULL THEN 1 END) AS null_id,
    COUNT(CASE WHEN date IS NULL THEN 1 END) AS null_date,
    COUNT(CASE WHEN available IS NULL THEN 1 END) AS null_available,
    COUNT(CASE WHEN adjusted_price IS NULL THEN 1 END) AS null_adjusted_price
FROM calendar;
-- Výsledek: Hodnoty NULL u sloupce adjusted_price u všech řádků - v analýze tento sloupec nebude použit

-- 1.3 REVIEWS
-- Kontrola NULL hodnot u klíčových sloupců
SELECT
    COUNT(CASE WHEN listing_id IS NULL THEN 1 END) AS null_listing_id,
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS null_id,
    COUNT(CASE WHEN date IS NULL THEN 1 END) AS null_date
FROM reviews;
-- Výsledek: Žádné NULL hodnoty u klíčových sloupců

-- ============================================
-- 2. Čištění sloupce price
-- ============================================
-- 2.1 kontrola původních hodnot
SELECT DISTINCT price
FROM listings
LIMIT 20;

-- 2.2 Kontrola řádků s chybějící cenou
SELECT COUNT(*) AS null_price_count
FROM listings
WHERE price IS NULL;
-- Výsledek:
-- Řádky s NULL hodnotou ve sloupci price budou odstraněny,
-- protože cena je klíčová pro další cenovou a výnosovou analýzu.
-- Počet odstraněných řádků: 474.

-- 2.3 odstranění řádků s NULL price
DELETE FROM listings
WHERE price IS NULL;

-- 2.4 Kontrola po odstranění NULL price
SELECT COUNT(*) AS null_price_count_after_delete
FROM listings
WHERE price IS NULL;

-- 2.5 Upravení hodnot ve sloupci price
SELECT REPLACE(REPLACE(price, '$', ''), ',', '') as cleaned_price
FROM listings;
LIMIT 20;

-- 2.6 vytvoření nového sloupce price_clean
ALTER TABLE listings
ADD COLUMN price_clean DECIMAL(10,2);

-- 2.7 Naplnění price_clean očištěnou číselnou hodnotou
UPDATE listings
SET price_clean = CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS DECIMAL(10,2))
WHERE price IS NOT NULL
  AND price_clean IS NULL;

-- 2.8 Kontrola výsledku
SELECT price, price_clean
FROM listings
LIMIT 20;

-- ============================================
-- 3. Kontrola datových typů
-- ============================================
-- 3.1 Kontrola datového formátu calendar.date
SELECT date
FROM calendar
LIMIT 20;

-- 3.2 Změna datového typu z text na date sloupce date u tabulky calendar
ALTER TABLE calendar
MODIFY COLUMN date DATE;

-- 3.3 Kontrola po změně datového typu calendar.date
SELECT date
FROM calendar
LIMIT 20;

-- 3.4 Kontrola formátu data u reviews.date
SELECT date
FROM reviews
LIMIT 20;

-- 3.5 Změna datového typu u sloupce date v tabulce reviews
ALTER TABLE reviews
MODIFY COLUMN date DATE;

-- 3.6 Kontrola po změně datového typu reviews.date
SELECT date
FROM reviews
LIMIT 20;

-- 3.7 Kontrola datového formátu listings.minimum_nights
SELECT minimum_nights
FROM listings
LIMIT 20;

-- 3.8 Změna datového typu z text na INT sloupce date u tabulky listings
ALTER TABLE listings
MODIFY COLUMN minimum_nights INT;

-- 3.9 Kontrola po změně datového typu listings.minimum_nights
SELECT minimum_nights
FROM listings
LIMIT 20;

-- 3.10 Kontrola datového formátu listings.maximum_nights
SELECT maximum_nights
FROM listings
LIMIT 20;

-- 3.11 Změna datového typu z text na INT sloupce date u tabulky listings
ALTER TABLE listings
MODIFY COLUMN maximum_nights INT;

-- 3.12 Kontrola po změně datového typu listings.maximum_nights
SELECT maximum_nights
FROM listings
LIMIT 20;

-- 3.13 Kontrola datového formátu listings.accommodates
SELECT DISTINCT accommodates
FROM listings
ORDER BY accommodates;

-- 3.14 Změna datového typu z text na INT sloupce accommodates u tabulky listings
ALTER TABLE listings
MODIFY COLUMN accommodates INT;

-- 3.15 Kontrola po změně datového typu listings.accommodates
SELECT accommodates
FROM listings
LIMIT 20;

-- 3.16 Kontrola datového formátu listings.bedrooms
SELECT DISTINCT bedrooms
FROM listings
ORDER BY bedrooms;

-- 3.17 Změna datového typu z text na INT sloupce bedrooms u tabulky listings
ALTER TABLE listings
MODIFY COLUMN bedrooms INT;

-- 3.18 Kontrola po změně datového typu listings.bedrooms
SELECT bedrooms
FROM listings
LIMIT 20;

-- 3.19 Kontrola datového formátu listings.beds
SELECT DISTINCT beds
FROM listings
ORDER BY beds;

-- 3.20 Změna datového typu z text na INT sloupce beds u tabulky listings
ALTER TABLE listings
MODIFY COLUMN beds INT;

-- 3.21 Kontrola po změně datového typu listings.beds
SELECT beds
FROM listings
LIMIT 20;

-- ============================================
-- 4. Kontrola duplicit
-- ============================================

-- 4.1 listings.id
-- Cíl: ověřit, zda se ID nabídky v tabulce listings neopakuje
SELECT id, COUNT(*) AS pocet_zaznamu_listings
FROM listings
GROUP BY id
HAVING COUNT(*) > 1;
-- Výsledek: Bez výskytu duplicit.


-- 4.2 calendar: listing_id + date
-- Cíl: ověřit, zda jedna nabídka nemá více záznamů pro stejný den
SELECT listing_id, date, COUNT(*) AS pocet_zaznamu_calendar
FROM calendar
GROUP BY listing_id, date
HAVING COUNT(*) > 1;
-- Výsledek: Bez výskytu duplicit.


-- 4.3 reviews.id
-- Cíl: ověřit, zda se ID recenze v tabulce reviews neopakuje
SELECT id, COUNT(*) AS pocet_zaznamu_reviews
FROM reviews
GROUP BY id
HAVING COUNT(*) > 1;
-- Výsledek: Bez výskytu duplicit.

-- ============================================
-- 5. Kontrola konzistence kategorií
-- ============================================

-- 5.1 room_type
-- Cíl: Ověřit, zda sloupec room_type obsahuje očekávané kategorie bez překlepů nebo nejednotných hodnot
SELECT DISTINCT room_type
FROM listings;
-- Výsledek: Kategorie jsou konzistentní, nebyly nalezeny překlepy ani nejednotné hodnoty.


-- 5.2 calendar.available
-- Cíl: Ověřit, zda sloupec available obsahuje pouze očekávané hodnoty
SELECT DISTINCT available
FROM calendar;
-- Výsledek: Hodnoty jsou konzistentní - výskyt hodnot 't' a 'f'.

-- 6. Kontrola rozsahů hodnot
-- 6.1 price_clean
SELECT price_clean
FROM listings
WHERE price_clean IS NOT NULL;

SELECT MIN(price_clean) AS min_cena
FROM listings;

SELECT price_clean, id, name, room_type, neighbourhood_cleansed
FROM listings
WHERE price_clean < 500
ORDER BY price_clean ASC;
-- Výsledek:
-- Minimální cena je 317.
-- Bylo nalezeno 9 nabídek s price_clean < 500, pravděpodobně se nejedná o chybu a data budou dále analyzovány.


SELECT MAX(price_clean) AS max_cena
FROM listings;

SELECT price_clean, id, name, room_type, neighbourhood_cleansed
FROM listings
WHERE price_clean > 50000
ORDER BY price_clean ASC;
-- Poznámka:
-- Sloupec price_clean obsahuje extrémně vysoké hodnoty, maximální cena je 242690.
-- Bylo nalezeno 9 nabídek s price_clean > 100000 pravděpodobně se nejedná o chybu a data budou dále analyzovány.

-- 6.2 minimum_nights / maximum_nights
SELECT
    MIN(minimum_nights) AS min_minimum_nights,
    MAX(minimum_nights) AS max_minimum_nights,
    MIN(maximum_nights) AS min_maximum_nights,
    MAX(maximum_nights) AS max_maximum_nights
FROM listings;

SELECT id, name, minimum_nights, maximum_nights
FROM listings
WHERE maximum_nights < minimum_nights;

SELECT COUNT(*) AS invalid_min_max_nights
FROM listings
WHERE maximum_nights < minimum_nights;
-- Výsledek:
-- Minimum minimum_nights je 1.
-- Maximum maximum_nights je 3333.
-- Po převodu na číselný typ nebyly nalezeny žádné nelogické kombinace,
-- kde by maximum_nights bylo menší než minimum_nights.

-- 6.3 accommodates / bedrooms / beds
-- Cíl: ověřit, zda sloupce accommodates, bedrooms a beds neobsahují nulové, záporné nebo chybějící hodnoty
SELECT
    MIN(accommodates) AS min_accommodates,
    MAX(accommodates) AS max_accommodates,
    MIN(bedrooms) AS min_bedrooms,
    MAX(bedrooms) AS max_bedrooms,
    MIN(beds) AS min_beds,
    MAX(beds) AS max_beds
FROM listings;

-- Podezřelé hodnoty
SELECT accommodates
FROM listings
WHERE accommodates <= 0;

-- nabídka má kapacitu, ale chybí počet postelí
SELECT accommodates, beds
FROM listings
WHERE accommodates > 0
  AND beds IS NULL;

-- nabídka má kapacitu, ale chybí počet ložnic
SELECT accommodates, bedrooms
FROM listings
WHERE accommodates > 0
  AND bedrooms IS NULL;

-- Výsledek:
-- Sloupec accommodates má hodnoty v rozsahu 1–16.
-- Nebyly nalezeny žádné nulové ani záporné hodnoty u accommodates.

-- Sloupec bedrooms má hodnoty v rozsahu 0–19.
-- Hodnota 0 může být u některých typů ubytování logická, např. studio nebo sdílený prostor.
-- Bylo nalezeno 5 nabídek, kde je uvedena kapacita, ale chybí počet ložnic.

-- Sloupec beds má hodnoty v rozsahu 0–32.
-- Hodnota 0 je podezřelá, protože nabídka může mít kapacitu, ale počet postelí není uveden.
-- Bylo nalezeno 10 nabídek, kde je uvedena kapacita, ale chybí počet postelí.

-- Hodnoty NULL ve sloupcích beds a bedrooms budou ponechány,
-- protože je nelze spolehlivě dopočítat z dostupných dat.
-- Při analýze kapacity bude nutné s těmito hodnotami pracovat opatrně.

-- 6.4 review_scores_rating / number_of_reviews
SELECT
    MIN(review_scores_rating) AS min_rating,
    MAX(review_scores_rating) AS max_rating,
    MIN(number_of_reviews) AS min_reviews,
    MAX(number_of_reviews) AS max_reviews
FROM listings;

-- Kontrola podezřelých hodnot
SELECT id, name, review_scores_rating, number_of_reviews
FROM listings
WHERE review_scores_rating < 0
   OR review_scores_rating > 5
   OR number_of_reviews < 0;
-- Výsledek:
-- Sloupec review_scores_rating má hodnoty v rozsahu 2.0–5.0.
-- Hodnoty ratingu odpovídají očekávané škále 0–5.
-- Sloupec number_of_reviews má hodnoty v rozsahu 0–99.
-- Nebyly nalezeny ratingy mimo rozsah 0–5 ani záporné počty recenzí.

-- ============================================
-- 7. Logické kontroly mezi sloupci
-- ============================================
-- 7.1 number_of_reviews vs review_scores_rating
-- Cíl: ověřit logickou konzistenci mezi počtem recenzí a ratingem

-- Nabídky mají recenze, ale chybí rating
SELECT number_of_reviews, review_scores_rating
FROM listings
WHERE review_scores_rating IS NULL
  AND number_of_reviews > 0;

-- Nabídky nemají žádné recenze, ale mají rating
SELECT number_of_reviews, review_scores_rating
FROM listings
WHERE review_scores_rating IS NOT NULL
  AND number_of_reviews = 0;

-- 7.2 number_of_reviews vs reviews_per_month
-- Kontrola zda existují nabídky, které nemají recenze, ale mají reviews_per_month
SELECT number_of_reviews, reviews_per_month
FROM listings
WHERE reviews_per_month IS NOT NULL
  AND number_of_reviews = 0;

-- 7.3 first_review vs last_review
-- Cíl: ověřit logickou konzistenci dat první a poslední recenze

-- Nabídka má recenze, ale chybí datum první nebo poslední recenze
SELECT id, name, number_of_reviews, first_review, last_review
FROM listings
WHERE number_of_reviews > 0
  AND (first_review IS NULL OR last_review IS NULL);

-- Nabídka nemá recenze, ale má vyplněné datum recenze
SELECT id, name, number_of_reviews, first_review, last_review
FROM listings
WHERE number_of_reviews = 0
   AND(first_review IS NOT NULL OR last_review IS NOT NULL);

-- První recenze je později než poslední recenze
SELECT id, name, number_of_reviews, first_review, last_review
FROM listings
WHERE first_review > last_review

-- Výsledek: Nebyly nalezeny žádné logické chyby

-- ============================================
-- 8. Závěr ke cleaningu
-- ============================================

-- V rámci čištění dat byly zkontrolovány NULL hodnoty, datové typy,
-- duplicity, konzistence kategorií, rozsahy hodnot a logické vazby mezi sloupci.

-- Řádky s chybějící cenou byly odstraněny, protože cena je klíčová
-- pro další cenovou a výnosovou analýzu.

-- Sloupec price byl očištěn od znaků "$" a "," a převeden do nového
-- číselného sloupce price_clean typu DECIMAL(10,2).

-- Vybrané sloupce uložené jako text byly převedeny na vhodné datové typy
-- například DATE nebo INT.

-- Nebyly nalezeny duplicity v klíčových identifikátorech ani v kombinaci
-- listing_id + date v tabulce calendar.

-- Byly nalezeny některé neúplné nebo extrémní hodnoty, například chybějící
-- beds/bedrooms a vysoké hodnoty price_clean, které byly ponechány
-- a budou zohledněny v další analýze.

-- Dataset je po provedených kontrolách připraven pro další fázi EDA.