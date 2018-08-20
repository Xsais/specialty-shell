/*
 *
 * File: Vehicle_Inventory_Record.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to prompt the user for a serial numberand then executes the vehicle inventory report procedure to dispaly the report on the screen
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a service invoice number
ACCEPT p_serialNumber PROMPT 'Enter a Car Serial Number: '

-- Call the correct procedure and pass in the serial number
exec vehicleInventoryRecordReport('&p_serialNumber');

-- Exit the application section
EXIT;