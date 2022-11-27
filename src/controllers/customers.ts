import { Request, Response, NextFunction } from 'express'
import { getAll, insertPut, deleteData } from './controllerGeneral'

export const getCustomers = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  let querySql: string = ''
  const { idEnterprise } = req.params
  if (req.params.idCustomer === undefined) {
    querySql = `SELECT * FROM customers.customers_view WHERE ("idEnterprise"::bigint = ${idEnterprise})`
  } else {
    const id = req.params.idCustomer //JSON.stringify(req.params.id)
    querySql = `SELECT * FROM customers.customers_view WHERE ("idEnterprise"::bigint = ${idEnterprise}) and
    ( ("idCustomer" ilike '%${id}%') or ("customerName" ilike '%${id}%') or (email ilike '%${id}%') or (reputation ilike '%${id}%') or (phone ilike '%${id}%')) `
  }
  return await getAll(req, res, querySql, next)
}

export const getCustomer = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idEnterprise, idCustomer } = req.params
  const querySql = `SELECT * FROM customers.customers_view WHERE "idEnterprise"::bigint = ${idEnterprise} and "idCustomer"::bigint=  ${idCustomer}`
  return await getAll(req, res, querySql, next)
}
export const getCustomersFilter = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { fields, idEnterprise } = req.params
  const querySql = `SELECT ${fields} FROM customers.customers_view WHERE (activated='SI') and ("idEnterprise"::bigint = ${idEnterprise}) order by "customerName" asc`
  return await getAll(req, res, querySql, next)
}

export const postCustomers = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'customers.create_update'
  return await insertPut(req, res, next, nameProcedure, 'create_update')
}

export const deleteCustomers = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const { idCustomer } = req.params
  const nameProcedure: string = 'customers.delete'
  return await deleteData(res, next, nameProcedure, 'delete', idCustomer)
}
