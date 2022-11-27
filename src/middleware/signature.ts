import jwt from 'jsonwebtoken';
import { SERVER_TOKEN_EXPIRETIME, SERVER_TOKEN_ISSUER, SERVER_TOKEN_SECRET } from '../config/config';
import message from '../config/message';
import IUser from '../interfaces/user';

const NAMESPACE = 'SIGNATURE';
const TOKEN = {
  expireTime: SERVER_TOKEN_EXPIRETIME,
  issuer: SERVER_TOKEN_ISSUER,
  secret: SERVER_TOKEN_SECRET
}
const signJWT = async (user: IUser, callback: (error: any, token: any) => void): Promise<any> => {
  let expirationTime = Number(TOKEN.expireTime)//timeSinceEpoch + Number(config.server.token.expireTime);
  let expirationTimeInSeconds = expirationTime//Math.floor(expirationTime / 1000);
  message.info(NAMESPACE, `Asignando token al usuario: ${user.email}`);
  return jwt.sign(
    {
      id: user.id,
      email: user.email
    },
    TOKEN.secret,
    {
      issuer: TOKEN.issuer,
      algorithm: 'HS256',
      expiresIn: expirationTimeInSeconds
    },
    (error, token) => {
      if (error) {
        callback(error, null);
      } else if (token) {
        callback(null, token);
      }
    }
  );

};

export default signJWT;