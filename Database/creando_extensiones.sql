create extension pgcrypto;
--si lo quieres agregra en un esquema
create schema seguridad;
create schema
create extension pgcrypto schema public ;--esta es la que hay que colocar
create extension;
--si lo cree en un schema equivocado lo puedo mover
alter extension pgcrypto set schema seguridad;
alter extension 