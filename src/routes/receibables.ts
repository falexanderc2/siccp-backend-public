import { Router } from 'express'
import { deleteReceibables, getReceibable, getReceibables, postReceibables, getReceibableFilter, getReceibableTotal, getReceibableResumen } from '../controllers/receibables'

const receibables = Router()
receibables.get('/receibables/:idEnterprise/:idReceibable?', getReceibables)
receibables.get('/receibables/search/:idEnterprise/:idReceibable?', getReceibable)
receibables.get('/receibables/search/filter/:idEnterprise/:idCustomer/:fields', getReceibableFilter)
receibables.get('/receibables/search/total/:idEnterprise/:idCustomer', getReceibableTotal)
receibables.get('/receibables/search/resumen/totales/:idEnterprise', getReceibableResumen)
receibables.post('/receibables/', postReceibables)
receibables.put('/receibables/:idReceibable', postReceibables)
receibables.delete('/receibables/:idEnterprise/:idReceibable', deleteReceibables)

export default receibables 
