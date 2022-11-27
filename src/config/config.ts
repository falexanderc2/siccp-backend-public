import * as dotenv from "dotenv";
import path from 'path'
const pathEnviroment = path.resolve(`${__dirname}../../`, '.env')

dotenv.config({
  path: pathEnviroment
});
import express, { Response } from 'express'
import { DataBase } from './conectBDPostgresql'
import { keySecret } from './key';
/* const config = {
  PATH: path.resolve(__dirname, process.env.NODE_ENV + '.env'),
}

*/
const SERVER_DATA_BASE: any = new DataBase()
async function connect_BD () {
  let res: Response
  return await SERVER_DATA_BASE.conexionDataBase().then((result: any) => {
    if (result === false) {
      console.error('No se conecto a la base de datos')
    }
  }).catch((error: any) => {
    console.error('error', error)
    res.status(500).json(SERVER_DATA_BASE.reply)
  })
}

// ?VARIABLE GLOBALES
connect_BD()
const NODE_ENV = 'development'
const HOSTNAME: string = process.env.SERVER_HOSTNAME ?? '0.0.0.0'
const PORT: any = process.env.PORT ?? 3001
const SERVER_TOKEN_EXPIRETIME: any = process.env.SERVER_TOKEN_EXPIRETIME ?? 7200//segundos
const SERVER_TOKEN_ISSUER: string = process.env.SERVER_TOKEN_ISSUER ?? 'siccp-felix-carrasco'
const SERVER_TOKEN_SECRET: string = process.env.SERVER_TOKEN_SECRET ?? keySecret

export { NODE_ENV, HOSTNAME, PORT, SERVER_TOKEN_EXPIRETIME, SERVER_TOKEN_ISSUER, SERVER_TOKEN_SECRET, SERVER_DATA_BASE }

// !Cuando se crean las variables de entorno en el servidor solo se colocan los valores finales, es decir
//en process.env.SERVER_TOKEN_EXPIRETIME ?? 7200, solo se coloca 7200, y asi con el resto