create or replace package XT_SHELL is

  -- Author  : Sayan MALAKSHINOV aka xtender
  -- Mailto : xt.and.r@gmail.com
  -- Created : 06.11.2010 16:23:56
/**
 * Executes command in os and get output as varchar2_table
 * Timout in milliseconds
 */
  function shell_exec(pCommand varchar2,timeout number)
    return varchar2_table
    IS LANGUAGE JAVA
    name 'com.xt_r.XT_SHELL.SQLshellExec(java.lang.String,int) return oracle.sql.ARRAY';

end XT_SHELL;
/
