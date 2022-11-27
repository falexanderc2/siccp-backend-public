DROP FUNCTION IF EXISTS administrators.create_update;
CREATE OR REPLACE FUNCTION administrators.create_update ( 
															IN p_action integer , 
                                                          	IN p_id bigint , 
                                                          	IN p_userName character varying,
                                                          	IN p_password character varying , 
                                                          	IN p_email character varying,
                                                          	IN p_activated character(2) 
                                                         ) RETURNS json
	AS $$
  DECLARE 
	errorFound boolean default false;
	rowAffect bigint default 0;
	foundRow bigint default 0;
	messageInfo varchar(250) default '';
	success boolean default false;
	aux_id bigint default 0;
	v_state text;
	v_msg text;
	v_detail text;
	v_hint text;
	v_context text;
BEGIN
	p_email := UPPER(TRIM(p_email));
  p_userName := UPPER(TRIM(p_userName));
 
	IF (p_action = 1) then
		 select COUNT(*) into foundRow from administrators.administrators where "userName"= p_userName;
		  IF foundRow>0 THEN
        messageInfo:='EL NOMBRE INDICADO YA ESTA REGISTRADO. INTENTE CON OTRO NOMBRE.';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      END IF;
      select count(*) into foundRow from administrators.administrators where email=p_email;
      IF foundRow>0 THEN
        messageInfo:='EL EMAIL YA ESTA REGISTRADO POR OTRO ADMINISTRADOR. INTENTE CON OTRO EMAIL';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      END IF;
		  INSERT INTO administrators.administrators ("userName",email , PASSWORD )
			VALUES (p_userName,p_email , crypt(p_password , gen_salt('bf')) )RETURNING id into aux_id;
		ELSE
      select count(*) into foundRow from administrators.administrators where ("userName" = p_userName) and (id <> p_id);
      IF foundRow>0 THEN
        messageInfo:='EL NOMBRE INDICADO YA ESTA REGISTRADO. INTENTE CON OTRO NOMBRE.';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      END IF;
     select count(*) into foundRow from administrators.administrators where (email=p_email) and (id <> p_id);
      IF foundRow>0 THEN
        messageInfo:='EL EMAIL YA ESTA REGISTRADO POR OTRO USUARIO. INTENTE CON OTRO EMAIL';
        return (select json_build_object('errorFound',true, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
      END IF;
      UPDATE	administrators.administrators	SET "userName"=p_userName,password =  crypt(p_password , gen_salt('bf')),activated = p_activated 
      WHERE	id = p_id;
	END IF;
  GET DIAGNOSTICS rowAffect = ROW_COUNT;
  
	IF rowAffect > 0 THEN
		success := true;
		IF p_action = 1 THEN
			messageInfo := 'LOS DATOS FUERON REGISTRADOS CON EXITO!.';
		ELSE
			aux_id := p_id;
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
    
   -- RAISE EXCEPTION 'NO SE REGISTRO LA INFORMACION PORQUE: %', (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
    return (select json_build_object('errorFound',errorFound, 'success',success, 'messageInfo',messageInfo, 'rowAffect',rowAffect,'id',aux_id));
END;
$$
LANGUAGE plpgsql;

