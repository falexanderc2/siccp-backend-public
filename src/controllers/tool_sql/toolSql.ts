// ! ESTAS CONSULTAS NO SE PUDIERON HACER EN UNA VISTA, POR LO TANTO SE REALIZO DE ESTA FORMA
async function totalReceibableQuery (idEnterprise: string): Promise<string> {
  let querySql = `SELECT 
  	CASE WHEN (GROUPING(A."idCustomer") =0) THEN (ROW_NUMBER() OVER(ORDER BY A."idCustomer")) ELSE NULL END AS "rowNumber",

    CASE WHEN (GROUPING(A."idEnterprise") =0)  THEN A."idEnterprise" ELSE 0 END AS "idEnterprise",
    CASE WHEN (GROUPING(A."idCustomer") =0)  THEN  A."idCustomer" ELSE 0 END AS id,
    CASE WHEN (GROUPING(B."customerName")=0 )  THEN  B."customerName" ELSE 'TOTALES' END AS "commonName",
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
    where (A."idEnterprise"= ${idEnterprise}) and (A."debtPaid" ='NO') `

  querySql += `GROUP BY GROUPING SETS (  ( A."idEnterprise", A."idCustomer", B."customerName"),()) order by  "rowNumber"  `
  return querySql
}

async function totalDebitToPayQuery (idEnterprise: string, idCreditor?: string): Promise<string> {
  let querySql = `SELECT 
  	CASE WHEN (GROUPING(A."idCreditor") =0) THEN (ROW_NUMBER() OVER(ORDER BY A."idCreditor")) ELSE NULL END AS "rowNumber",

    CASE WHEN (GROUPING(A."idEnterprise") =0)  THEN A."idEnterprise" ELSE 0 END AS "idEnterprise",
    CASE WHEN (GROUPING(A."idCreditor") =0)  THEN  A."idCreditor" ELSE 0 END AS id,
    CASE WHEN (GROUPING(B."creditorName")=0 )  THEN  B."creditorName" ELSE 'TOTALES' END AS "commonName",
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
    FROM "debitToPay".debts_to_pay A INNER JOIN  creditors.creditors B USING("idCreditor")
    where (A."idEnterprise"= ${idEnterprise}) and (A."debtPaid" ='NO') `
  if (idCreditor !== undefined) {
    querySql += `and ("idCreditor" = ${idCreditor}) `
  }
  querySql += `GROUP BY GROUPING SETS (  ( A."idEnterprise", A."idCreditor", B."creditorName"),()) order by  "rowNumber"  `
  return querySql
}

