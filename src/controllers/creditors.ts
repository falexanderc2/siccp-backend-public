import { Request, Response, NextFunction } from 'express'
import { getAll, insertPut, deleteData } from './controllerGeneral'

export const getCreditors = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  const { idEnterprise } = req.params
  if (req.params.idCreditor === undefined) {
    querySql = `SELECT * FROM creditors.creditors_view WHERE ("idEnterprise"::bigint = ${idEnterprise})`
  } else {
    const id = req.params.idCreditor
    querySql = `SELECT * FROM creditors.creditors_view WHERE ("idEnterprise"::bigint = ${idEnterprise}) and
    ( ("idCreditor" ilike '%${id}%') or ("creditorName" ilike '%${id}%') or (email ilike '%${id}%') or (reputation ilike '%${id}%') or (phone ilike '%${id}%')) `
  }
  return await getAll(req, res, querySql, next)
}

export const getCreditor = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idCreditor } = req.params
  const querySql = `SELECT * FROM creditors.creditors_view WHERE "idEnterprise"::bigint = ${idEnterprise} and "idCreditor"::bigint=  ${idCreditor}`
  return await getAll(req, res, querySql, next)
}
export const getCreditorsFilter = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { fields, idEnterprise } = req.params
  const querySql = `SELECT ${fields} FROM creditors.creditors_view WHERE (activated='SI') and("idEnterprise"::bigint = ${idEnterprise}) order by "creditorName" asc`
  return await getAll(req, res, querySql, next)
}

export const postCreditors = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'creditors.create_update'
  return await insertPut(req, res, next, nameProcedure, 'create_update')
}

export const deleteCreditors = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idCreditor } = req.params
  const nameProcedure: string = 'creditors.delete'
  return await deleteData(res, next, nameProcedure, 'delete', idCreditor)
}


