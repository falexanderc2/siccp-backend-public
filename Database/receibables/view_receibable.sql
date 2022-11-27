DROP VIEW IF EXISTS receibables.receibables_view;
CREATE VIEW receibables.receibables_view AS
SELECT 
  A."idReceibable"::varchar as id,
  A."idReceibable"::varchar,
  A."idEnterprise"::varchar,
  A."idCustomer"::varchar as "idCommon",
  A."idCustomer"::varchar,
 B."customerName" as "commonName",
  B."customerName",
  A."debtDescription"  ,
  to_char(A."dateDebts", 'DD/MM/YYYY HH12:MI:SS: AM') as "dateDebtsQuery",
  
  A."dateDebts", 
  
    
  (CASE  WHEN A."amountDebt"<1 THEN
    trim(to_char(A."amountDebt",'0D99')) 
  ELSE
    trim(to_char(A."amountDebt",'9999999G999G999D99')) 
  END) AS  "amountDebtQuery",  
  A."amountDebt" , 
  
  
  (CASE  WHEN A."numberOfPayments"<1 THEN
    trim(to_char(A."numberOfPayments",'0D99'))
  ELSE
    trim(to_char(A."numberOfPayments",'9999999G999G999D99'))
  END)  as  "numberOfPaymentsQuery",  
  A."numberOfPayments" ,
 
 
  (CASE  WHEN A."amountToBePaidIninstallments"<1 THEN
    trim(to_char(A."amountToBePaidIninstallments",'0D99'))
  ELSE
    trim(to_char(A."amountToBePaidIninstallments",'9999999G999G999D99'))
  END)  as  "amountToBePaidIninstallmentsQuery",  
  A."amountToBePaidIninstallments" ,
  
   /*(CASE  WHEN A."numberOfDaysForInstallments"<1 THEN
    trim(to_char(A."numberOfDaysForInstallments",'0D99'))
  ELSE
    trim(to_char(A."numberOfDaysForInstallments",'9999999G999G999D99'))
  END)  as  "numberOfDaysForInstallmentsQuery",  
  A."numberOfDaysForInstallments" ,*/

  to_char(A."paymentStartDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "paymentStartDateQuery",
  
  A."paymentStartDate"   , 
   (CASE  WHEN A."paymentNumber"<1 THEN
    trim(to_char(A."paymentNumber",'0D99'))
  ELSE
    trim(to_char(A."paymentNumber",'9999999G999G999D99'))
  END)  as  "paymentNumberQuery",  
  A."paymentNumber",
 
  (CASE  WHEN A."amountPaid"<1 THEN
    trim(to_char(A."amountPaid",'0D99'))
  ELSE
    trim(to_char(A."amountPaid",'9999999G999G999D99'))
  END)  as  "amountPaidQuery",  
  A."amountPaid" ,

  
   (CASE  WHEN  A."remainingDebt"<1 THEN
		(CASE WHEN char_length(TRIM((A."remainingDebt"::TEXT)))<=4 THEN
		trim(to_char(A."remainingDebt",'0D99')) ELSE 
		trim(to_char(A."remainingDebt",'9999999G999G999D99'))
		 END)
  ELSE
    trim(to_char(A."remainingDebt",'9999999G999G999D99'))
  END)  as  "remainingDebtQuery",  
  A."remainingDebt" ,
  
  A.observations,
  A."debtPaid", 
  to_char(A."admissionDate", 'DD/MM/YYYY HH12:MI:SS: AM') as "admissionDateQuery",
   A."admissionDate"
  FROM receibables.receibables A INNER JOIN  customers.customers B USING("idCustomer")
  ORDER BY A."idReceibable" ASC;

