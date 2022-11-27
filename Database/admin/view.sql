DROP VIEW IF EXISTS administrators.administrators_view;
CREATE VIEW administrators.administrators_view AS
select id,
"userName",
password,
email,
activated,
to_char("admissionDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "admissionDate"
from administrators.administrators
order by id asc;