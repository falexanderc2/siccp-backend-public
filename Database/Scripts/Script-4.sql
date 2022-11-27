SELECT 
	CASE WHEN (GROUPING(A."idCustomer") =0) THEN 
	(
	ROW_NUMBER() OVER(ORDER BY A."idCustomer")
	) 
	ELSE NULL END AS "rowNumber",
  CASE WHEN (GROUPING(A."idEnterprise") =0)  THEN A."idEnterprise" ELSE NULL  END AS "idEnterprise",
  CASE WHEN (GROUPING(A."idCustomer") =0)  THEN  A."idCustomer" ELSE NULL END AS id,
  CASE WHEN (GROUPING(B."customerName")=0 )  THEN  B."customerName" ELSE 'TOTAL A COBRAR' END AS "commonName",
  (CASE  WHEN sum(A."amountDebt")<1 THEN
    trim(to_char(sum(A."amountDebt"),'0D99')) 
  ELSE
    trim(to_char(sum(A."amountDebt"),'9999999G999G999D99')) 
  END) AS  "totalAmountDebtQuery",  
 (CASE  WHEN sum(A."amountPaid")<1 THEN
  trim(to_char(sum(A."amountPaid"),'0D99'))
  ELSE
    trim(to_char(sum(A."amountPaid"),'9999999G999G999D99'))
  END)  as  "totalAmountPaidQuery",  

 (CASE  WHEN sum( A."remainingDebt")<1 THEN
    trim(to_char(sum(A."remainingDebt"),'0D99'))
  ELSE
    trim(to_char(sum( A."remainingDebt"),'9999999G999G999D99'))
  END)  as  "totalRemainingDebtQuery"
  FROM receibables.receibables A INNER JOIN  customers.customers B USING("idCustomer")
  where ((A."idEnterprise"= 1) and (A."debtPaid" ='NO') and ("idCustomer" = 1)) 
  GROUP BY GROUPING SETS (  ( A."idEnterprise", A."idCustomer", B."customerName"),()) 
  order by  "rowNumber"  
