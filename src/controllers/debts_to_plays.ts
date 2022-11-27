import { Request, Response, NextFunction } from 'express'
import { deleteData, getAll, insertPut } from './controllerGeneral'
import { totalDebitToPayQuery } from './tool_sql/toolSql'


export const getDebtsToPays = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  const { idEnterprise } = req.params
  if (req.params.idDebtToPay === undefined) {
    querySql = `SELECT * FROM "debitToPay".debts_to_pay_view WHERE ("idEnterprise"::bigint = ${idEnterprise})`
  } else {
    const id = req.params.idDebtToPay
    querySql = `SELECT * FROM "debitToPay".debts_to_pay_view WHERE ("idEnterprise"::bigint = ${idEnterprise}) and
    ( ("idDebtToPay" like '%${id}%') or ("idCreditor" like '%${id}%') or ("creditorName" like '%${id}%') or ("debtDescription" like '%${id}%') or ("debtPaid" like '%${id}%') or ("dateDebtsQuery" like '%${id}%')) `
  }
  return await getAll(req, res, querySql, next)

}

export const getDebtsToPay = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idDebtToPay } = req.params
  const querySql = `SELECT * FROM "debitToPay".debts_to_pay_view WHERE "idEnterprise"::bigint = ${idEnterprise} and "idDebtToPay"::bigint= ${idDebtToPay}`
  return await getAll(req, res, querySql, next)
}
export const getDebtsToPaysFilter = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { fields, idEnterprise, idCreditor } = req.params
  const querySql = `SELECT ${fields} FROM  "debitToPay".debts_to_pay_view WHERE ("idEnterprise"::bigint = ${idEnterprise} and "idCreditor"::bigint = ${idCreditor}) and ("debtPaid"='NO') order by "idDebtToPay" asc`
  return await getAll(req, res, querySql, next)
}

export const getDebtsToPaysTotal = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idCreditor } = req.params
  const querySql = `SELECT "totalRemainingDebtQuery","totalAccount" FROM  "debitToPay".debts_to_pay_total_view WHERE ("idEnterprise"::bigint = ${idEnterprise} and "idCreditor"::bigint = ${idCreditor}) and ("debtPaid"='NO') `
  return await getAll(req, res, querySql, next)
}

export const getDebtsToPaysResumen = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise } = req.params
  const querySql: string = await totalDebitToPayQuery(idEnterprise)
  return await getAll(req, res, querySql, next)
}


export const postDebtsToPays = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = `debitToPay.create_update`
  return await insertPut(req, res, next, nameProcedure, 'create_update')
}

export const deleteDebtsToPays = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idDebtToPay } = req.params
  const nameProcedure: string = 'debitToPay.delete'
  return await deleteData(res, next, nameProcedure, 'delete', idDebtToPay)

}


