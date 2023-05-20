SELECT 
(SELECT COUNT(*) FROM actor) AS actor,
(SELECT COUNT(*) FROM address) AS address,
(SELECT COUNT(*) FROM category) AS category,
(SELECT COUNT(*) FROM city) AS city,
(SELECT COUNT(*) FROM country) AS country,
(SELECT COUNT(*) FROM customer) AS customer,
(SELECT COUNT(*) FROM film) AS film,
(SELECT COUNT(*) FROM film_actor) AS film_actor,
(SELECT COUNT(*) FROM film_category) AS film_category,
(SELECT COUNT(*) FROM inventory) AS inventory,
(SELECT COUNT(*) FROM language) AS language,
(SELECT COUNT(*) FROM payment) AS payment,
(SELECT COUNT(*) FROM rental) AS rental,
(SELECT COUNT(*) FROM staff) AS staff,
(SELECT COUNT(*) FROM store) AS store



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- actor
-- address
-- category
-- city
-- country
-- customer
-- film
-- film_actor
-- film_category
-- inventory
-- language
-- payment
-- payment_p2007_01
-- payment_p2007_02
-- payment_p2007_03
-- payment_p2007_04
-- payment_p2007_05
-- payment_p2007_06
-- rental
-- staff
-- store


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE SEQUENCE public.dim_customer_pk_customer_seq;

CREATE TABLE public.DIM_CUSTOMER (
                PK_CUSTOMER INTEGER NOT NULL DEFAULT nextval('public.dim_customer_pk_customer_seq'),
                FIRST_NAME VARCHAR,
                LAST_NAME VARCHAR,
                CREATE_DATE DATE NOT NULL,
                EMAIL VARCHAR,
                CONSTRAINT pk_customer PRIMARY KEY (PK_CUSTOMER)
);


ALTER SEQUENCE public.dim_customer_pk_customer_seq OWNED BY public.DIM_CUSTOMER.PK_CUSTOMER;

CREATE SEQUENCE public.dim_film_pk_film_seq;

CREATE TABLE public.DIM_FILM (
                PK_FILM INTEGER NOT NULL DEFAULT nextval('public.dim_film_pk_film_seq'),
                TITLE VARCHAR NOT NULL,
                RELEASE_YEAR INTEGER NOT NULL,
                LANGUAGE VARCHAR NOT NULL,
                RENTAL_RATE NUMERIC NOT NULL,
                LENGTH INTEGER NOT NULL,
                CATEGORY VARCHAR NOT NULL,
                ID VARCHAR NOT NULL,
                RATING VARCHAR NOT NULL,
                CONSTRAINT pk_film PRIMARY KEY (PK_FILM)
);


ALTER SEQUENCE public.dim_film_pk_film_seq OWNED BY public.DIM_FILM.PK_FILM;

CREATE TABLE public.DIM_DATE (
                PK_DATE INTEGER NOT NULL,
                DATE_DESC DATE NOT NULL,
                YEAR_DESC INTEGER NOT NULL,
                MONTH_DESC VARCHAR NOT NULL,
                DAY_DESC INTEGER NOT NULL,
                HALF_DESC VARCHAR NOT NULL,
                QUARTER_DESC VARCHAR NOT NULL,
                CONSTRAINT pk_date PRIMARY KEY (PK_DATE)
);


CREATE SEQUENCE public.dim_location_pk_location_seq;

CREATE TABLE public.DIM_LOCATION (
                PK_LOCATION INTEGER NOT NULL DEFAULT nextval('public.dim_location_pk_location_seq'),
                COUNTRY VARCHAR NOT NULL,
                CITY VARCHAR NOT NULL,
                ID VARCHAR NOT NULL,
                CONSTRAINT pk_location PRIMARY KEY (PK_LOCATION)
);


ALTER SEQUENCE public.dim_location_pk_location_seq OWNED BY public.DIM_LOCATION.PK_LOCATION;

CREATE SEQUENCE public.fact_rental_pk_fact_rental_seq;

CREATE TABLE public.FACT_RENTAL (
                PK_FACT_RENTAL INTEGER NOT NULL DEFAULT nextval('public.fact_rental_pk_fact_rental_seq'),
                SK_DATE INTEGER NOT NULL,
                SK_FILM INTEGER NOT NULL,
                SK_CUSTOMER INTEGER NOT NULL,
                SK_LOCATION INTEGER NOT NULL,
                RENTAL_VALUE NUMERIC NOT NULL,
                CONSTRAINT pk_rental PRIMARY KEY (PK_FACT_RENTAL)
);


ALTER SEQUENCE public.fact_rental_pk_fact_rental_seq OWNED BY public.FACT_RENTAL.PK_FACT_RENTAL;

