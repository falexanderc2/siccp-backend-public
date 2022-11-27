import cors from 'cors'
import express, { json, Request, Response, NextFunction } from 'express'
import collectDebts from './routes/collectDebts'
import creditors from './routes/creditors'
import customers from './routes/customers'
import debtsToPays from './routes/debit_payments'
import debitPayments from './routes/debts_to_pays'
import enterprises from './routes/enterprises'
import loginEnterprises from './routes/loginEnterprise'
import receibables from './routes/receibables'
import { HOSTNAME, PORT } from './config/config'
import message from './config/message'
import verifyToken from './middleware/checkToken'
import administrators from './routes/administrator'
import loginAdministrators from './routes/loginAdministrators'
const listRoutes = ['enterprises', 'customers', 'creditors', 'debts_to_pays', 'debit_payments', 'receibables', 'collectdebts', 'administrators', 'loginenterprises', 'loginadministrators']

const app = express()

const NAMESPACE = 'Server';
app.use(cors())


app.use(async (req: Request, res: Response, next: NextFunction) => {
  // ? aqui se controla el acceso al sistema con el middleware verifyToken si el token es correcto se da paso al resto de rutas de lo contrario se envia un mensaje al cliente
  const split = req.url.split(`\/`);
  message.info(NAMESPACE, `METHOD: [${req.method}] - URL: [${req.url}] - IP: [${req.socket.remoteAddress}]`);
  console.info('EVALUANDO RUTA DE PETICION...!')
  const isValid: boolean = ((listRoutes.find((element) => element === split[1])) === undefined) ? false : true
  if (!isValid) {
    console.warn('LA PETICION FUE RECHAZADA POR NO COINCIDIR CON NINGUN ENDPOINT...!')
    return res.status(404).json({ errorFound: true, messageInfo: 'LA RUTA SOLICITADA NO ESTA REGISTRADA.', success: false, logout: false })
  }
  if ((req.url !== '/loginenterprises') && (req.url !== '/loginadministrators')) {
    await verifyToken(req, res, next).then((response) => {
      if (response.errorFound) {
        return res.status(403).json(response);
      } else {
        next()
      }
    })
  } else {
    next()
  }
});

app.use(json())
app.use(administrators)
app.use(enterprises)
app.use(customers)
app.use(creditors)
app.use(debtsToPays)
app.use(debitPayments)
app.use(receibables)
app.use(collectDebts)
app.use(loginAdministrators)
app.use(loginEnterprises)

console.clear()
const server = app.listen(PORT, () => {
  message.info(NAMESPACE, `Server listening on http://${HOSTNAME}:${PORT}`)
}) 
