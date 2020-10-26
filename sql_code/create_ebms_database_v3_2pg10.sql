/*
Create embs database
Author: Reto Schmucki - retoschm@ceh.ac.uk
*/

psql -h ******* -U ******* -p 5432

DROP DATABASE IF EXISTS ebms_v3_2;
--
VACUUM;
CREATE DATABASE ebms_v3_2
  WITH ENCODING = 'UTF8'
       OWNER = postgres
       TEMPLATE = postgis_25_sample
       CONNECTION LIMIT = -1;

-- CREATE TABLESPACE ebmstablespace LOCATION 'C:/Users/*****/ebms_pg';
-- DROP TABLESPACE ebmstablespace;
-- CREATE TABLESPACE ebmstablespace LOCATION 'C:/Users/*****/ebms_pg';
-- ALTER DATABASE ebms_v3_2 TABLESPACE ebmsv3tablespace;
VACUUM;

-- ADD FUNCTIONS
-- these function return NULL if unable to fix and cast to time or integer
-- THIS DOES NOT WORK IN some terminal, but works fine in pgAdmin!!!

CREATE OR REPLACE FUNCTION try_cast_to_time(text) RETURNS time AS $$
  BEGIN
      return cast(rtrim(LEFT(replace(replace(replace(regexp_replace($1,'[^0-9\.\:\,\-]+', '', 'g'),',',':'),'.',':'),'-',':')||':00:00',8),':')::VARCHAR AS TIME);
  EXCEPTION
      WHEN OTHERS THEN
          RETURN NULL;
  END;
$$ LANGUAGE plpgsql immutable;

CREATE OR REPLACE FUNCTION try_extract_integer(text,integer) RETURNS integer AS $$
BEGIN
	return cast(LEFT(ceil(split_part(LEFT(replace(regexp_replace($1,'[^0-9\.\,\-]+', '', 'g'),',','.'),4),'-',1)::numeric)::varchar,$2) AS INTEGER);
EXCEPTION
	WHEN OTHERS THEN
		RETURN NULL;
END;
$$ LANGUAGE plpgsql immutable;

\q
