import { Request, Response, NextFunction } from 'express'
import { foundUser } from './controllerGeneral'
import signJWT from '../middleware/signature'
import IUser from '../interfaces/user'

export const postLoginEnterprise = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'enterprises.login_enterprises'
  let _status = 0
  let _message: any
  var _token: any
  let _error: any
  console.clear()
  console.info('EVALUANDO LOGIN ENTERPRISES. ')
  console.log('Revisando los datos del usuario')
  await foundUser(req, res, nameProcedure, 'login_enterprises')
  if (res.locals.userData.errorFound === false) {
    const userData: IUser = res.locals.userData
    return await signJWT(userData, (error, token) => {
      _token = token
      _error = error
      if (error === null) {
        _status = 200
        _error = 0
        _message = 'TOKEN ASIGNADO...!'
      } else {
        _error = 1
        _status = 401
        _message = 'NO SE LOGRO ASIGNAR EL TOKEN. INTENTELO MÁS TARDE...!.'
      }
      console.info(_message)
      _message && (res.locals.userData.message = _message)
      res.locals.userData.error = _error
      res.locals.userData.token = _token
      res.status(_status).json(res.locals.userData)
    })
  } else {
    res.status(200).json(res.locals.userData)
  }
}

export const saludoLogin = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  return res.status(200).json({ saludo: 'Hola, estas conectado al servidor de siccp enterprises' })

}
