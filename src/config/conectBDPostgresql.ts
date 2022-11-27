import message from './message'
import * as promise from 'bluebird'; // best promise library today
import pgPromise from 'pg-promise';
import { settingBD } from '../config/setting'
import IReply, { defaultReply } from '../interfaces/reply'

//conect database
const NAMESPACE = 'CONECT BASE DATA'

const initOptions = {
  promiseLib: promise
};

export class DataBase {
  reply: IReply = defaultReply
  pool: any
  connection: any
  settingBD: any
  resultConnection: any

  constructor() {
    this.settingBD = settingBD
  }

  getConnection = (): any => {
    return this.connection
  }

  conexionDataBase = async (): Promise<boolean> => {
    console.log('Wait...! Connected to database....!');
    return await (async (): Promise<any> => {
      let result = true
      const pgp = pgPromise(initOptions);
      this.connection = await pgp(this.settingBD);
      await this.connection.connect().then((db: any) => {
        this.resultConnection = db
        console.log('Successful Connection Database...!')
        return result
      }).catch((error: any) => {
        message.error(NAMESPACE, 'Error: ', error)
        this.reply = { errorFound: true, messageInfo: 'ERROR CONNECT DATABASE', success: false, rowAffect: 0, data: [], logout: false }
        result = false
      })
    })()
  }
  runQuery = async (query: string): Promise<IReply> => {
    let result: any = await this.getConnection()
    if (result === false) {
      return (this.reply)
    } else {
      //console.log('desde runQuery la consulta: ', query)
      return await this.connection.result(query).then((dataFound: any) => {
        return this.reply = { errorFound: false, messageInfo: 'Results found: ' + dataFound.rowCount, success: true, rowAffect: dataFound.rowCount, data: dataFound.rows, logout: false }
      }).catch((error: any) => {
        /* console.log('error en runQuery:========= ')
        console.log('La consulta es: ', query)
        console.log(' error.message: ', error) */
        message.error(NAMESPACE, 'Error: ', error)
        this.reply = {
          errorFound: true, messageInfo: 'Ocurrio un error en la consulta', success: false,
          rowAffect: 0, data: [], logout: false
        }
        return (this.reply)
      })
    }
  }

  getFunction = async (params: Object, nameProcedure: string, nameOnlyProcedure: string): Promise<IReply> => {
    let dataArray: string[] = []
    dataArray = Object.values(params)// * converts an object to an array
    this.reply.errorFound = true
    this.reply.success = false
    if (!Array.isArray(dataArray)) {
      this.reply.messageInfo = 'Error in the structure of the parameters!'
      message.error(NAMESPACE, 'Error: ', this.reply.messageInfo)
      return this.reply
    }

    if (dataArray.length === 0) {
      this.reply.messageInfo = 'The parameters can not be empty!'
      message.error(NAMESPACE, 'Error: ', this.reply.messageInfo)
      return this.reply
    }

    if (nameProcedure.trim().length === 0) {
      this.reply.messageInfo = 'When you want to run a stored procedure, the name of the procedure must be specified!'
      message.error(NAMESPACE, 'Error: ', this.reply.messageInfo)
      return this.reply
    }

    let result: any = await this.getConnection()
    if (result === false) {
      return (this.reply)
    }
    return await this.connection.func(nameProcedure, params).then((dataFound: any) => {
      let _data = dataFound[0][nameOnlyProcedure]
      return (_data)
    }).catch((error: any) => {
      message.error(NAMESPACE, 'Error: ', error)
      this.reply = {
        errorFound: true, messageInfo: 'Ocurrio un error en la consulta', success: false,
        rowAffect: 0, data: [], logout: false
      }
      return (this.reply)
    })
  }

}