import { Request, Response, NextFunction } from 'express'
import { deleteData, getAll, insertPut } from './controllerGeneral'

export const getEnterprises = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  if (req.params.idEnterprise === undefined) {
    querySql = 'SELECT * FROM enterprises.enterprises_view '
  } else {
    const id = req.params.idEnterprise //JSON.stringify(req.params.id)
    querySql = `SELECT * FROM enterprises.enterprises_view WHERE ("idEnterprise" ilike '%${id}%') or ("enterprisesName" ilike '%${id}%') or (email ilike '%${id}%')  `
  }
  return await getAll(req, res, querySql, next)
}

export const getEnterprise = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const {idEnterprise} = req.params
  const querySql = `SELECT * FROM  enterprises.enterprises_view WHERE "idEnterprise"::bigint = ${idEnterprise}`
  return await getAll(req, res, querySql, next)
}

export const postEnterprises = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'enterprises.create_update'
  return await insertPut(req, res, next, nameProcedure, 'create_update')
}

export const deleteEnterprises = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise }= req.params
  const nameProcedure: string = 'enterprises.delete'
  return await deleteData(res, next, nameProcedure, 'delete', idEnterprise)
}

