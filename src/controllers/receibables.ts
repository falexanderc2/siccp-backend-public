import { Request, Response, NextFunction } from 'express'
import { deleteData, getAll, insertPut } from './controllerGeneral'
import { totalReceibableQuery } from './tool_sql/toolSql'

export const getReceibables = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  const { idEnterprise } = req.params
  if (req.params.idReceibable === undefined) {
    querySql = `SELECT * FROM receibables.receibables_view WHERE ("idEnterprise"::bigint = ${idEnterprise})`
  } else {
    const id = req.params.idReceibable //JSON.stringify(req.params.id)
    querySql = `SELECT * FROM receibables.receibables_view WHERE ("idEnterprise"::bigint = ${idEnterprise}) and
    ( ("idReceibable" ilike '%${id}%') or ("idCustomer" ilike '%${id}%') or ("customerName" ilike '%${id}%') or ("debtDescription" ilike '%${id}%') or ("debtPaid" ilike '%${id}%') or ("dateDebtsQuery" ilike '%${id}%')) `
  }
  return getAll(req, res, querySql, next)
}

export const getReceibable = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idReceibable } = req.params
  const querySql = `SELECT * FROM receibables.receibables_view WHERE "idEnterprise"::bigint = ${idEnterprise} and "idReceibable"::bigint= ${idReceibable
    }`
  return await getAll(req, res, querySql, next)
}

export const getReceibableFilter = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { fields, idEnterprise, idCustomer } = req.params
  const querySql = `SELECT ${fields} FROM  receibables.receibables_view WHERE ("idEnterprise"::bigint = ${idEnterprise} and "idCustomer"::bigint = ${idCustomer}) and ("debtPaid"='NO') order by "idReceibable"::bigint asc`
  return await getAll(req, res, querySql, next)
}

export const getReceibableTotal = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idCustomer } = req.params
  const querySql: string = `SELECT "totalRemainingDebtQuery","totalAccount" FROM  receibables.receibables_total_view WHERE ("idEnterprise"::bigint = ${idEnterprise} and "idCustomer"::bigint = ${idCustomer}) and ("debtPaid"='NO') `
  return await getAll(req, res, querySql, next)
}

export const getReceibableResumen = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise } = req.params
  const querySql: string = await totalReceibableQuery(idEnterprise)
  return await getAll(req, res, querySql)
}

export const postReceibables = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'receibables.create_update'
  return await insertPut(req, res, next, nameProcedure, 'create_update')
}

export const deleteReceibables = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idReceibable } = req.params
  const nameProcedure: string = 'receibables.delete'
  return await deleteData(res, next, nameProcedure, 'delete', idReceibable)

}

