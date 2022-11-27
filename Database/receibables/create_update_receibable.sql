DROP FUNCTION IF EXISTS receibables.create_update;


CREATE OR REPLACE FUNCTION receibables.create_update (
    IN p_action INT,
    IN p_idEnterprise BIGINT,
    IN p_idCustomer BIGINT,
    IN p_idReceibable BIGINT,
    IN p_debtDescription  character varying   , -- descripcion de la deuda
    IN p_dateDebts DATE   , -- fecha en que se adquirio la deuda
    IN p_amountDebt DECIMAL(18,2) , -- Es el monto total de la deuda
    IN p_numberOfPayments INT ,-- Es el numeros de cuotas que se tienen para pagar la deuda
    IN p_amountToBePaidIninstallments DECIMAL(18,2) , -- cantidad a pagar en cuotas
   -- IN p_numberOfDaysForInstallments INT, -- cantidad de dias entre cuotas para cancelar la deuda,
    IN p_paymentStartDate DATE , -- fecha en que se comenzara a pagar la deuda
    IN p_observations character varying   
    
) RETURNS JSON AS $$

 DECLARE 
  errorFound boolean DEFAULT false;
	rowAffect bigint DEFAULT 0;
	foundRow bigint DEFAULT 0;
	messageInfo varchar(250) DEFAULT '';
	success boolean DEFAULT false;
	aux_id bigint DEFAULT 0;
  v_state   TEXT;
  v_msg     TEXT;
  v_detail  TEXT;
  v_hint    TEXT;
  v_context TEXT;

BEGIN
  
  p_debtDescription := UPPER(TRIM(p_debtDescription));
  p_observations := UPPER(TRIM(p_observations));
  IF p_action = 1 THEN
          INSERT INTO receibables.receibables (
            "idEnterprise", "idCustomer",  "debtDescription",  "dateDebts", "amountDebt" ,
            "numberOfPayments", "amountToBePaidIninstallments" ,
            --"numberOfDaysForInstallments" ,
            "paymentStartDate",observations ,"remainingDebt"
      )
      VALUES (
          p_idEnterprise ,p_idCustomer , p_debtDescription, p_dateDebts, p_amountDebt ,
          p_numberOfPayments, p_amountToBePaidIninstallments , 
          --p_numberOfDaysForInstallments ,
          p_paymentStartDate, p_observations ,p_amountDebt
       )RETURNING "idReceibable" into aux_id;
 
  ELSE
      UPDATE receibables.receibables  SET 
            "idEnterprise" = p_idEnterprise, 
            "idCustomer" = p_idCustomer,  
            "debtDescription" = p_debtDescription,  
            "dateDebts" = p_dateDebts, 
            "amountDebt" =(case when "paymentNumber"=0 then
                p_amountDebt else
                "amountDebt"
            end) ,
            "numberOfPayments" = p_numberOfPayments, 
            "amountToBePaidIninstallments" = p_amountToBePaidIninstallments,
            --"numberOfDaysForInstallments" = p_numberOfDaysForInstallments ,
            "paymentStartDate" =  p_paymentStartDate, 
            observations = p_observations
      WHERE "idReceibable" = p_idReceibable;
    
  END IF;
    GET DIAGNOSTICS rowAffect = ROW_COUNT;
  
	IF rowAffect > 0 THEN
		success := true;
		IF p_action = 1 THEN
			messageInfo := 'LOS DATOS FUERON REGISTRADOS CON EXITO!.';
		ELSE
			aux_id := p_idReceibable;
			messageInfo := 'LOS DATOS FUERON ACTUALIZADOS CON EXITO!.';
		END IF;
		return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',aux_id));
	ELSE
		success := false;
		messageInfo := 'NO SE LOGRO REGISTRAR LOS DATOS';
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',aux_id));
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
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',aux_id));
END;
$$
LANGUAGE plpgsql;