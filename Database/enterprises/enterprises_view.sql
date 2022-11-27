DROP VIEW IF EXISTS enterprises.enterprises_view;
CREATE VIEW enterprises.enterprises_view AS
select "idEnterprise" as id,"idEnterprise"::varchar, "enterprisesName",
password,
email,
activated,
to_char("admissionDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "admissionDate"
from enterprises.enterprises
order by "idEnterprise" asc;


