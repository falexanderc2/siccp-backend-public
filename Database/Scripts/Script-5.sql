SELECT   
    CASE WHEN (GROUPING(A."idReceibable") = 0)  THEN A."idReceibable" ELSE 0 END AS "idReceibable",
    CASE WHEN (GROUPING(A."idCollectNumber") = 0)  THEN A."idCollectNumber" ELSE 0 END AS ID,
    CASE WHEN (GROUPING(A."idCollectNumber") = 0 )  THEN  to_char(A."paymentDate", 'DD/MM/YYYY') ELSE '' END AS "paymentDateQuery",
    CASE WHEN (GROUPING(B."idCustomer") = 0)  THEN  B."idCustomer" ELSE 0 END AS "idCommon",
    CASE
	  	WHEN GROUPING(A."paymentDate") =0 AND GROUPING(A."idCollectNumber") =0	THEN   (C."customerName") 
	    WHEN GROUPING(A."paymentDate") = 0 AND GROUPING(A."idCollectNumber") = 1  THEN   ('SUB TOTAL') 
    	WHEN GROUPING(A."paymentDate") =1 AND GROUPING(A."idCollectNumber") = 1	THEN  ('TOTAL')
		END AS "commonName",  
    (CASE  WHEN A."amount"<1 THEN trim(to_char(sum(A."amount"),'0D99')) 
  ELSE trim(to_char(sum(A."amount"),'9999999G999G999D99')) END) AS  "amountQuery",   
  A."tipoDolar",
   (CASE  WHEN A."montoDolar"<1 THEN trim(to_char(A."montoDolar",'0D99')) 
  ELSE trim(to_char(A."montoDolar",'9999999G999G999D99')) END) AS  "montoDolarQuery"
   FROM RECEIBABLES."collectDebts" A
    INNER JOIN  RECEIBABLES.RECEIBABLES  B on A."idEnterprise"=B."idEnterprise" and A."idReceibable"=B."idReceibable" 
    INNER JOIN  customers.customers C on B."idCustomer" = C."idCustomer" 
    WHERE   A."annulledPayment"='NO'
    
  GROUP BY GROUPING SETS ( (A."paymentDate"),
  (A."paymentDate", B."idCustomer", C."customerName",A."idCollectNumber", A."idReceibable",  A."remainingDebt", A."tipoDolar",A."montoDolar",A."amount"),() )
  order by   (A."paymentDate",A."idCollectNumber",A."idReceibable")
  
 