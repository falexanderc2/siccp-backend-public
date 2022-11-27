DROP FUNCTION IF EXISTS "debitToPay".delete;

CREATE FUNCTION "debitToPay".delete(IN p_idDebtToPay BIGINT) RETURNS JSON 
AS
$$
DECLARE	
  errorFound boolean DEFAULT false;
	rowAffect bigint DEFAULT 0;
	foundRow integer DEFAULT 0;
	messageInfo varchar(250) DEFAULT '';
	success boolean DEFAULT false;
	aux_id bigint DEFAULT 0;
  v_detail   TEXT;
   
BEGIN
DELETE FROM "debitToPay".debts_to_pay WHERE "idDebtToPay" = p_idDebtToPay;
 GET DIAGNOSTICS rowAffect = ROW_COUNT;

  IF rowAffect>0 THEN
    success := true;
    messageInfo := 'LOS DATOS FUERON ELIMINADOS CON EXITO!.';
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',p_idDebtToPay));
  ELSE
    errorFound:=true;
    success:=false;
    messageInfo:='NO SE LOGRO ELIMINAR LOS DATOS';
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',p_idDebtToPay));
  END IF;

/*************COLOCO LA EXCEPCION PARA CONTROLAR LOS ERRORES************/
  EXCEPTION WHEN others  THEN  
   get stacked diagnostics 
   v_detail  = pg_exception_detail;
   	success := false;
    errorFound :=true;
    rowAffect:=0;
		messageInfo := 'NO SE ELIMINO LA INFORMACION PORQUE: '|| SQLERRM ;--SQLERRM
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',p_idDebtToPay));
END;
$$
LANGUAGE plpgsql;
