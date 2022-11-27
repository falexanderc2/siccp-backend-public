SELECT 
  	--CASE WHEN (GROUPING(A."idCollectNumber") =0) THEN (ROW_NUMBER() OVER(ORDER BY A."idCollectNumber")) ELSE 0 END AS "rowNumber",

    
    CASE WHEN (GROUPING(A."idReceibable") = 0)  THEN A."idReceibable" ELSE 0 END AS "idReceibable",
    CASE WHEN (GROUPING(A."idCollectNumber") = 0)  THEN A."idCollectNumber" ELSE 0 END AS ID,
    CASE WHEN (GROUPING(B."idCustomer") = 0)  THEN  B."idCustomer" ELSE 0 END AS "idCustomer",
    CASE WHEN (GROUPING(C."customerName") = 0 )  THEN  C."customerName" ELSE 'SUB TOTALES' END AS "commonName",
    CASE WHEN (GROUPING(C."customerName") = 0 )  THEN  C."customerName" ELSE 'TOTALES' END AS "commonName",
    CASE WHEN (GROUPING(A."paymentDate") = 0 )  THEN  to_char(A."paymentDate", 'DD/MM/YYYY') ELSE '0' END AS "paymentDateQuery",
    A."paymentDate" ,
    
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
  A."tipoDolar",
  
  trim(to_char(A."montoDolar",'9999999G999G999D99')) as "montoDolarQuery"
  

 -- COUNT(*) as "rowAffect"
   FROM RECEIBABLES."collectDebts" A
    INNER JOIN  RECEIBABLES.RECEIBABLES  B on A."idEnterprise"=B."idEnterprise" and A."idReceibable"=B."idReceibable" 
    INNER JOIN  customers.customers C on B."idCustomer" = C."idCustomer" 
    WHERE   A."annulledPayment"='NO'
    
  GROUP BY GROUPING SETS ( (A."paymentDate"),
  (A."paymentDate", B."idCustomer", C."customerName",A."idCollectNumber", A."idReceibable",  A."remainingDebt", A."tipoDolar",A."montoDolar",A."amount"),()
  
  )
  order by   (A."paymentDate")
  
 