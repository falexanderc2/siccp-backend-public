DROP table IF EXISTS creditors.creditors;--acreedores
create table creditors.creditors(
  "idCreditor" bigserial NOT NULL,
  "idEnterprise" BIGINT NOT NULL REFERENCES enterprises.enterprises ("idEnterprise") MATCH FULL ON DELETE RESTRICT,
  "creditorName"  varchar(150) not null,
  phone  varchar(40) not null  DEFAULT '',
  address  varchar(150) not null  DEFAULT '',
  email  varchar(40) not null DEFAULT '',
  observations varchar(250) not null DEFAULT '',
  reputation  varchar(20) not null DEFAULT 'SIN EVALUACION',
  activated varchar(2) DEFAULT 'SI',
  "admissionDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("idCreditor"),
  UNIQUE ("idEnterprise","creditorName")
 -- UNIQUE ("idEnterprise",email)
  )
