import { Request, Response, NextFunction } from 'express'
import { getAll, insertPut } from './controllerGeneral'
import { totalDebitPayment } from './tool_sql/toolSql'

export const getDebitPayments = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idDebtToPay } = req.params
  const querySql = `SELECT * FROM "debitToPay".debit_payments_view WHERE ("idEnterprise"::bigint = ${idEnterprise}) and "idDebtToPay"::bigint = ${idDebtToPay}`
  return await getAll(req, res, querySql, next)
}

export const getDebitPayment = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idPaymentNumber } = req.params
  const querySql = `SELECT * FROM "debitToPay".debit_payments_view WHERE "idEnterprise"::bigint = ${idEnterprise} and "idPaymentNumbere"::bigint= ${idPaymentNumber}`
  return await getAll(req, res, querySql, next)
}

export const getDebitPaymentResumen = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, startDate, endDate, idCreditor } = req.params
  const querySql = await totalDebitPayment(idEnterprise, startDate, endDate, idCreditor)
  return await getAll(req, res, querySql, next)
}

export const postDebitPayments = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'debitToPay.register_payments'
  return await insertPut(req, res, next, nameProcedure, 'register_payments')
}

export const cancelDebitPayments = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'debitToPay.cancel_payments'
  return await insertPut(req, res, next, nameProcedure, 'cancel_payments')
}