ALTER TABLE public.FACT_RENTAL ADD CONSTRAINT dim_customer_fact_rental_fk
FOREIGN KEY (SK_CUSTOMER)
REFERENCES public.DIM_CUSTOMER (PK_CUSTOMER)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.FACT_RENTAL ADD CONSTRAINT dim_film_fact_rental_fk
FOREIGN KEY (SK_FILM)
REFERENCES public.DIM_FILM (PK_FILM)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.FACT_RENTAL ADD CONSTRAINT dim_fecha_fact_rental_fk
FOREIGN KEY (SK_DATE)
REFERENCES public.DIM_DATE (PK_DATE)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.FACT_RENTAL ADD CONSTRAINT dim_location_fact_rental_fk
FOREIGN KEY (SK_LOCATION)
REFERENCES public.DIM_LOCATION (PK_LOCATION)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO dim_fecha 
	SELECT TO_CHAR(f1, 'yyyymmdd')::INTEGER as PK_FECHA,
	f1 as DATE_DESC,
	EXTRACT (YEAR FROM f1) AS YEAR_DESC,
	CONCAT(EXTRACT (YEAR FROM f1), '-',to_char(F1, 'TMMONTH')) AS MONTH_DESC,
	EXTRACT (DAY FROM f1) AS DAY_DESC,
	CASE 
		WHEN (EXTRACT (QUARTER FROM f1) )<= 2 THEN CONCAT(EXTRACT (YEAR FROM f1),'-SEMESTRE-', 1 )
		ELSE CONCAT(EXTRACT (YEAR FROM f1),'-SEMESTRE-', 2 )
	END AS HALF_DESC,
   CONCAT(EXTRACT (YEAR FROM f1), '-TRIMESTRE-', EXTRACT (QUARTER FROM f1)) AS QUARTER_HALF
FROM 
   (SELECT generate_series('2005-05-24'::timestamptz, '2006-02-14', '1 day')::date as f1) AS fecha;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 
SELECT TITLE, RELEASE_YEAR, la.NAME as language, RENTAL_RATE, LENGTH, ca.name as category FROM FILM f
INNER JOIN LANGUAGE la on la.language_id = f.language_id
INNER JOIN film_category fc on fc.film_id = f.film_id
INNER JOIN category ca on ca.category_id = fc.category_id


SELECT COUNT(*) AS C, film_id FROM film_category GROUP BY film_id ORDER BY C ASC LIMIT 1


SELECT count(*) FROM film limit 10

drop DATABASE DWH_SAKILA


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT TO_CHAR(rental_date, 'yyyymmdd')::INTEGER AS DATE_ID,
CONCAT(fi.title, '-', fi.release_year, '-', ca.name) FILM_ID,
cu.email AS CUSTOMER_ID,
CONCAT(co.country, '-', ci.city) AS LOCATION_ID,
pa.amount as RENTAL_VALUE
FROM rental re
INNER JOIN inventory iv ON iv.inventory_id = re.inventory_id
INNER JOIN film fi ON fi.film_id = iv.film_id
INNER JOIN film_category fc ON fc.film_id = fi.film_id
INNER JOIN category ca ON ca.category_id = fc.category_id
INNER JOIN customer cu ON cu.customer_id = re.customer_id
INNER JOIN address ad ON ad.address_id = cu.address_id
INNER JOIN city ci ON ci.city_id = ad.city_id
INNER JOIN country co ON co.country_id = ci.country_id
INNER JOIN payment pa ON pa.rental_id = re.rental_id


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT * FROM dim_location LIMIT 10
SELECT * FROM dim_customer LIMIT 10
SELECT * FROM dim_date LIMIT 10
SELECT * FROM dim_film LIMIT 10
SELECT * FROM fact_rental LIMIT 10

TRUNCATE TABLE dim_customer CASCADE


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT TO_CHAR(f1, 'yyyymmdd')::INTEGER as PK_DATE,
	f1 as DATE_DESC,
	EXTRACT (YEAR FROM f1) AS YEAR_DESC,
	CONCAT(EXTRACT (YEAR FROM f1), '-',to_char(F1, 'TMMONTH')) AS MONTH_DESC,
	EXTRACT (DAY FROM f1) AS DAY_DESC,
	CASE 
		WHEN (EXTRACT (QUARTER FROM f1) )<= 2 THEN CONCAT(EXTRACT (YEAR FROM f1),'-SEMESTRE-', 1 )
		ELSE CONCAT(EXTRACT (YEAR FROM f1),'-SEMESTRE-', 2 )
	END AS HALF_DESC,
   CONCAT(EXTRACT (YEAR FROM f1), '-TRIMESTRE-', EXTRACT (QUARTER FROM f1)) AS QUARTER_DESC
FROM 
	(SELECT DISTINCT RENTAL_DATE::DATE as f1 FROM RENTAL ORDER BY RENTAL_DATE::DATE) AS dates


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




