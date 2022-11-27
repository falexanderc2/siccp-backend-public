import { Router } from 'express'
import { postLoginAdministrators, saludoLogin } from '../controllers/loginAdministrators'
const loginAdministrators = Router()
loginAdministrators.post('/loginadministrators', postLoginAdministrators)
loginAdministrators.get('/loginadministrators', saludoLogin)

export default loginAdministrators