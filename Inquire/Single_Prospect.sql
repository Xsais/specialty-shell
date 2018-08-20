/*
 *
 * File: Single_Prospect.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to prompt the user for a prospective customers name and then executes the single prospect report procedure to dispaly the report on the screen
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a customer name
ACCEPT p_customerName PROMPT 'Enter a Prospective Customers Name: '

-- Pass the customer name to the correct stored procedure
exec singleProspectReport('&p_customerName');

-- Exit the application section
EXIT;