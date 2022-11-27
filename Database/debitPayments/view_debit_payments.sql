DROP VIEW IF EXISTS "debitToPay".debit_payments_view;
CREATE VIEW "debitToPay".debit_payments_view AS
SELECT
  A."idPaymentNumber" as id,
  A."idPaymentNumber"::varchar,
  A."idDebtToPay"::varchar,
  A."idEnterprise"::varchar,
  
  to_char(A."paymentDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "paymentDateQuery",
  A."paymentDate" ,

 
  (CASE  WHEN A."amount"<1 THEN
    trim(to_char(A."amount",'0D99')) 
  ELSE
    trim(to_char(A."amount",'9999999G999G999D99')) 
  END) AS  "amountQuery",  
  A."amount" , 
   
   (CASE  WHEN  A."remainingDebt"<1 THEN
		(CASE WHEN char_length(TRIM((A."remainingDebt"::TEXT)))<=4 THEN
		trim(to_char(A."remainingDebt",'0D99')) ELSE 
		trim(to_char(A."remainingDebt",'9999999G999G999D99'))
		 END)
  ELSE
    trim(to_char(A."remainingDebt",'9999999G999G999D99'))
  END)  as  "remainingDebtQuery",  
  A."remainingDebt" ,
   A."tipoDolar",
  trim(to_char(A."montoDolar",'9999999G999G999D99')) as "montoDolarQuery",
  A."montoDolar",
  
  A."annulledPayment",
  A.observations,
  to_char(A."admissionDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "admissionDateQuery",
   A."admissionDate"
FROM
  "debitToPay".debit_payments A
order by "idPaymentNumber" ASC;  
