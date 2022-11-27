import { Router } from 'express'
import { deleteCreditors, getCreditor, getCreditors, getCreditorsFilter, postCreditors } from '../controllers/creditors'

const creditors = Router()

creditors.get('/creditors/:idEnterprise/:idCreditor?', getCreditors)
creditors.get('/creditors/search/:idEnterprise/:idCreditor?', getCreditor)
creditors.get('/creditors/search/filters/:idEnterprise/:fields', getCreditorsFilter)
creditors.post('/creditors/', postCreditors)
creditors.delete('/creditors/:idEnterprise/:idCreditor', deleteCreditors)

export default creditors

