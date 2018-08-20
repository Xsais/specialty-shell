/*
 *
 * File: Service_Work_Order.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to prompt the user for a service invoice number and then executes the service work order report procedure procedure to dispaly the report on the screen
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a service invoice number
ACCEPT p_serviceInvoiceNumber PROMPT 'Enter a Service Invoice Number: '

-- Pass the service invoice number to the correct stored procedure
exec serviceWorkOrderReport('&p_serviceInvoiceNumber');

-- Exit the application section
EXIT;