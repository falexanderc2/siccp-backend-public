SELECT 
  	 (ROW_NUMBER() OVER(ORDER BY A."idCollectNumber")) as "rowNumber",

    A."idEnterprise",
    A."idReceibable",
    A."idCollectNumber" AS ID,
    B."idCustomer",
   C."customerName",
    A."paymentDate",
    
    (CASE  WHEN A."amount"<1 THEN
    trim(to_char(A."amount",'0D99')) 
  ELSE
    trim(to_char(A."amount",'9999999G999G999D99')) 
  END) AS  "amountQuery",  
   
   (CASE  WHEN A."amount"<1 THEN
    trim(to_char(sum(A."amount"),'0D99')) 
  ELSE
    trim(to_char(sum(A."amount"),'9999999G999G999D99')) 
  END) AS  "totalAmountQuery",  
  
   
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
  A."annulledPayment"
    FROM RECEIBABLES."collectDebts" A
    INNER JOIN  RECEIBABLES.RECEIBABLES  B on A."idEnterprise"=B."idEnterprise" and A."idReceibable"=B."idReceibable" 
    INNER JOIN  customers.customers C on B."idCustomer" = C."idCustomer" 
    WHERE   A."annulledPayment"='NO'
    GROUP by 
    A."idEnterprise",
    A."idReceibable",
    A."idCollectNumber",
    B."idCustomer",
   C."customerName",
    A."paymentDate"
  order by  "rowNumber"