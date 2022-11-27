DROP VIEW IF EXISTS receibables.receibables_total_view;
CREATE VIEW receibables.receibables_total_view AS
SELECT 
  A."idEnterprise"::varchar,
  A."idCustomer"::varchar,
  B."customerName",
  A."debtPaid",
  
    (CASE  WHEN sum( A."remainingDebt")<1 THEN
    trim(to_char(sum(A."remainingDebt"),'0D99'))
  ELSE
    trim(to_char(sum( A."remainingDebt"),'9999999G999G999D99'))
  END)  as  "totalRemainingDebtQuery",  
  
 sum( A."remainingDebt") as "totalRemainingDebt",
  
    COUNT(A."idCustomer") as "totalAccount"
   
  FROM receibables.receibables A INNER JOIN  customers.customers B USING("idCustomer")
  GROUP BY 
    A."idEnterprise",
   A."idCustomer",
   B."customerName",
   A."debtPaid";