async function totalCollectQuery (idEnterprise: string, startDate?: string, endDate?: string, idCustomer?: string): Promise<string> {
  let querySql = `SELECT   
   (ROW_NUMBER() OVER(ORDER BY A."idCollectNumber")) AS id,
    CASE WHEN (GROUPING(A."idReceibable") = 0)  THEN A."idReceibable" ELSE 0 END AS "idReceibable",
    CASE WHEN (GROUPING(A."idCollectNumber") = 0)  THEN A."idCollectNumber" ELSE 0 END AS "numeroPago",
    CASE WHEN (GROUPING(A."idCollectNumber") = 0 )  THEN  to_char(A."paymentDate", 'DD/MM/YYYY') ELSE '' END AS "paymentDateQuery",
    CASE WHEN (GROUPING(B."idCustomer") = 0)  THEN  B."idCustomer" ELSE 0 END AS "idCommon",
    
    CASE
	  	WHEN GROUPING(A."paymentDate") = 0 AND GROUPING(A."idCollectNumber") = 0	THEN   (C."customerName") 
	    WHEN GROUPING(A."paymentDate") = 0 AND GROUPING(A."idCollectNumber") = 1  THEN   ('SUB TOTAL') 
    	WHEN GROUPING(A."paymentDate") = 1 AND GROUPING(A."idCollectNumber") = 1	THEN  ('TOTAL GENERAL')
		END AS "commonName",  

    CASE  WHEN A."amount"<1 THEN 
      trim(to_char(sum(A."amount"),'0D99')) 
    ELSE 
      trim(to_char(sum(A."amount"),'9999999G999G999D99')) 
    END AS  "amountQuery",   

    CASE WHEN (GROUPING( A."tipoDolar") = 0)  THEN  A."tipoDolar" ELSE '' END AS "tipoDolar",

    CASE 
	    WHEN (GROUPING( A."montoDolar") = 0)  AND  A."montoDolar"<1 THEN trim(to_char(A."montoDolar",'0D99')) 
      WHEN (GROUPING( A."montoDolar") = 0)  AND  A."montoDolar">1 THEN trim(to_char(A."montoDolar",'9999999G999G999D99')) 
      WHEN (GROUPING( A."montoDolar") = 1) THEN '0,00'
    END AS  "montoDolarQuery"

    FROM RECEIBABLES."collectDebts" A
    INNER JOIN  RECEIBABLES.RECEIBABLES  B on A."idEnterprise"=B."idEnterprise" and A."idReceibable"=B."idReceibable" 
    INNER JOIN  customers.customers C on B."idCustomer" = C."idCustomer" 
    WHERE (A."annulledPayment"='NO') and `

  querySql += ` (A."idEnterprise" = ${idEnterprise})`

  idCustomer && (querySql += ` and (B."idCustomer"=${idCustomer})`)
  startDate && (querySql += ` and (A."paymentDate" between '${startDate}' and '${endDate}')`)

  querySql += ` GROUP BY GROUPING SETS ( (A."paymentDate"),
  (A."paymentDate", B."idCustomer", C."customerName",A."idCollectNumber", A."idReceibable",  A."remainingDebt", A."tipoDolar",A."montoDolar",A."amount"),() )
   order by   (A."paymentDate",A."idCollectNumber",A."idReceibable")`
  return querySql
}
async function totalDebitPayment (idEnterprise: string, startDate?: string, endDate?: string, idCreditor?: string): Promise<string> {
  let querySql = `SELECT   
   (ROW_NUMBER() OVER(ORDER BY A."idPaymentNumber")) AS id,
    CASE WHEN (GROUPING(A."idDebtToPay") = 0)  THEN A."idDebtToPay" ELSE 0 END AS "idDebtToPay",
    CASE WHEN (GROUPING(A."idPaymentNumber") = 0)  THEN A."idPaymentNumber" ELSE 0 END AS "numeroPago",
    CASE WHEN (GROUPING(A."idPaymentNumber") = 0 )  THEN  to_char(A."paymentDate", 'DD/MM/YYYY') ELSE '' END AS "paymentDateQuery",
    CASE WHEN (GROUPING(B."idCreditor") = 0)  THEN  B."idCreditor" ELSE 0 END AS "idCommon",
    
    CASE
	  	WHEN GROUPING(A."paymentDate") = 0 AND GROUPING(A."idPaymentNumber") = 0	THEN   (C."creditorName") 
	    WHEN GROUPING(A."paymentDate") = 0 AND GROUPING(A."idPaymentNumber") = 1  THEN   ('SUB TOTAL') 
    	WHEN GROUPING(A."paymentDate") = 1 AND GROUPING(A."idPaymentNumber") = 1	THEN  ('TOTAL GENERAL')
		END AS "commonName",  

    CASE  WHEN A."amount"<1 THEN 
      trim(to_char(sum(A."amount"),'0D99')) 
    ELSE 
      trim(to_char(sum(A."amount"),'9999999G999G999D99')) 
    END AS  "amountQuery",   

    CASE WHEN (GROUPING( A."tipoDolar") = 0)  THEN  A."tipoDolar" ELSE '' END AS "tipoDolar",

    CASE 
	    WHEN (GROUPING( A."montoDolar") = 0)  AND  A."montoDolar"<1 THEN trim(to_char(A."montoDolar",'0D99')) 
      WHEN (GROUPING( A."montoDolar") = 0)  AND  A."montoDolar">1 THEN trim(to_char(A."montoDolar",'9999999G999G999D99')) 
      WHEN (GROUPING( A."montoDolar") = 1) THEN '0,00'
    END AS  "montoDolarQuery"

    FROM "debitToPay".debit_payments A
    INNER JOIN  "debitToPay".debts_to_pay  B on A."idEnterprise"=B."idEnterprise" and A."idDebtToPay"=B."idDebtToPay" 
    INNER JOIN  creditors.creditors C on B."idCreditor" = C."idCreditor" 
    WHERE (A."annulledPayment"='NO') and `

  querySql += ` (A."idEnterprise" = ${idEnterprise})`

  idCreditor && (querySql += ` and (B."idCreditor"=${idCreditor})`)
  startDate && (querySql += ` and (A."paymentDate" between '${startDate}' and '${endDate}')`)

  querySql += ` GROUP BY GROUPING SETS ( (A."paymentDate"),
  (A."paymentDate", B."idCreditor", C."creditorName",A."idPaymentNumber", A."idDebtToPay",  A."remainingDebt", A."tipoDolar",A."montoDolar",A."amount"),() )
   order by   (A."paymentDate",A."idPaymentNumber",A."idDebtToPay")`
  return querySql
}
export { totalReceibableQuery, totalDebitToPayQuery, totalCollectQuery, totalDebitPayment }