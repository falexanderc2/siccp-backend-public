--DROP TABLE administradors.administrators;
create table administrators.administrators (
  id bigserial NOT NULL,
  "userName" varchar(250) NOT NULL UNIQUE,
  email varchar(60) NOT NULL UNIQUE,
  password varchar(300) not null,
  activated char(2) DEFAULT ('SI'),
  "admissionDate" timestamp DEFAULT CURRENT_TIMESTAMP,
  primary key (id)
);
