
DROP FUNCTION IF EXISTS receibables.register_collect;

CREATE OR REPLACE FUNCTION receibables.register_collect (
    IN p_action INT,
    IN p_idEnterprise BIGINT,
    IN p_idReceibable BIGINT,
    IN p_idCollectNumber BIGINT,
    IN p_amount DECIMAL(18,2) , -- Es el monto total de la deuda
    IN p_paymentDate DATE  , -- fecha en que se adquirio la deuda
    IN p_observations CHARACTER VARYING ,
    in p_montoDolar DECIMAL(18,2), -- Monto del dolar 
		in p_tipoDolar  CHARACTER VARYING, --Especifica si el dolar es paralelo o oficial
    in p_annulledPayment char(2)
) RETURNS JSON
AS $$
DECLARE
  errorFound boolean DEFAULT false;
  rowAffect INT DEFAULT 0;
  rowAffect2 INT DEFAULT 0;
  rowAffect3 INT DEFAULT 0;
  foundRow INT DEFAULT 0;
  messageInfo VARCHAR(400) DEFAULT '';
  success boolean DEFAULT false;
  aux_id BIGINT DEFAULT 0;
  _remainingDebt DECIMAL(18,2) DEFAULT  0;
  _amountPaid DECIMAL(18,2) DEFAULT 0;
  _debtPaid CHAR(2) DEFAULT '';
  _montoDeudor DECIMAL(18,2)   DEFAULT 0;
	_amount DECIMAL(18,2)   DEFAULT 0;
  --DATA CREDITOR
  _idCustomer BIGINT DEFAULT 0;
  _idReceibable BIGINT DEFAULT 0;
  rowAffect4 INT DEFAULT 0;
  rowAffect5 INT DEFAULT 0;
  _idCreditor BIGINT DEFAULT 0;
  _creditorName VARCHAR(250) DEFAULT '';
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_hint    TEXT;
  v_context TEXT;
  BEGIN
  
  -- 1 verifico que exista deuda y que no este cancelada
SELECT COUNT(*),"remainingDebt", "debtPaid","idCustomer" INTO foundRow,_remainingDebt, _debtPaid,_idCustomer
 FROM receibables.receibables WHERE "idReceibable" = p_idReceibable GROUP BY "remainingDebt", "debtPaid","idCustomer";

IF foundRow=0 THEN
    errorFound:=true;
    messageInfo := 'LOS DATOS DE LA DEUDA NO FUERON LOCALIZADOS. NO ES POSIBLE REGISTRAR LOS DATOS';
   -- SELECT errorFound, success,messageInfo, rowAffect, p_idCollectNumber;
     return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',p_idCollectNumber));
ELSE
    IF _debtPaid='SI' THEN
        messageInfo := 'NO SE REGISTRARON LOS DATOS PORQUE LA DEUDA HA SIDO PAGADA EN SU TOTALIDAD';
        --SELECT errorFound, success,messageInfo, rowAffect, p_idCollectNumber;
        return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',p_idCollectNumber));
    END IF;
END IF;


 --2  resto el monto pagado con la deuda restante
  _remainingDebt:=_remainingDebt - p_amount;

 --si el existe un remanente de dinero es decir lo pagado supera la deuda se debe realizar una creación de una deuda por cobrar
 --con el acredor es decir el acreedor pasará a ser un deudor.

_amount:=p_amount;
IF _remainingDebt<0 THEN
   SELECT ABS(_remainingDebt ) INTO _montoDeudor;
	 _remainingDebt:=0;
	 _amount:=p_amount- _montoDeudor;
END IF;   
 --3registro los datos
  
  p_observations := UPPER(TRIM(p_observations));
 
      INSERT INTO receibables."collectDebts" (
            "idEnterprise", "idReceibable", "paymentDate", amount ,
            observations ,"remainingDebt","tipoDolar","montoDolar"
      )
      VALUES (
          p_idEnterprise ,p_idReceibable , p_paymentDate, _amount ,
          p_observations ,_remainingDebt,p_tipoDolar,p_montoDolar
       )RETURNING "idCollectNumber" into aux_id;
      GET DIAGNOSTICS rowAffect = ROW_COUNT;
      
    -- 4 actualizo los datos de la deuda
    SELECT SUM(amount) INTO _amountPaid FROM receibables."collectDebts" WHERE "annulledPayment"='NO' 
    AND ("idReceibable"=p_idReceibable);
    
    UPDATE receibables.receibables SET "amountPaid"=_amountPaid, 
         "remainingDebt"=(CASE WHEN ("amountDebt" - _amountPaid)<=0 THEN
                          0 ELSE
                          ("amountDebt" - _amountPaid)
                         END),
        "debtPaid"=(CASE WHEN ("amountDebt" - _amountPaid)<=0 THEN
                          'SI' ELSE 'NO'
                         END),
         "paymentNumber"=("paymentNumber" + 1) 
    WHERE "idReceibable" = p_idReceibable;
   GET DIAGNOSTICS rowAffect2 = ROW_COUNT;
   
    --UPDATE receibables.receibables SET "debtPaid"='SI', "remainingDebt"=0
    --WHERE ("remainingDebt"<=0 ) AND ("idReceibable" = p_idReceibable);

