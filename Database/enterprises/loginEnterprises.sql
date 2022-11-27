Drop Function If Exists enterprises.login_enterprises;
Create or replace
Function enterprises.login_enterprises (IN p_email Character varying, IN p_password Character varying) Returns
		json As $$

DECLARE
errorFound boolean DEFAULT false;
 rowAffect INT DEFAULT 0;
 foundRow INT DEFAULT 0;
 messageInfo VARCHAR(250) DEFAULT '';
 success boolean DEFAULT false;
 _id BIGINT DEFAULT 0;
 _enterprisesName VARCHAR(250) DEFAULT '';
 _email VARCHAR(250) DEFAULT '';
 _activated CHAR(2) DEFAULT '';
BEGIN
  SELECT COUNT(*),"idEnterprise","enterprisesName", email,activated into foundRow,_id,_enterprisesName,_email, _activated
  from enterprises.enterprises WHERE LOWER(email)=LOWER(p_email) AND  password=crypt(p_password , password)
  GROUP BY "idEnterprise","enterprisesName",email,activated;

if Not found then
  success:=false;
  errorFound :=true;
  messageInfo:='EMAIL O PASSWORD INCORRECTO';
  rowAffect := 0;
  return (select json_build_object('errorFound',  errorFound, 'success', success,'messageInfo', messageInfo,'rowAffect', rowAffect,'id', _id));
--  return CONCAT('errorFound', ':', errorFound,',', 'success', ':', success,',', 'messageInfo', ':', messageInfo,',',  'rowAffect', ':', rowAffect, ',', '_id', ':', _id);
ELSE
  success:=true;
  errorFound :=false;
  messageInfo:='DATOS CORRECTO';
  rowAffect:=foundRow;
   return (select json_build_object ('errorFound', errorFound, 'success', success, 'messageInfo', messageInfo, 
                 'rowAffect', rowAffect,'id', _id, 'enterprisesName',  _enterprisesName,'userName',  _enterprisesName,
                   'email', _email, 'activated', _activated));
    --_result:= '{"errorFound": errorFound,"success":success, "messageInfo":messageInfo, "rowAffect":rowAffect,  "_id":_id,"_enterprisesName":_enterprisesName,"_email":_email,"_activated":_activated}'::json;
    -- return CONCAT('errorFound', ':', errorFound,',', 'success', ':', success,',', 'messageInfo', ':', messageInfo,',', 
                   --'rowAffect', ':', rowAffect, ',', '_id', ':', _id, ',', '_enterprisesName', ':', _enterprisesName, ',',
                   --'_email', ':', _email, ',', '_activated', ':', _activated);
END IF;



END;
$$ Language Plpgsql;