import { Router } from 'express'
import { cancelCollectDebts, getCollectDebt, getCollectDebts, postCollectDebts, getCollectDebtResumen } from '../controllers/collectDebts'

const collectDebts = Router()
collectDebts.get('/collectdebts/:idEnterprise/:idReceibable', getCollectDebts)
collectDebts.get('/collectdebts/search/:idEnterprise/:idCollectNumber', getCollectDebt)
collectDebts.get('/collectdebts/resumen/:idEnterprise/:startDate/:endDate/:idCustomer?', getCollectDebtResumen)
collectDebts.post('/collectdebts/', postCollectDebts)
collectDebts.post('/collectdebts/cancel/', cancelCollectDebts)

export default collectDebts


