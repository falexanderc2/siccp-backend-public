Drop Function If Exists administrators.login_administrators;

Create or replace
Function administrators.login_administrators (IN p_email Character varying, IN p_password Character varying) Returns
		json As $$

DECLARE
errorFound boolean DEFAULT false;
 rowAffect INT DEFAULT 0;
 foundRow INT DEFAULT 0;
 messageInfo VARCHAR(250) DEFAULT '';
 success boolean DEFAULT false;
 _id BIGINT DEFAULT 0;
 _userName VARCHAR(250) DEFAULT '';
 _email VARCHAR(250) DEFAULT '';
 _activated CHAR(2) DEFAULT '';
BEGIN
  SELECT COUNT(*),id,"userName", email,activated into foundRow,_id,_userName,_email, _activated
  from administrators.administrators WHERE LOWER(email)=LOWER(p_email) AND  password=crypt(p_password , password)
  GROUP BY id,"userName",email,activated;

if Not found then
  success:=false;
  errorFound :=true;
  messageInfo:='EMAIL O PASSWORD INCORRECTO';
  rowAffect := 0;
  return (select json_build_object('errorFound',  errorFound, 'success', success,'messageInfo', messageInfo,'rowAffect', rowAffect,'id', _id));

ELSE
  success:=true;
  errorFound :=false;
  messageInfo:='DATOS CORRECTO';
  rowAffect:=foundRow;
   return (select json_build_object ('errorFound', errorFound, 'success', success, 'messageInfo', messageInfo, 'rowAffect', rowAffect,'id', _id, 'userName',  _userName, 'email', _email, 'activated', _activated));
   
END IF;



END;
$$ Language Plpgsql;