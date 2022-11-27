/*ESTE ARCHIVO PERMITE CREAR LA BASE DE DATOS*/

CREATE DATABASE siccp
  WITH OWNER = postgres
       
ENCODING = 'UTF8'
       
TABLESPACE = pg_default
       
LC_COLLATE = 'Spanish_Spain.1252'
       
LC_CTYPE = 'Spanish_Spain.1252'
       CONNECTION LIMIT = -1;
	   
	   
nota se debe crear la tabla con utf8 y luego que se cree se corre este codigo:

UPDATE pg_database SET encoding='8' WHERE datname='siccp';




CREATE DATABASE siccp
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Spanish_Spain.1252'
       LC_CTYPE = 'Spanish_Spain.1252'
       CONNECTION LIMIT = -1;