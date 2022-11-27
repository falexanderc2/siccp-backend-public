import { Router } from 'express'
import { deleteDebtsToPays, getDebtsToPay, getDebtsToPays, postDebtsToPays, getDebtsToPaysFilter, getDebtsToPaysTotal, getDebtsToPaysResumen, } from '../controllers/debts_to_plays'

const debtsToPays = Router()
debtsToPays.get('/debts_to_pays/:idEnterprise/:idDebtToPay?', getDebtsToPays)
debtsToPays.get('/debts_to_pays/search/:idEnterprise/:idDebtToPay?', getDebtsToPay)
debtsToPays.get('/debts_to_pays/search/filter/:idEnterprise/:idCreditor/:fields', getDebtsToPaysFilter)
debtsToPays.get('/debts_to_pays/search/total/:idEnterprise/:idCreditor', getDebtsToPaysTotal)
debtsToPays.get('/debts_to_pays/search/resumen/totales/:idEnterprise', getDebtsToPaysResumen)
debtsToPays.post('/debts_to_pays/', postDebtsToPays)
debtsToPays.put('/debts_to_pays/:idDebtToPay', postDebtsToPays)
debtsToPays.delete('/debts_to_pays/:idEnterprise/:idDebtToPay', deleteDebtsToPays)

export default debtsToPays

