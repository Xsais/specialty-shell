/*
 *
 * File: Sales_Inventory_Procedure.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to create the procedure that handles viewing the sales invoice report
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Create the salesInvoiceReport procedure
CREATE OR REPLACE PROCEDURE salesInvoiceReport (
	pl_salesInvoiceNumber saleinv.saleinv%TYPE
) 
AS
	-- Declare needed variables & cursor
	v_saleInvoiceNo saleinv.saleinv%TYPE;
	v_saleDate saleinv.saledate%TYPE;
	v_customerName customer.cname%TYPE;
	v_customerAddress customer.cstreet%TYPE;
	v_customerCity customer.ccity%TYPE;
	v_customerState customer.cprov%TYPE;
	v_customerPostalCode customer.cpostal%TYPE;
	v_customerTelephone customer.chphone%TYPE;
	v_saleSalesman saleinv.salesman%TYPE;
	v_carSerial car.serial%TYPE;
	v_carMake car.make%TYPE;
	v_carModel car.model%TYPE;
	v_carYear car.cyear%TYPE;
	v_carColor car.color%TYPE;
	v_saleFire saleinv.fire%TYPE;
	v_saleCollision saleinv.collision%TYPE;
	v_saleLiability saleinv.liability%TYPE;
	v_saleProperty saleinv.property%TYPE;
	v_saleOptionCode invoption.ocode%TYPE;
	v_saleOptionDesc options.odesc%TYPE;
	v_saleOptionPrice invoption.saleprice%TYPE;
	v_tradeSerial car.serial%TYPE;
	v_tradeMake car.make%TYPE;
	v_tradeModel car.model%TYPE;
	v_tradeYear car.cyear%TYPE;
	v_saleTotalPrice saleinv.totalprice%TYPE;
	v_saleTradeAllowance saleinv.tradeallow%TYPE;
	v_saleDiscount saleinv.discount%TYPE;
	v_saleNet saleinv.net%TYPE;
	v_saleTaxes saleinv.tax%TYPE;
	
	-- Cursor to store the options entries in the DB
	CURSOR c_saleInvOptions IS 
		SELECT ocode, odesc, saleprice
		  FROM saleInvOptions
		 WHERE TRIM(UPPER(saleinv)) = TRIM(UPPER(pl_salesInvoiceNumber));
		 --&p_saleInvNumber
		 
	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Service Invoice Number
	IF (LENGTH(TRIM(pl_salesInvoiceNumber)) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;
	
	-- Select the needed sales invoice information
	SELECT saleinv, saledate, cname, cstreet, ccity, cprov, cpostal, chphone, salesman, serial, make, model, cyear, color, fire, collision, liability, property, trse, trma, trmo, tryr, totalprice, tradeallow, discount, net, tax
	  INTO v_saleInvoiceNo, v_saleDate, v_customerName, v_customerAddress, v_customerCity, v_customerState, v_customerPostalCode, v_customerTelephone, v_saleSalesman, v_carSerial, v_carMake, v_carModel, v_carYear, v_carColor, v_saleFire, v_saleCollision, v_saleLiability, v_saleProperty, v_tradeSerial, v_tradeMake, v_tradeModel, v_tradeYear, v_saleTotalPrice, v_saleTradeAllowance, v_saleDiscount, v_saleNet, v_saleTaxes
	  FROM salesInvoice
	 WHERE TRIM(UPPER(saleinv)) = TRIM(UPPER(pl_salesInvoiceNumber));

	-- REFORMAT VARIABLES VALUES
	v_customerTelephone := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(v_customerTelephone), '(', ''), ')', ''), ' ', ''), '-', '');
	v_saleTradeAllowance := NVL(v_saleTradeAllowance, '0');

	-- Format the display of the output to display like report
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('SPECIALTY IMPORTS', 132));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('SALES INVOICE', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Invoice No. ', 12) || RPAD(TRIM(v_saleInvoiceNo), 50, '_') || LPAD('Date: ', 15) || RPAD(TRIM(v_saleDate), 54, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('SOLD TO: ', 12) || LPAD('Name: ', 10) || RPAD(TRIM(v_customerName), 109, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Address: ', 23) || RPAD(TRIM(v_customerAddress), 108, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD(' ', 23) || RPAD('_', 108, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('City: ', 23) || RPAD(TRIM(v_customerCity), 108, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('State: ', 23) || RPAD(TRIM(v_customerState), 108, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('City: ', 23) || RPAD(TRIM(v_customerCity), 57, '_') || LPAD('Postal Code: ', 15) || RPAD(TRIM(v_customerPostalCode), 36, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Telephone: ', 23) || RPAD('(' || SUBSTR(v_customerTelephone, 0, 3) || ') ' || SUBSTR(v_customerTelephone, 4, 3) || '-' || SUBSTR(v_customerTelephone, 7, 4), 108, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Salesman: ', 13) || RPAD(TRIM(v_saleSalesman), 118, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 20, '-') || RPAD('+', 20, '-') || RPAD('+', 30, '-') || RPAD('+', 20, '-') || RPAD('+', 40, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Serial Number', 20) || RPAD('| Make', 20) || RPAD('| Model', 30) || RPAD('| Year', 20) || RPAD('| Color', 40) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 20, '-') || RPAD('+', 20, '-') || RPAD('+', 30, '-') || RPAD('+', 20, '-') || RPAD('+', 40, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carSerial), 20) || RPAD('| ' || TRIM(v_carMake), 20) || RPAD('| ' || TRIM(v_carModel), 30) || RPAD('| ' || TRIM(v_carYear), 20) || RPAD('| ' || TRIM(v_carColor), 40) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 20, '-') || RPAD('+', 20, '-') || RPAD('+', 30, '-') || RPAD('+', 20, '-') || RPAD('+', 40, '-') || '+');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Insurance Coverage Includes', 132));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('---------------------------', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD(' ', 40) || RPAD('Fire ' || '&' || ' Theft', 16) || '[ ' || TRIM(v_saleFire) || ' ]' || LPAD(' ', 25) || RPAD('Liability ', 18) || '[ ' || TRIM(v_saleLiability) || ' ]');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD(' ', 40) || RPAD('Collision', 16) || '[ ' || TRIM(v_saleCollision) || ' ]' || LPAD(' ', 25) || RPAD('Property Damage ', 18) || '[ ' || TRIM(v_saleProperty) || ' ]');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Options', 132));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('-------', 132));
	DBMS_OUTPUT.PUT_LINE('');

	-- Display table header
	DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING(TRIM('Code'), 20), 20) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM('Description'), 78), 78) || LPAD(' ', 4) || RPAD(CENTERSTRING('Price', 24), 24));
	DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING(TRIM('----'), 20), 20) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM('-----------'), 78), 78) || LPAD(' ', 4) || RPAD(CENTERSTRING('-----', 24), 24));
	DBMS_OUTPUT.PUT_LINE('');

	-- Open the c_saleInvOptions cursor
	OPEN c_saleInvOptions;
		-- Loop through the results of the cursor and then display it to the console
		LOOP
			-- Fetch the results from the cursor into the option object variable
			FETCH c_saleInvOptions INTO v_saleOptionCode, v_saleOptionDesc, v_saleOptionPrice;
				-- CHECK if there are rows
				IF (c_saleInvOptions%ROWCOUNT > 0) THEN
					-- Display the data to the console
					DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING(TRIM(v_saleOptionCode), 20), 20) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_saleOptionDesc), 78), 78) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(TO_CHAR(TRIM(v_saleOptionPrice), '$99,999.99')), 24), 24));
					DBMS_OUTPUT.PUT_LINE(RPAD('-', 20, '-') || LPAD(' ', 4) || RPAD('-', 78, '-') || LPAD(' ', 4) || RPAD('-', 24, '-') || '-');
					
					-- Exit the loop when there is nothing found in the cursor
					EXIT WHEN c_saleInvOptions%NOTFOUND;
				ELSE
					-- Dispaly blank line
					DBMS_OUTPUT.PUT_LINE('');
					DBMS_OUTPUT.PUT_LINE(RPAD('-', 20, '-') || LPAD(' ', 4) || RPAD('-', 78, '-') || LPAD(' ', 4) || RPAD('-', 24, '-') || '-');
					
					-- Exit the loop when there is nothing found in the cursor
					EXIT WHEN c_saleInvOptions%NOTFOUND;
				END IF;
		-- End the loop
		END LOOP;
	-- Close the options cursor
	CLOSE c_saleInvOptions;
	
	-- Display more data
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('TRADE-IN', 132));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('--------', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING('Serial No.', 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING('Make', 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING('Model', 26), 26) || LPAD(' ', 4) || RPAD(CENTERSTRING('Year', 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING('Allowance', 41), 41));
	DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING('-------------', 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING('------', 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING('-------', 26), 26) || LPAD(' ', 4) || RPAD(CENTERSTRING('------', 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING('-----------', 41), 41));
	
	-- Check to see if a car was traded in
	IF (v_tradeSerial IS NOT NULL) THEN
		-- Check if the Trade allowance is 0
		IF (v_saleTradeAllowance = 0) THEN
			-- Display the trade Information with allowance as 0
			DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING(TRIM(v_tradeSerial), 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_tradeMake), 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_tradeModel), 26), 26) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_tradeYear), 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(TO_CHAR(TRIM(v_saleTradeAllowance), '$0.99')), 41), 41));
		ELSE
			-- Dispaly Trade Information
			DBMS_OUTPUT.PUT_LINE(RPAD(CENTERSTRING(TRIM(v_tradeSerial), 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_tradeMake), 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_tradeModel), 26), 26) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(v_tradeYear), 16), 16) || LPAD(' ', 4) || RPAD(CENTERSTRING(TRIM(TO_CHAR(TRIM(v_saleTradeAllowance), '$99,999.99')), 41), 41));
			DBMS_OUTPUT.PUT_LINE(RPAD('-', 16, '-') || LPAD(' ', 4) || RPAD('-', 16, '-') || LPAD(' ', 4) || RPAD('-', 26, '-') || LPAD(' ', 4) || RPAD('-', 16, '-') || LPAD(' ', 4) || RPAD('-', 41, '-'));
		END IF;
	ELSE
		-- Dispaly Blank Line
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE(RPAD('-', 16, '-') || LPAD(' ', 4) || RPAD('-', 16, '-') || LPAD(' ', 4) || RPAD('-', 26, '-') || LPAD(' ', 4) || RPAD('-', 16, '-') || LPAD(' ', 4) || RPAD('-', 41, '-'));
	END IF;
	
	-- Format footer of report
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('=', 131, '='));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Total Price: ', 23) || RPAD(TRIM(TO_CHAR(TRIM(v_saleTotalPrice), '$99,999.99')), 108, '_'));

	-- Check if the Trade allowance is 0
	IF (v_saleTradeAllowance = 0) THEN
		-- Display the trade allowance
		DBMS_OUTPUT.PUT_LINE(LPAD('Trade-In Allowance: ', 23) || RPAD(TRIM(TO_CHAR(TRIM(v_saleTradeAllowance), '$0.99')), 108, '_'));
	ELSE
		-- Display the trade allowance
		DBMS_OUTPUT.PUT_LINE(LPAD('Trade-In Allowance: ', 23) || RPAD(TRIM(TO_CHAR(TRIM(v_saleTradeAllowance), '$99,999.99')), 108, '_'));
	END IF;	
		
	-- Continue with report footer
	DBMS_OUTPUT.PUT_LINE(LPAD('Discount: ', 23) || RPAD(TRIM(TO_CHAR(TRIM(v_saleDiscount), '$99,999.99')), 108, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Net: ', 23) || RPAD(TRIM(TO_CHAR(TRIM(v_saleNet), '$99,999.99')), 108, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Taxes: ', 23) || RPAD(TRIM(TO_CHAR(TRIM(v_saleTaxes), '$99,999.99')), 108, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Total Payable: ', 23) || RPAD(TRIM(TO_CHAR(TRIM((TRIM(v_saleNet) + TRIM(v_saleTaxes))), '$99,999.99')), 108, '_'));
-- Handle Exception
EXCEPTION
	-- Handle when no data is found
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Oops... That looks to be an invalid Sales Invoice Number as it cannot be found in the database.  Please try again.');
	
	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Sales Invoice Number to view the Sales Invoice.  Please try again.');
END;
/