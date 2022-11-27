DROP TABLE IF EXISTS receibables."collectDebts";--pagos de cuentas
CREATE TABLE receibables."collectDebts"(
  "idCollectNumber" bigserial NOT NULL, -- numero de pago
  "idReceibable" BIGINT NOT NULL REFERENCES receibables.receibables ("idReceibable") MATCH FULL ON DELETE RESTRICT,-- id de la deuda por pagar
  "idEnterprise" BIGINT NOT NULL REFERENCES enterprises.enterprises ("idEnterprise") MATCH FULL ON DELETE RESTRICT,
  "paymentDate" DATE not null  , -- fecha en que se realizo el pago
  amount DECIMAL(18,2) DEFAULT 0, -- Es el monto pagado
  "remainingDebt" DECIMAL(18,2) DEFAULT 0, -- Es la monto restante de la deuda
  "tipoDolar" varchar(10) DEFAULT '',
  "montoDolar" decimal(18,2) DEFAULT 0,
  "observations" varchar(250) not null DEFAULT '',
  "annulledPayment" varchar(2) DEFAULT ('NO'), -- Indica si el pago esta anulado
  "admissionDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Fecha y hora en que se genero la transacción
  PRIMARY KEY ("idCollectNumber")
)

--ALTER TABLE receibables."collectDebts" ADD COLUMN "tipoDolar" varchar(10) DEFAULT '';
--ALTER TABLE receibables."collectDebts" ADD COLUMN "montoDolar" decimal(18,2) DEFAULT 0;