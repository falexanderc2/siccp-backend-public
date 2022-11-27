DROP FUNCTION IF EXISTS creditors.create_update;

CREATE OR REPLACE FUNCTION creditors.create_update (
  IN p_action INTEGER,
  IN p_idEnterprise BIGINT,
  IN p_idCreditor BIGINT,
  IN p_creditorName character varying , 
  IN p_phone character varying , 
  IN p_address character varying , 
  IN p_email character varying , 
  IN p_observations character varying , 
  IN p_reputation character varying , 
  IN p_activated character varying 
	) RETURNS json
	AS $$
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
  
   p_creditorName = UPPER(TRIM(p_creditorName));
   p_phone = UPPER(TRIM(p_phone));
   p_address = UPPER(TRIM(p_address));
   p_email = UPPER(TRIM(p_email));
   p_observations = UPPER(TRIM(p_observations));
   p_reputation = UPPER(TRIM(p_reputation));
   p_activated = UPPER(TRIM(p_activated));
  
  IF p_action = 1 THEN
    select count(*) into foundRow from creditors.creditors where "idEnterprise" =p_idEnterprise and "creditorName"=p_creditorName;
    IF foundRow>0 THEN
      messageInfo:='EL NOMBRE YA ESTA REGISTRADO. INTENTE CON OTRO.';
      return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
    END IF;
    if p_email<>'' THEN
      select count(*) into foundRow from creditors.creditors where "idEnterprise" =p_idEnterprise and email=p_email;
      IF foundRow>0 THEN
        messageInfo:='EL EMAIL YA ESTA REGISTRADO. INTENTE CON OTRO.';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      END IF;
    END IF;
    INSERT INTO creditors.creditors ( "idEnterprise",  "creditorName",  phone, address,  email,   observations,  reputation, activated )
    VALUES (p_idEnterprise, p_creditorName, p_phone, p_address,  p_email,  p_observations,  p_reputation, p_activated  )RETURNING "idCreditor" into aux_id;
  ELSE
  
    select count(*) into foundRow from creditors.creditors where  ("idEnterprise" =p_idEnterprise) and ("creditorName"=p_creditorName) and ("idCreditor" <> p_idCreditor);
    IF foundRow>0 THEN
      messageInfo:='EL NOMBRE YA ESTA REGISTRADO. INTENTE CON OTRO.';
      return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
    END IF;
    if p_email<>'' THEN
      select count(*) into foundRow from creditors.creditors where ("idEnterprise" =p_idEnterprise) and (email=p_email) and  ("idCreditor" <> p_idCreditor);
        IF foundRow>0 THEN
          messageInfo:='EL EMAIL YA ESTA REGISTRADO. INTENTE CON OTRO.';
          return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
        END IF;
    END IF;
    UPDATE creditors.creditors
    SET "creditorName" = p_creditorName,
      phone = p_phone,
      address = p_address,
      email = p_email,
      observations = p_observations,
      reputation = p_reputation,
      activated = p_activated
    WHERE "idCreditor" = p_idCreditor;
  END IF;
  GET DIAGNOSTICS rowAffect = ROW_COUNT;
  
	IF rowAffect > 0 THEN
		success := true;
		IF p_action = 1 THEN
			messageInfo := 'LOS DATOS FUERON REGISTRADOS CON EXITO!.';
		ELSE
			aux_id := p_idCreditor;
			messageInfo := 'LOS DATOS FUERON ACTUALIZADOS CON EXITO!.';
		END IF;
		return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
	ELSE
		success := false;
		messageInfo := 'NO SE LOGRO REGISTRAR LOS DATOS';
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
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