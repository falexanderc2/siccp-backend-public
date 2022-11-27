
import  { Router } from 'express'
import { deleteEnterprises, getEnterprise, getEnterprises, postEnterprises } from '../controllers/enterprises'
const enterprises = Router()

enterprises.get('/enterprises/:idEnterprise?', getEnterprises)
enterprises.get('/enterprises/search/:idEnterprise?', getEnterprise)
enterprises.post('/enterprises', postEnterprises)
enterprises.put('/enterprises/:idEnterprise', postEnterprises)
enterprises.delete('/enterprises/:idEnterprise', deleteEnterprises)

export default enterprises