IF _montoDeudor>0 THEN
  --se revisa si el customer esta registrado como creditor, si no esta se registra
  SELECT COUNT(*),"customerName" INTO rowAffect4,_creditorName FROM customers.customers WHERE "idCustomer"=_idCustomer GROUP BY "customerName";
  IF rowAffect4>0 THEN
    SELECT COUNT(*),"idCreditor" INTO rowAffect5,_idCreditor FROM creditors.creditors WHERE "creditorName"=_creditorName AND "idEnterprise"=p_idEnterprise  GROUP BY "idCreditor"; 
    IF rowAffect5 = 0 THEN -- SI NO EXISTE LO INSERTA Y OBTIENE EL idCustomer
      INSERT INTO creditors.creditors ("idEnterprise","creditorName",phone,address,email,reputation)  ( SELECT "idEnterprise","customerName",phone,address,email,'SIN EVALUACION' from customers.customers WHERE "idCustomer" = _idCustomer)RETURNING "idCreditor" into _idCreditor;
      
    END IF;
  END IF;

   INSERT INTO "debitToPay".debts_to_pay ("idEnterprise","idCreditor","debtDescription","dateDebts", "amountDebt" ,"remainingDebt","paymentStartDate" )
      VALUES (
          p_idEnterprise ,_idCustomer , CONCAT('DEUDA REMANENTE DE CUENTA POR PAGAR No: ' ,p_idReceibable,' No DE PAGO: ',aux_id), CURRENT_DATE, _montoDeudor ,_montoDeudor,CURRENT_DATE
       )RETURNING "idDebtToPay" into _idReceibable;
       GET DIAGNOSTICS rowAffect3 = ROW_COUNT;
END IF;
 
  
  IF rowAffect > 0 THEN
   IF rowAffect2>0 THEN
    messageInfo := 'LOS DATOS FUERON REGISTRADOS CON EXITO!.';
   ELSE
    messageInfo := 'SE REGISTRO EL PAGO PERO NO SE PUDO ACTUALIZAR LA INFORMACION DE LA DEUDA';
   END IF;
   IF _montoDeudor>0 THEN
    IF rowAffect3>0 THEN
       messageInfo := CONCAT('TODOS LOS DATOS FUERON REGISTRADOS. SE CREO UNA CUENTA POR COBRAR PORQUE EL PAGO ERA MAYOR QUE LA DEUDA. EL NUMERO DE CUENTA CREADA ES: ' , _idReceibable);
    ELSE
      messageInfo := 'SE REGISTRO Y SE ACTUALIZARON LA INFORMACION DE LA DEUDA, PERO NO SE PUDO CREAR UNA CUENTA POR COBRAR';
    END IF;
   END IF;
      success := true;
      IF (p_action = 2) THEN
         aux_id := p_idCollectNumber;
      END IF;
      return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      --SELECT errorFound, success,messageInfo, rowAffect, aux_id;
  ELSE
      success := false;
      messageInfo := 'NO SE LOGRO REGISTRAR LOS DATOS';
      return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      --SELECT errorFound,  success,  messageInfo,   rowAffect,   aux_id;
  END IF;
  
  /*************COLOCO LA EXCEPCION PARA CONTROLAR LOS ERRORES************/
  EXCEPTION WHEN others  THEN  
 
   get stacked diagnostics
        v_state   = returned_sqlstate,
        v_msg     = message_text,
        v_detail  = pg_exception_detail,
        v_hint    = pg_exception_hint,
        v_context = pg_exception_context;
  	success := false;
    errorFound :=true;
    rowAffect:=0;
    aux_id:=0;
		messageInfo := 'NO SE REGISTRO LA INFORMACION PORQUE: '|| SQLERRM ;--SQLERRM
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
END;
$$
LANGUAGE plpgsql;