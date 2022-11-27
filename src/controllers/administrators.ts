import { Request, Response, NextFunction } from 'express'
import { deleteData, getAll, insertPut } from './controllerGeneral'

export const getAdministrators = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  if (req.params.id === undefined) {
    querySql = 'SELECT * FROM administrators.administrators_view '
  } else {
    const id = req.params.id //JSON.stringify(req.params.id)
    querySql = `SELECT * FROM administrators.administrators_view WHERE ("id" ilike '%${id}%') or ("userName" ilike '%${id}%') or (email ilike '%${id}%')  `
  }
  return await getAll(req, res, querySql, next)
}

export const getAdministrator = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const {id} = req.params
  const querySql = `SELECT * FROM  administrators.administrators_view WHERE "id"::bigint = ${id}`
  return await getAll(req, res, querySql, next)
}

export const postAdministrators = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'administrators.create_update'
  return await insertPut(req, res, next, nameProcedure, 'create_update')
}

export const deleteAdministrators = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { id }= req.params
  const nameProcedure: string = 'administrators.delete'
  return await deleteData(res, next, nameProcedure, 'delete', id)
}

