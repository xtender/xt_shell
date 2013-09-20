XT_SHELL oracle package
=============

For Executing shell commands with timeout(milliseconds).
Returns stdout and stderr as table of varchar2

Functions
-------

### xt_shell.shell_exec(pCommand in varchar2,timeout in number)

Returns varchar2 collection (varchar2_table)

Input params

* pCommand - string with command 
* timeout - timeout after which command interrupts(milliseconds)

Installation
-------

Change to your locale in xt_shell.jsp(lines #24-27) and execute scripts in this order:

* @varchar2_table.tps
* @xt_shell.jsp
* @XT_SHELL.spc

Examples
-------

### Pl/SQL block:

    declare
      output varchar2_table;
    begin
      output:=xt_shell.shell_exec('/bin/ls -l',100);
      for c in output.first..output.last loop
        dbms_output.put_line(output(c));
      end loop;
    end;

### SQL:

    select * from table(xt_shell.shell_exec('/bin/ls -l',100))
