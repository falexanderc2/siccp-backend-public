
import express, { Router } from 'express'
import { deleteAdministrators, getAdministrator, getAdministrators, postAdministrators } from '../controllers/administrators'
const administrators = Router()

administrators.get('/administrators/:id?', getAdministrators)
administrators.get('/administrators/search/:id?', getAdministrator)
administrators.post('/administrators', postAdministrators)
administrators.put('/administrators/:id', postAdministrators)
administrators.delete('/administrators/:id', deleteAdministrators)

export default administrators
