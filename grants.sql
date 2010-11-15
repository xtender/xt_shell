begin
  --change to needed permissions and execute
  dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'read,write,execute' );
end;
