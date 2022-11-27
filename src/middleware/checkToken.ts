import jwt from 'jsonwebtoken';
import { SERVER_TOKEN_EXPIRETIME, SERVER_TOKEN_ISSUER, SERVER_TOKEN_SECRET } from '../config/config';
import message from '../config/message'
import { Request, Response, NextFunction } from 'express';
import Reply, { defaultReply } from '../interfaces/reply'

const NAMESPACE = 'CHECK CHECKTOKEN';
const TOKEN = {
  expireTime: SERVER_TOKEN_EXPIRETIME,
  issuer: SERVER_TOKEN_ISSUER,
  secret: SERVER_TOKEN_SECRET
}
const checkToken = (token: string): boolean => {
  // ? checkToken: verifica que el valor recibido tenga un token y no sea indefinido
  let result: boolean = true
  message.info(NAMESPACE, 'Revisando extructura del token')
  if (typeof token === 'undefined') {
    result = false
  }
  return result
}
const verifyToken = async (req: Request, res: Response, next: NextFunction): Promise<Reply> => {
  //? verifica que el toquen sea correcto
  const token: any = req.headers.authorization?.split(' ')[1];// se quita la palabra bearer del header.authorization
  const reply: Reply = defaultReply
  if (checkToken(token) === true) {
    message.info(NAMESPACE, 'Revisando validez del token');
    // ! sintaxis jwt.verify(token, secretOrPublicKey, [opciones, devolución de llamada])
    jwt.verify(token, TOKEN.secret, (error: any, decoded: any) => {
      if (error) {
        res.locals.error = true
        reply.errorFound = true
        reply.messageInfo = 'TOKEN INVALIDO. NEGADO EL ACCESO. DEBE VOLVER A ENTRAR'
        reply.success = false
        reply.logout = true
        message.error(NAMESPACE, reply.messageInfo)
        return reply
      } else {
        reply.messageInfo = 'TOKEN VALIDO. ACCESO PERMITIDO'
        reply.success = true
        reply.errorFound = false
        reply.logout = false
        message.info(NAMESPACE, reply.messageInfo)
        return reply
      }
    });
  } else {
    reply.errorFound = true
    reply.messageInfo = 'NO EXISTE TOKEN EN LA PETICION. NEGADO EL ACCESO'
    reply.success = false
    reply.logout = true
    message.info(NAMESPACE, reply.messageInfo)
    return reply
    // ! 403 Forbidden    El cliente no posee los permisos necesarios para cierto contenido, por lo que el servidor está rechazando otorgar una respuesta apropiada.
  }
  return reply
}
export default verifyToken;


