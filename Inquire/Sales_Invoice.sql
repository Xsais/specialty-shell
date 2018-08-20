/*
 *
 * File: Sales_Invoice.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to prompt the user for a sales invoice number and then executes the sales inventory report procedure to dispaly the report on the screen
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a service invoice number
ACCEPT p_salesInvoiceNumber PROMPT 'Enter a Sales Invoice Number: '

-- Call the correct procedure and pass in the sales invoice number
exec salesInvoiceReport('&p_salesInvoiceNumber');

-- Exit the application section
EXIT;