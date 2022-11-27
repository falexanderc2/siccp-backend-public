import { Request, Response, NextFunction } from 'express'
import { DataBase } from '../config/conectBDPostgresql'
import { SERVER_DATA_BASE } from '../config/config'


import message from '../config/message'

const NAMESPACE = 'CONTROLLER GENERAL'

export const getAll = async (req: Request, res: Response, query: string, next?: NextFunction): Promise<any> => {
  return await SERVER_DATA_BASE.runQuery(query).then((response: any) => {
    res.status(200).json(response)
    next !== undefined && next()
  }).catch((error: any) => {
    message.error(NAMESPACE, 'Error: ', error)
    res.status(500).json(error)
    next !== undefined && next()
  })
}


export const foundUser = async (req: Request, res: Response, nameProcedure: string, nameOnlyProcedure: string):
  Promise<any> => {

  // !ESTA FUNCION PERMITE BUSCAR LOS DATOS DEL USUARIO CUANDO SE ESTA LONGEANDO, ES CASI IGUAL A LA FUNCTION insertPut, la diferencia radica en QUE ESTA FUNCION NO UTILIZA EL METODO SEND Y QUE ALTERA LOS DATOS DEL LOCALS PARA ASIGNARLE VALORES QUE CORRESPONDE AL USUARIO
  return await SERVER_DATA_BASE.getFunction(req.body, nameProcedure, nameOnlyProcedure)
    .then((response: any) => {
      return res.locals.userData = response// se utiliza solo para la llamada desde loginEnterprises)
    })
    .catch((error: any) => {
      message.error(NAMESPACE, 'Error: ', error)
      res.status(500).json(error)
    })
}

export const insertPut = async (req: Request, res: Response, next: NextFunction, nameProcedure: string, nameOnlyProcedure: string): Promise<any> => {
  return await SERVER_DATA_BASE.getFunction(req.body, nameProcedure, nameOnlyProcedure)
    .then((response: any) => {
      res.status(200).json(response)
      next()
    })
    .catch((error: any) => {
      message.error(NAMESPACE, 'Error: ', error)
      res.status(500).json(error)
      next()
    })
}

export const deleteData = async (res: Response, next: NextFunction, nameProcedure: string, nameOnlyProcedure: string, params: any): Promise<any> => {
  return await SERVER_DATA_BASE.getFunction(params, nameProcedure, nameOnlyProcedure)
    .then((response: any) => {
      res.status(200).json(response)
      next()
    })
    .catch((error: any) => {
      message.error(NAMESPACE, 'Error: ', error)
      res.status(500).json(error)
      next()
    })
}
