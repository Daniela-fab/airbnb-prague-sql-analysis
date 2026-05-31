-- ============================================
 -- 1. Nabídky a lokalita
-- ============================================

-- 1.1 Kolik Airbnb nabídek je v Praze celkem?
SELECT count(id) AS pocet_nabidek
FROM listings;

-- 1.2 Ve kterých čtvrtích je nejvíce nabídek?
SELECT neighbourhood_cleansed,
       count(id) AS pocet_nabidek
FROM listings
GROUP BY neighbourhood_cleansed
ORDER BY pocet_nabidek DESC
LIMIT 10;

-- 1.3 Jaké typy pokojů se v Praze nejčastěji nabízejí?
SELECT room_type,
       count(id) AS pocet_nabidek
FROM listings
GROUP BY room_type
ORDER BY pocet_nabidek DESC;

-- Závěr:
-- Dataset po čištění obsahuje 3434 Airbnb nabídek v Praze.
-- Nejvíce nabídek je soustředěno v centrálních částech města,
-- zejména v Praze 1, Praze 2 a Praze 3.
-- Nejčastějším typem ubytování je Entire home/apt,
-- což ukazuje, že většina nabídek představuje celé byty nebo apartmány,
-- nikoliv pouze jednotlivé pokoje.

-- ============================================
-- 2. Cena
-- ============================================

-- 2.1 Jaká je průměrná cena ubytování?
SELECT ROUND(AVG(price_clean), 2) AS prumerna_cena
FROM listings;


-- 2.2 Jak se cena liší podle typu pokoje?
SELECT room_type,
       AVG(price_clean) AS prumerna_cena
FROM listings
GROUP BY room_type
ORDER BY prumerna_cena DESC;


-- 2.3 Ve kterých čtvrtích jsou nejvyšší průměrné ceny?
SELECT neighbourhood_cleansed,
       COUNT(id) AS pocet_nabidek,
       AVG(price_clean) AS prumerna_cena
FROM listings
GROUP BY neighbourhood_cleansed
ORDER BY prumerna_cena DESC
LIMIT 10;


-- 2.4 Ve kterých čtvrtích jsou nejnižší průměrné ceny?
SELECT neighbourhood_cleansed,
       COUNT(id) AS pocet_nabidek,
       AVG(price_clean) AS prumerna_cena
FROM listings
GROUP BY neighbourhood_cleansed
ORDER BY prumerna_cena ASC
LIMIT 10;

-- 2.5 Jaké jsou nejdražší konkrétní nabídky?
SELECT id,
       name,
       neighbourhood_cleansed,
       room_type,
       price_clean
FROM listings
ORDER BY price_clean DESC
LIMIT 10;

-- 2.6 Jaké jsou nejlevnější konkrétní nabídky?
SELECT id,
       name,
       neighbourhood_cleansed,
       room_type,
       price_clean
FROM listings
ORDER BY price_clean ASC
LIMIT 10;

-- Závěr:
-- Průměrná cena ubytování je 3597.66.
-- Nejvyšší průměrnou cenu má Hotel room, nejnižší Shared room.
-- Mezi čtvrtěmi vychází nejdražší Praha 7, ale výsledek je ovlivněn
-- extrémně drahými nabídkami, zejména VEVERKOVA RESIDENCE.
-- Nejnižší průměrné ceny mají spíše okrajové části Prahy.
-- Kvůli cenovým outlierům je potřeba průměr interpretovat opatrně;
-- v další analýze bude vhodné pracovat také s mediánem.

-- ============================================
-- 3. Kapacita
-- ============================================
-- 3.1 Kolik osob nejčastěji nabídky ubytují?
SELECT COUNT(id) AS pocet_nabidek,
       accommodates
FROM listings
WHERE accommodates IS NOT NULL AND accommodates > 0
GROUP BY accommodates
ORDER BY pocet_nabidek DESC;

-- 3.2 Jak cena souvisí s kapacitou ubytování?
SELECT AVG(price_clean) AS prumerna_cena,
       COUNT(id) AS pocet_nabidek,
       accommodates
FROM listings
WHERE accommodates IS NOT NULL AND accommodates > 0
GROUP BY accommodates
ORDER BY accommodates ASC;

-- Závěr:
-- Nejčastější kapacita ubytování je pro 2 až 4 osoby.
-- Průměrná cena se obecně zvyšuje s vyšší kapacitou,
-- ale trend není úplně rovnoměrný.
-- U vyšších kapacit může být výsledek ovlivněn menším počtem nabídek
-- nebo cenovými outliery.

-- ============================================
-- 4. Recenze a aktivita
-- ============================================
-- 4.1 Kolik nabídek nemá žádnou recenzi?
SELECT COUNT(id) AS pocet_nabidek_bez_recenzi,
       number_of_reviews
FROM listings
WHERE number_of_reviews = 0;

-- 4.2 Které typy pokojů mají nejvíce recenzí?
SELECT room_type,
       SUM(number_of_reviews) AS pocet_recenzi_celkem
FROM listings
GROUP BY room_type
ORDER BY pocet_recenzi_celkem DESC;

