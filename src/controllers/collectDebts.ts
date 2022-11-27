import { Request, Response, NextFunction } from 'express'
import { getAll, insertPut } from './controllerGeneral'
import { totalCollectQuery } from './tool_sql/toolSql'


export const getCollectDebts = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  if (req.params.idCollectNumber === undefined) {
    const { idEnterprise, idReceibable } = req.params
    querySql = `SELECT * FROM receibables.collect_debts_view WHERE ("idEnterprise"::bigint = ${idEnterprise}) and "idReceibable"::bigint = ${idReceibable}  order by "idCollectNumber"::bigint`
  }
  return await getAll(req, res, querySql, next)
}

export const getCollectDebt = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idCollectNumber } = req.params
  const querySql = `SELECT * FROM receibables.collect_debts_view WHERE "idEnterprise"::bigint = ${idEnterprise} and "idCollectNumber"::bigint= ${idCollectNumber}`
  return await getAll(req, res, querySql, next)
}

export const getCollectDebtResumen = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, startDate, endDate, idCustomer } = req.params
  const querySql = await totalCollectQuery(idEnterprise, startDate, endDate, idCustomer)
  return await getAll(req, res, querySql, next)
}

export const postCollectDebts = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'receibables.register_collect'
  return await insertPut(req, res, next, nameProcedure, 'register_collect')
}

export const cancelCollectDebts = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'receibables.cancel_collect_debts'
  return await insertPut(req, res, next, nameProcedure, 'cancel_collect_debts')
}


