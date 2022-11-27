DROP VIEW IF EXISTS "debitToPay".debts_to_pay_total_view;
CREATE VIEW "debitToPay".debts_to_pay_total_view AS
SELECT 
  A."idEnterprise"::varchar,
  A."idCreditor"::varchar,
  B."creditorName",
  A."debtPaid",
  
    (CASE  WHEN sum( A."remainingDebt")<1 THEN
    trim(to_char(sum(A."remainingDebt"),'0D99'))
  ELSE
    trim(to_char(sum( A."remainingDebt"),'9999999G999G999D99'))
  END)  as  "totalRemainingDebtQuery",  
  
 sum( A."remainingDebt") as "totalRemainingDebt",
  
    COUNT(A."idCreditor") as "totalAccount"
   
  FROM "debitToPay".debts_to_pay A INNER JOIN  creditors.creditors B USING("idCreditor")
  GROUP BY 
    A."idEnterprise",
   A."idCreditor",
   B."creditorName",
   A."debtPaid";
  

  
