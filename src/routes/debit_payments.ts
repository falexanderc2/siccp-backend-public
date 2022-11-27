import { Router } from 'express'
import { cancelDebitPayments, getDebitPayment, getDebitPayments, postDebitPayments, getDebitPaymentResumen } from '../controllers/debit_payments'

const debitPayments = Router()

debitPayments.get('/debit_payments/:idEnterprise/:idDebtToPay', getDebitPayments)
debitPayments.get('/debit_payments/search/:idEnterprise/:idPaymentNumber', getDebitPayment)
debitPayments.get('/debit_payments/resumen/:idEnterprise/:startDate/:endDate/:idCreditor?', getDebitPaymentResumen)
debitPayments.post('/debit_payments/', postDebitPayments)
debitPayments.post('/debit_payments/cancel/', cancelDebitPayments)

export default debitPayments


