prompt ######################################################################
prompt *** Attention! ***
prompt This script will add java.io.FilePermission permissions!!!
prompt ;

accept _grantee prompt "Grantee[default &_USER]: " default "&_USER";
prompt ;
prompt *** Choose files or directories ***
doc

    If you are granting FilePermission, then you must provide the physical name 
    of the directory or file, such as /private/oracle. 
    You cannot provide either an environment variable, such as $ORACLE_HOME, 
    or a symbolic link. 
    To denote all files within a directory, provide the * symbol, as follows:
      /private/oracle/*
    
    To denote all directories and files within a directory, provide the - symbol, as follows:
      /private/oracle/-

#

accept _files prompt "Files or directories[default <<ALL FILES>>]: " default '<<ALL FILES>>';

accept _permissions prompt "Choose operations[default 'read,write,execute']: " default "read,write,execute";

prompt ######################################################################
prompt Will be executed this code: 
prompt dbms_java.grant_permission( upper('&_grantee'), 'SYS:java.io.FilePermission', '&_files', '&_permissions' );
prompt ######################################################################

accept _check prompt "Enter 'Y' if you want to add such permissions:"
set serverout on;
begin
    if upper('&_check')='Y' 
    then 
        dbms_java.grant_permission( upper('&_grantee'), 'SYS:java.io.FilePermission', '&_files', '&_permissions' ); 
        dbms_output.put_line('Permission was granted successfully.');
    else 
        dbms_output.put_line('*** Cancelled ***');
    end if;
end;
/
prompt 
prompt ######################################################################
prompt *** Current permissions for grantee:

col kind        for a8;
col grantee     for a20;
col type_schema for a20;
col type_name   for a25;
col name        for a50 word;
col action      for a20 word;
col enabled     for a10;

select kind,grantee,type_schema,type_name,name,action,enabled from dba_java_policy where grantee=upper('&_grantee');
col kind        clear;
col grantee     clear;
col type_schema clear;
col type_name   clear;
col name        clear;
col action      clear;
col enabled     clear;
undef _files _grantee _permissions _check;