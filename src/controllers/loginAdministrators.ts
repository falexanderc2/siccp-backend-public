import { Request, Response, NextFunction } from 'express'
import { foundUser } from './controllerGeneral'
import signJWT from '../middleware/signature'
import IUser from '../interfaces/user'

export const postLoginAdministrators = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  const nameProcedure: string = 'administrators.login_administrators'
  let _status = 0
  let _message: any
  var _token: any
  let _error: any
  console.clear()
  console.info('EVALUANDO LOGIN ADMINISTRATOR. ')
  await foundUser(req, res, nameProcedure, 'login_administrators')
  if (res.locals.userData.errorFound === false) {
    const userData: IUser = res.locals.userData
    console.log('userData', userData)
    /*  userData._id = res.locals.userData._id
     userData.email = res.locals.userData._email
     userData.activated = res.locals.userData._activated */
    return await signJWT(userData, (error, token) => {
      {
        _token = token
        _error = error
        if (_error === null) {
          _status = 200
          _error = 0
          _message = 'Token asignado...!'
        } else {
          _error = 1
          _status = 401
          _message = 'No se logro asignar el token. Intentelo más tarde!.'
        }
        console.info(_message)
        _message && (res.locals.userData.message = _message)
        res.locals.userData.error = _error
        res.locals.userData.token = _token
        res.status(_status).json(res.locals.userData)
      }
    })
  } else {
    res.status(200).json(res.locals.userData)
  }
}

export const saludoLogin = async (req: Request, res: Response, next: NextFunction): Promise<any> => {
  return res.status(200).json({ saludo: 'Hola, estas conectado al servidor de siccp administrator' })

}
