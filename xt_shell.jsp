create or replace and compile java source named xt_shell as
package com.xt_r;

/* Imports */
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;

import java.sql.*;

import oracle.sql.*;
import oracle.jdbc.driver.OracleDriver;

import System.Threading.Thread.*;
import java.lang.System.*;

/* Main class */
public class XT_SHELL
{
// uncomment for utf or change to your locale
//  public static final String ENCODING="UTF-8";
// for windows
//  public static final String ENCODING="CP1252";
// for russian windows
  public static final String ENCODING="CP1251";
/**
 * Function shellExec
 * @param String shell command
 * @return String
 */
  public static java.lang.String shellExec (String command,int TIMEOUT)
    throws SQLException
  {
      Worker worker = new Worker(command);
      try{
            worker.start();
            try {
              worker.join(TIMEOUT);
              if (worker.isAlive())
                 throw new InterruptedException("IntrException: Timeout exceed("+TIMEOUT+"ms)!");
              return worker.result.toString();
            } catch(InterruptedException ex) {
              worker.interrupt();
              Thread.currentThread().interrupt();
              return "Timeout exceed!("+TIMEOUT+"c.)";
            } finally {
              worker.process.destroy();
            }
      }catch(Exception e){
           worker.result.append("\nException(")
                        .append(e.toString())
                        .append("):")
                        .append(e.getCause())
                        .append(",")
                        .append(e.getMessage())
                        .append("\n\n");
           return worker.result.toString();
      }
  }
/**
 * Function shellExec
 * @param String shell command
 * @return String
 */
  public static oracle.sql.ARRAY SQLshellExec (String command,int TIMEOUT)
    throws SQLException
  {
    String shellResult = shellExec(command,TIMEOUT);
    Connection conn = new OracleDriver().defaultConnection();
         ArrayDescriptor descriptor =
            ArrayDescriptor.createDescriptor("VARCHAR2_TABLE", conn );
    oracle.sql.ARRAY outArray = new oracle.sql.ARRAY(descriptor,conn,shellResult.split("\n"));
    return outArray;
  }
/**
 * Worker
 */
  private static class Worker extends Thread {
    public Process process;
    public int exit;
    public StringBuffer result;
    private final String command;
    private OutputStream stdin = null;
    private InputStream stderr = null;
    private InputStream stdout = null;

    /**
     * Constructor
     */
    private Worker(String command) {
      this.command = command;
      this.result = new StringBuffer();
      this.exit = -1;
    }

    /**
     * main method - run
     */
    public void run() {
      try {
          process = Runtime.getRuntime().exec(command);

          stdin = process.getOutputStream ();
          stderr = process.getErrorStream ();
          stdout = process.getInputStream ();

          BufferedReader brCleanUp =
                         new BufferedReader (
                             new InputStreamReader (stdout,ENCODING));
          String line;
          while ((line = brCleanUp.readLine ()) != null) {
            result.append(line).append("\n");
          }
          brCleanUp.close();

          brCleanUp =
            new BufferedReader (new InputStreamReader (stderr,ENCODING));
          while ((line = brCleanUp.readLine ()) != null) {
            result.append("STDERR:\t").append(line).append("\n");
          }
          brCleanUp.close();
          exit = process.waitFor();
      } catch (InterruptedException e) {
        exit = -1;
        result.append("InterruptedException:").append(e.getMessage());
        return;
      } catch (java.io.IOException e) {
        exit = 0;
        result.append("IOException:").append(e.getMessage());
        return;
      } catch (Exception e) {
        exit = 0;
        result.append("Exception:").append(e.getMessage());
        return;
      }
    }
  }
}
/
