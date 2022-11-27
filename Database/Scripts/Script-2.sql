SELECT 

 ROW_NUMBER() OVER(ORDER BY (A."idCustomer")) AS  "rowNumber",
CASE WHEN (GROUPING(A."idEnterprise") =0)  THEN A."idEnterprise"::varchar ELSE '' END AS "idEnterprise",
CASE WHEN (GROUPING(A."idCustomer") =0)  THEN  A."idCustomer"::varchar ELSE '' END AS "id",
CASE WHEN (GROUPING(B."customerName")=0 )  THEN  B."customerName" ELSE '' END AS "customerName",
CASE WHEN (GROUPING(A."debtPaid") =0)  THEN  A."debtPaid" ELSE 'Total' END AS "debtPaid",
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
  

 --sum( A."remainingDebt") as "totalRemainingDebt"
  
 
  
   FROM receibables.receibables A INNER JOIN  customers.customers B USING("idCustomer")
   GROUP BY GROUPING SETS

   ( 
   ( A."idEnterprise", A."idCustomer", B."customerName",A."debtPaid"),()) 
  HAVING GROUPING(A."idEnterprise")IS NOT NULL
  order by  "rowNumber";
  
 

  
  
 