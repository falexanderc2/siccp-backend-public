DROP VIEW IF EXISTS customers.customers_view;

CREATE VIEW customers.customers_view AS
select "idCustomer" as id,
"idCustomer"::varchar,
"idEnterprise"::varchar,
"customerName" as "commonName",
"customerName",
phone,
address,
email,
observations,
reputation,
activated,
to_char("admissionDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "admissionDate"
from customers.customers order by "idCustomer"::bigint,"idEnterprise"::bigint asc;


