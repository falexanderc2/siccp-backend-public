DROP VIEW IF EXISTS creditors.creditors_view;
CREATE VIEW creditors.creditors_view AS
select "idCreditor" as id,
"idCreditor"::varchar,
"idEnterprise"::varchar,
"creditorName" as "commonName",
"creditorName",
phone,
address,
email,
observations,
reputation,
activated,
to_char("admissionDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "admissionDate"
 from creditors.creditors order by "idCreditor"::bigint,"idEnterprise"::bigint asc;


