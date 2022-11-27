
DROP FUNCTION IF EXISTS receibables.cancel_collect_debts;

CREATE FUNCTION receibables.cancel_collect_debts (
    IN p_idCollectNumber BIGINT
) RETURNS JSON
AS $$
DECLARE
   errorFound boolean DEFAULT false;
  rowAffect INT DEFAULT 0;
  rowAffect2 INT DEFAULT 0;
  foundRow INT DEFAULT 0;
  messageInfo VARCHAR(250) DEFAULT '';
  success boolean DEFAULT false;
  aux_id BIGINT DEFAULT 0;
  _remainingDebt DECIMAL(18,2) DEFAULT  0;
  _amountPaid DECIMAL(18,2) DEFAULT 0;
  _debtPaid CHAR(2) DEFAULT '';
  _annulledPayment CHAR(2) DEFAULT '';
  _idReceibable BIGINT DEFAULT 0;
    v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_hint    TEXT;
  v_context TEXT;
 BEGIN
SELECT COUNT(*),"idReceibable",amount,"annulledPayment" INTO foundRow,_idReceibable,_amountPaid,_annulledPayment 
FROM receibables."collectDebts" WHERE "idCollectNumber"=p_idCollectNumber GROUP BY "idReceibable",amount,"annulledPayment";

  IF foundRow=0 THEN
    errorFound:=true;
    messageInfo := 'LOS DATOS DE LA DEUDA NO FUERON LOCALIZADOS. NO ES POSIBLE ANULAR EL PAGOS';
    --SELECT errorFound, success,messageInfo, rowAffect, p_idCollectNumber;
     return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',p_idCollectNumber));
  END IF;

  IF _annulledPayment='SI'THEN
    errorFound:=true;
    messageInfo := 'IMPOSIBLE ANULAR EL PAGOS, PORQUE YA ESTA REGISTRADO COMO ANULADO.';
    --SELECT errorFound, success,messageInfo, rowAffect, p_idCollectNumber;
     return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',p_idCollectNumber));
    
  END IF;

  UPDATE receibables."collectDebts"  SET "annulledPayment"='SI'  WHERE "idCollectNumber" = p_idCollectNumber;

   GET DIAGNOSTICS rowAffect = ROW_COUNT;
  
  -- RESTO LOS VALORES EN LA TABLA RECECIBABLES
  UPDATE receibables.receibables SET "amountPaid"=("amountPaid" - _amountPaid), 
  "debtPaid" = 'NO', 
   "remainingDebt" =(case when ("remainingDebt"<=0) then -- si el monto restante de la deuda es menor o igual a cero  entoces el moto restante sera igual al monto inicial de la deuda
										              "amountPaid"
										  WHEN ("remainingDebt" + _amountPaid)> "amountDebt"  THEN-- si la suma del restante con el monto a anular es mayor que la deuda total
										 "amountDebt"
										 ELSE
										( "remainingDebt" + _amountPaid)
                    end),
										"paymentNumber"=("paymentNumber"-1)

  WHERE "idReceibable" = _idReceibable;
 

  GET DIAGNOSTICS rowAffect2 = ROW_COUNT;

  IF rowAffect > 0 THEN
   IF rowAffect2>0 THEN
	 errorFound:=false;
    messageInfo := 'EL PAGO FUE ANULADO!.';
   ELSE
    messageInfo := 'SE ANULO EL PAGO, PERO NO SE LOGRO ACTUALIZAR LA DEUDA';
		errorFound:=true;
   END IF;
      success := true;
     
        aux_id := p_idCollectNumber;
     
      --SELECT errorFound, success,messageInfo, rowAffect, aux_id;
      return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
  ELSE
	 errorFound:=true;
      success := false;
      messageInfo := 'NO SE LOGRO REGISTRAR LOS DATOS';
      --SELECT errorFound,  success,  messageInfo,   rowAffect,   aux_id;
      return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
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
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
END;
$$
LANGUAGE plpgsql;