// ! POSTGRESQL DROP TABLE IF EXISTS enterprises.enterprises;

CREATE TABLE enterprises.enterprises (
  "idEnterprise" bigserial NOT NULL,
  "enterprisesName" varchar(50) NOT NULL,
  password varchar(300) NOT NULL,
  email varchar(60) NOT NULL UNIQUE,
  activated char(2) DEFAULT ('SI'),
  "admissionDate" timestamp DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT enterprisesKeyx PRIMARY KEY ("idEnterprise")
);

// ! Mysql DROP TABLE IF EXISTS enterprises;

// empresas CREATE TABLE enterprises (
  // empresas idEnterprise bigint NOT NULL AUTO_INCREMENT,
  enterprisesName varchar(50) NOT NULL,
  PASSWORD BLOB NOT NULL,
  email varchar(60) NOT NULL UNIQUE,
  activated ENUM ('SI', 'NO') DEFAULT ('SI'),
  admissionDate timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idEnterprise))
