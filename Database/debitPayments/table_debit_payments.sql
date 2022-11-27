
DROP table IF EXISTS "debitToPay".debit_payments;--pago de cuentas
create table "debitToPay".debit_payments(
  "idPaymentNumber" bigserial NOT NULL, -- numero de pago
  "idDebtToPay" BIGINT NOT NULL REFERENCES "debitToPay".debts_to_pay ("idDebtToPay") MATCH FULL ON DELETE RESTRICT,-- id de la deuda por pagar
  "idEnterprise" BIGINT NOT NULL REFERENCES enterprises.enterprises ("idEnterprise") MATCH FULL ON DELETE RESTRICT,
  "paymentDate" DATE not null  , -- fecha en que se realizo el pago
  amount DECIMAL(18,2) DEFAULT 0, -- Es el monto pagado
  "remainingDebt" DECIMAL(18,2) DEFAULT 0, -- Es la monto restante de la deuda
  "tipoDolar" varchar(10) DEFAULT '',--PUEDE SER OFICIAL O OTROS
  "montoDolar" decimal(18,2) DEFAULT 0,-- ES EL MONTO DEL DOLAR SELECCIONADO
  "observations" varchar(250) not null DEFAULT '',
  "annulledPayment" varchar(2) DEFAULT ('NO'), -- Indica si el pago esta anulado
  "admissionDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora en que se genero la transacción
  PRIMARY KEY ("idPaymentNumber")
)


--ALTER TABLE "debitToPay".debit_payments ADD COLUMN "tipoDolar" varchar(10) DEFAULT '';
--ALTER TABLE "debitToPay".debit_payments ADD COLUMN "montoDolar" decimal(18,2) DEFAULT 0;

