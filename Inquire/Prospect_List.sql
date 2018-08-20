/*
 *
 * File: Prospect_List.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to executes the prospect list report procedure to dispaly the report on the screen
 *
 */

 -- Set Serveroutput and format and then console linesize

SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Call the correct procedure and pass in the customers name
exec prospectListReport();

-- Exit the application section
EXIT;