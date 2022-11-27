DROP FUNCTION IF EXISTS enterprises.create_update;
CREATE OR REPLACE FUNCTION enterprises.create_update ( IN p_action integer , 
                                                             IN p_idEnterprise bigint , 
                                                             IN p_enterprisesName character varying , 
                                                             IN p_password character varying , 
                                                             IN p_email character varying,
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
	p_enterprisesName = UPPER(TRIM(p_enterprisesName));
	p_email := UPPER(TRIM(p_email));
	p_activated := UPPER(TRIM(p_activated));
	IF (p_action = 1) THEN
       select count(*) into foundRow from enterprises.enterprises where email=p_email;
      IF foundRow>0 THEN
        messageInfo:='EL EMAIL YA ESTA REGISTRADO POR OTRO USUARIO. INTENTE CON OTRO EMAIL';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
      END IF;
		  INSERT INTO enterprises.enterprises ("enterprisesName" , PASSWORD , email , activated)
			VALUES (p_enterprisesName , crypt(p_password , gen_salt('bf')) , p_email , p_activated)RETURNING "idEnterprise" into aux_id;
		ELSE
      select count(*) into foundRow from enterprises.enterprises where (email=p_email) and ("idEnterprise" <> p_idEnterprise);
      IF foundRow>0 THEN
        messageInfo:='EL EMAIL YA ESTA REGISTRADO POR OTRO USUARIO. INTENTE CON OTRO EMAIL';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
      END IF;
      UPDATE	enterprises.enterprises	SET	"enterprisesName" = p_enterprisesName	, email = p_email	, activated = p_activated
      WHERE	"idEnterprise" = p_idEnterprise;
	END IF;
  GET DIAGNOSTICS rowAffect = ROW_COUNT;
  
	IF rowAffect > 0 THEN
		success := true;
		IF p_action = 1 THEN
			messageInfo := 'LOS DATOS FUERON REGISTRADOS CON EXITO!.';
		ELSE
			aux_id := p_idEnterprise;
			messageInfo := 'LOS DATOS FUERON ACTUALIZADOS CON EXITO!.';
		END IF;
		return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
	ELSE
		success := false;
		messageInfo := 'NO SE LOGRO REGISTRAR LOS DATOS';
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
    
   -- RAISE EXCEPTION 'NO SE REGISTRO LA INFORMACION PORQUE: %', (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect, 'aux_id',aux_id));
END;
$$
LANGUAGE plpgsql;


