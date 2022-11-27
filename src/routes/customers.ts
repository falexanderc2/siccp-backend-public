
import { Router } from 'express'
import { deleteCustomers, getCustomer, getCustomers, getCustomersFilter, postCustomers } from '../controllers/customers'

const customers = Router()

customers.get('/customers/:idEnterprise/:idCustomer?', getCustomers)
customers.get('/customers/search/:idEnterprise/:idCustomer?', getCustomer)
customers.get('/customers/search/filters/:idEnterprise/:fields', getCustomersFilter)
customers.post('/customers/', postCustomers)
customers.put('/customers/:idCustomer', postCustomers)
customers.delete('/customers/:idEnterprise/:idCustomer', deleteCustomers)

export default customers