-- 4.3 Jaké je rozložení hodnocení podle ratingových skupin?
SELECT
    CASE
        WHEN review_scores_rating IS NULL THEN 'zadne_hodnoceni'
        WHEN review_scores_rating < 3 THEN 'nizke_hodnoceni'
        WHEN review_scores_rating >= 3 AND review_scores_rating < 4 THEN 'dobre_hodnoceni'
        WHEN review_scores_rating >= 4 AND review_scores_rating < 4.8 THEN 'velmi_dobre_hodnoceni'
        ELSE 'vyborne_hodnoceni'
    END AS rating_group,
    COUNT(id) AS pocet_nabidek
FROM listings
GROUP BY rating_group
ORDER BY pocet_nabidek DESC;

-- 4.4 Mají nabídky s vyšším počtem recenzí jinou průměrnou cenu?
SELECT CASE
    WHEN number_of_reviews = 0 THEN '0 recenzí'
    WHEN number_of_reviews BETWEEN 1 AND 10 THEN '1–10 recenzí'
    WHEN number_of_reviews BETWEEN 11 AND 50 THEN '11–50 recenzí'
    WHEN number_of_reviews BETWEEN 51 AND 100 THEN '51–100 recenzí'
    ELSE '100+ recenzí'
END AS review_group,
    COUNT(id) AS pocet_nabidek,
    ROUND(AVG(price_clean), 2) AS prumerna_cena
FROM listings
GROUP BY review_group
ORDER BY prumerna_cena DESC;

-- 4.5 Mají nabídky s vyšším hodnocením vyšší průměrnou cenu?
-- Průměr ceny
SELECT
    CASE
        WHEN review_scores_rating IS NULL THEN 'zadne_hodnoceni'
        WHEN review_scores_rating < 3 THEN 'nizke_hodnoceni'
        WHEN review_scores_rating >= 3 AND review_scores_rating < 4 THEN 'dobre_hodnoceni'
        WHEN review_scores_rating >= 4 AND review_scores_rating < 4.8 THEN 'velmi_dobre_hodnoceni'
        ELSE 'vyborne_hodnoceni'
    END AS rating_group,
    COUNT(id) AS pocet_nabidek,
    AVG(price_clean) AS prumerna_cena
FROM listings
GROUP BY rating_group
ORDER BY prumerna_cena DESC;

-- Rozdělení skupiny dobré hodnocení a kontrola extrémních hodnot
SELECT review_scores_rating,
       id,
       neighbourhood_cleansed,
       host_name,
       price_clean
FROM listings
WHERE review_scores_rating >= 3 AND review_scores_rating < 4
ORDER BY price_clean DESC;

-- Rozdělení skupiny velmi dobré hodnocení s extrémními hodnotami
    SELECT review_scores_rating,
       id,
       neighbourhood_cleansed,
       host_name,
       price_clean
FROM listings
WHERE review_scores_rating >= 4 AND review_scores_rating < 4.8
ORDER BY price_clean DESC;

-- Rozdělení skupiny výborné hodnocení s extrémními hodnotami
    SELECT review_scores_rating,
       id,
       neighbourhood_cleansed,
       host_name,
       price_clean
FROM listings
WHERE review_scores_rating > 4.8
ORDER BY price_clean DESC;

-- Závěr:
-- Většina aktivity a recenzí se soustředí u typu Entire home/apt.
-- V datasetu je 100 nabídek bez recenzí.
-- Většina hodnocených nabídek má vysoké hodnocení.
-- Vztah mezi cenou, počtem recenzí a hodnocením není jednoznačný,
-- protože průměrné ceny jsou ovlivněny cenovými outliery.
-- Pro další analýzu bude vhodné pracovat také s mediánem nebo filtrovat extrémní ceny.
-- ============================================
-- 5. Hostitelé ---------
-- ============================================

-- 5.1 Mají hostitelé s vyšším počtem recenzí vyšší průměrnou cenu?
SELECT
    host_id,
    host_name,
    SUM(number_of_reviews) AS pocet_recenzi,
    COUNT(id) AS pocet_nabidek,
    ROUND(AVG(review_scores_rating), 2) AS prumerne_hodnoceni,
    ROUND(AVG(price_clean), 2) AS prumerna_cena
FROM listings
GROUP BY host_id, host_name
ORDER BY pocet_recenzi DESC;

-- -- Zjištění:
-- U hostitelů s nejvyšším celkovým počtem recenzí se neukazuje jednoznačný vztah,
-- že vyšší počet recenzí znamená vyšší průměrnou cenu.
-- Průměrné ceny se mezi hostiteli výrazně liší.
-- Naopak většina nejvíce recenzovaných hostitelů má vysoké průměrné hodnocení,
-- většinou nad 4.5.

-- 5.2 Kteří hostitelé mají nejvíce nabídek?
SELECT
    host_id,
    host_name,
    COUNT(id) AS pocet_nabidek
FROM listings
GROUP BY host_id, host_name
ORDER BY pocet_nabidek DESC
LIMIT 10;

-- 5.3 Je v datech hodně hostitelů s více nabídkami?
SELECT
    host_id,
    host_name,
    COUNT(id) AS pocet_nabidek
FROM listings
GROUP BY host_id, host_name
HAVING COUNT(id) > 1
ORDER BY pocet_nabidek DESC;

-- Závěr:
-- V datech jsou hostitelé s výrazně vyšším počtem nabídek.
-- Někteří hostitelé provozují desítky ubytování, což naznačuje profesionálnější část trhu.
-- Počet nabídek ani počet recenzí ale sám o sobě jednoznačně nevysvětluje výši ceny.