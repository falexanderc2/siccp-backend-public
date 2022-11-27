import { Router } from 'express'
import { postLoginEnterprise, saludoLogin } from '../controllers/loginEnterprises'
const loginEnterprises = Router()
loginEnterprises.post('/loginenterprises', postLoginEnterprise)
loginEnterprises.get('/loginenterprises', saludoLogin)

export default loginEnterprises