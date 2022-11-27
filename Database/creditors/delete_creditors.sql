DROP FUNCTION IF EXISTS creditors.delete;

CREATE OR REPLACE FUNCTION creditors.delete(IN p_idCreditor BIGINT)
	RETURNS json
	AS $$
DECLARE	
  errorFound boolean DEFAULT false;
	rowAffect bigint DEFAULT 0;
	foundRow integer DEFAULT 0;
	messageInfo varchar(250) DEFAULT '';
	success boolean DEFAULT false;
	aux_id bigint DEFAULT 0;
  v_detail   TEXT;
   
BEGIN

  DELETE  FROM creditors.creditors  WHERE "idCreditor"=p_idCreditor;
 GET DIAGNOSTICS rowAffect = ROW_COUNT;

  IF rowAffect>0 THEN
    success := true;
    messageInfo := 'LOS DATOS FUERON ELIMINADOS CON EXITO!.';
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',p_idCreditor));
  ELSE
    errorFound:=true;
    success:=false;
    messageInfo:='NO SE LOGRO ELIMINAR LOS DATOS';
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',p_idCreditor));
  END IF;

/*************COLOCO LA EXCEPCION PARA CONTROLAR LOS ERRORES************/
  EXCEPTION WHEN others  THEN  
   get stacked diagnostics 
   v_detail  = pg_exception_detail;
   	success := false;
    errorFound :=true;
    rowAffect:=0;
		messageInfo := 'NO SE ELIMINO LA INFORMACION PORQUE: '|| SQLERRM ;--SQLERRM
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'id',p_idCreditor));
END;
$$
LANGUAGE plpgsql;


