DROP table IF EXISTS "debitToPay".debts_to_pay;--cuentas por pagar
create table "debitToPay".debts_to_pay(
  "idDebtToPay" bigserial NOT NULL,
  "idEnterprise" BIGINT NOT NULL REFERENCES enterprises.enterprises ("idEnterprise") MATCH FULL ON DELETE RESTRICT,
  "idCreditor" BIGINT NOT NULL REFERENCES creditors.creditors ("idCreditor") MATCH FULL ON DELETE RESTRICT,
  "debtDescription"  varchar(250) not null, -- descripcion de la deuda
  "dateDebts" DATE not null  , -- fecha en que se adquirio la deuda
  "amountDebt" DECIMAL(18,2) DEFAULT 0, -- Es el monto total de la deuda
  "numberOfPayments" int NOT NULL DEFAULT 0,-- Es el numeros de cuotas que se tienen para pagar la deuda
  "amountToBePaidIninstallments" DECIMAL(18,2) DEFAULT 0, -- cantidad a pagar en cuotas
  "numberOfDaysForInstallments" int not null DEFAULT 5, -- cantidad de dias entre cuotas para cancelar la deuda,
  "paymentStartDate" DATE not null  , -- fecha en que se comenzara a pagar la deuda
  "paymentNumber" int DEFAULT 0, -- Cantidad de  cuotas canceladas
  "amountPaid"  DECIMAL(18,2) DEFAULT 0, -- Total pagado de la deuda
  "remainingDebt" DECIMAL(18,2) DEFAULT 0, -- Es la monto restante de la deuda
  observations varchar(250) not null DEFAULT '',
  "debtPaid" varchar(2) DEFAULT 'NO', -- Indica si la deuda esta pagada
 "admissionDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("idDebtToPay") 
)
