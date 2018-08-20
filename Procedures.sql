/*
 *
 * File: Procedures.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to list all of the used project procedures
 *
 */

/*
 *
 * Procedure to Handle Customer Inquire Reporting
 *
 */
-- Create the customerInquiryReport procedure
CREATE OR REPLACE PROCEDURE customerInquiryReport (
	pl_customerName customer.cname%TYPE
)
AS
	-- Declare needed variables
	-- Create needed variables to hold the row from the table
	v_customer customer%ROWTYPE;

	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Customer Name
	IF (LENGTH(TRIM(pl_customerName)) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- See if the customer is in the database
	SELECT *
	  INTO v_customer
	  FROM customer
	 WHERE UPPER(TRIM(cname)) = TRIM(UPPER(pl_customerName));

	-- Display the customer information
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 131, '-'));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING(TRIM(v_customer.cname) || ' - Customer Information', 131));
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 131, '-'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Address: ', 10) || RPAD((TRIM(v_customer.cstreet) || ', ' || TRIM(v_customer.ccity) || ', ' || TRIM(v_customer.cprov) || ' ' || TRIM(v_customer.cpostal)), 121, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Home: ', 10) || RPAD(TRIM(v_customer.chphone), 121, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Work: ', 10) || RPAD(TRIM(v_customer.cbphone), 121, '_'));

-- Handle Exception
EXCEPTION
	-- Handle when no data is found
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Oops... That looks to be an invalid Customer Name as it cannot be found in the database.  Please try again.');

	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Customer Name to view the Customer Inquiry Information.  Please try again.');
END;
/




/*
 *
 * Procedure to Handle Prospect List Reporting
 *
 */
-- Create the prospectListReport procedure
CREATE OR REPLACE PROCEDURE prospectListReport
AS
	-- Declare needed variables & cursor
	-- Create needed variables to hold rows from tables and count of items
	v_prospectCName prospect.cname%TYPE;
	v_prospectMake prospect.make%TYPE;
	v_prospectModel prospect.model%TYPE;
	v_prospectCYear prospect.cyear%TYPE;
	v_prospectColor prospect.color%TYPE;
	v_prospectTrim prospect.trim%TYPE;
	v_prospectOption options%ROWTYPE;
	v_prospectCount NUMBER;
	v_optionsCount NUMBER;
	v_options VARCHAR(255) := '';

	-- Cursor to store the prospect entries in the DB
	CURSOR c_prospectiveCustomers IS
		SELECT *
		  FROM prospectCustomerCars;

	-- Cursor to store the order options for the prospective entries
	CURSOR c_prospectCustomersOptions IS
		SELECT o.*
		  FROM prospect p
		 INNER JOIN options o
			ON p.ocode = o.ocode
		 WHERE TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
		   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
		   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
		   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
		   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));
BEGIN
	-- Get and store the number of prospect entries based on the prompted name
	SELECT COUNT(*)
	  INTO v_prospectCount
	  FROM prospectCustomerCars
	 WHERE TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
		   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
		   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
		   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
		   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));

	-- Display Report Title & Headdings
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Prospect List', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(RPAD('Name', 20) || ' ' || RPAD('Want', 110));
	DBMS_OUTPUT.PUT_LINE(RPAD('-', 20, '-') || ' ' || RPAD('-', 110, '-'));

	-- Open the prospectList cursor
	OPEN c_prospectiveCustomers;
		-- Loop through the results of the cursor and then display it to the console
		LOOP
			-- Fetch the results from the cursor into the prospect object variable
			FETCH c_prospectiveCustomers INTO v_prospectCName, v_prospectMake, v_prospectModel, v_prospectCYear, v_prospectColor, v_prospectTrim;

			-- Exit the loop when there is nothing found in the cursor
			EXIT WHEN c_prospectiveCustomers%NOTFOUND;

			-- Get the count of options
			SELECT COUNT(ocode)
			  INTO v_optionsCount
			  FROM prospect
			 WHERE TRIM(UPPER(cname)) = TRIM(UPPER(v_prospectCName))
			   AND TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
			   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
			   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
			   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
			   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));

			-- Check if the prospect has any car options
			IF (v_optionsCount > 0) THEN
				-- Initialize options list variable
				v_options := 'w/ ';

				-- Open the c_prospectCustomersOptions cursor
				OPEN c_prospectCustomersOptions;
					-- Loop through the results of the cursor and then display it to the console
					LOOP
						-- Fetch the results from the cursor into the prospect object variable
						FETCH c_prospectCustomersOptions INTO v_prospectOption;

						-- Exit the loop when there is nothing found in the cursor
						EXIT WHEN c_prospectCustomersOptions%NOTFOUND;

						-- Display options
						v_options := v_options || TRIM(v_prospectOption.odesc) || '(' || TRIM(v_prospectOption.ocode) || ')';
					-- End the loop
					END LOOP;
				-- Close the prospect List cursor
				CLOSE c_prospectCustomersOptions;
			END IF;

			-- Display prospective car information
			DBMS_OUTPUT.PUT_LINE(RPAD(v_prospectCName, 20) || RPAD(regexp_replace(' ' || (TRIM(v_prospectCYear) || ' ' || TRIM(v_prospectColor)|| ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectModel) || ' ' || TRIM(v_prospectTrim) || ' ' || v_options), ' +', ' '), 110));
		END LOOP;

	-- Close the prospect List cursor
	CLOSE c_prospectiveCustomers;
END;
/




/*
 *
 * Procedure to handle Sales Invoice Reporting
 *
 */
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




/*
 *
 * Procedure to handle Service Work Order Reporting
 *
 */
/*
 *
 * File: Service_Work_Order.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to create the procedure that handles viewing the service work order report
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Create the serviceWorkOrderReport procedure
CREATE OR REPLACE PROCEDURE serviceWorkOrderReport (
	pl_serviceInvoiceNumber servwork.servinv%TYPE
)
AS
	-- Declare needed variables & cursor
	-- Create the needed report variables
	v_serviceInvoiceNo servinv.servinv%TYPE;
	v_serviceDate servinv.serdate%TYPE;
	v_customerName customer.cname%type;
	v_customerAddress customer.cstreet%TYPE;
	v_customerCity customer.ccity%TYPE;
	v_customerPostalCode customer.cpostal%TYPE;
	v_customerWorkPhone customer.cbphone%TYPE;
	v_customerHomePhone customer.chphone%TYPE;
	v_carSerial car.serial%TYPE;
	v_carMake car.make%TYPE;
	v_carModel car.model%TYPE;
	v_carYear car.cyear%TYPE;
	v_carColor car.color%TYPE;
	v_servinvPartsCost servinv.partscost%TYPE;
	v_servinvLabourCost servinv.labourcost%TYPE;
	v_servinvTax servinv.tax%TYPE;
	v_workDesc servwork.workdesc%TYPE;
	v_workDescList VARCHAR2(500);
	v_workDescCounter NUMBER := 1;

	-- Cursor to store the work descriptions entries in the DB
	CURSOR c_serviceWorkDesc IS
		SELECT workdesc
		  FROM servwork
		 WHERE TRIM(UPPER(servinv)) = TRIM(UPPER(pl_serviceInvoiceNumber));

	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Service Invoice Number
	IF (LENGTH(TRIM(pl_serviceInvoiceNumber)) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- Perform a SELECT on the data for the report (minus the work descriptions)
	SELECT servinv, serdate, cname, cstreet, ccity, cpostal, cbphone, chphone, serial, make, model, cyear, color, partscost, labourcost, tax
	  INTO v_serviceInvoiceNo, v_serviceDate, v_customerName, v_customerAddress, v_customerCity, v_customerPostalCode, v_customerWorkPhone, v_customerHomePhone, v_carSerial, v_carMake, v_carModel, v_carYear, v_carColor, v_servinvPartsCost, v_servinvLabourCost, v_servinvTax
	  FROM serviceWork
	 WHERE TRIM(UPPER(servinv)) = TRIM(UPPER(pl_serviceInvoiceNumber));

	-- Open the c_serviceWorkDesc cursor
	OPEN c_serviceWorkDesc;
		-- Loop through the results of the cursor and then add it to the workDescList
		LOOP
			-- Fetch the results from the cursor into the desc object variable
			FETCH c_serviceWorkDesc INTO v_workDesc;
				-- Exit the loop when there is nothing found in the cursor
				EXIT WHEN c_serviceWorkDesc%NOTFOUND;

				-- Check if there is more than one row in the cursor
				IF(c_serviceWorkDesc%ROWCOUNT > 1) THEN
					-- Check if the counter is more than 1
					IF(v_workDescCounter > 1) THEN
						-- Append the iterated item to the list
						v_workDescList := v_workDescList || ', ' || TRIM(v_workDesc);

						-- Increment the counter
						v_workDescCounter := (v_workDescCounter + 1);
					ELSE
						-- Add the iterated item to the list
						v_workDescList := TRIM(v_workDesc);

						-- Increment the counter
						v_workDescCounter := (v_workDescCounter + 1);
					END IF;
				ELSE
					-- Add the iterated item to the list
					v_workDescList := TRIM(v_workDesc);

					-- Increment the counter
					v_workDescCounter := (v_workDescCounter + 1);
				END IF;
		-- End the loop
		END LOOP;
	-- Close the work desc List cursor
	CLOSE c_serviceWorkDesc;

	-- Format the display of the output to display like report
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('SPECALITY IMPORTS', 132));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('SERVICE WORK ORDER', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Service Invoice No: ', 20) || RPAD(TRIM(v_serviceInvoiceNo), 55, '_') || LPAD('Date: ', 10) || RPAD(TRIM(v_serviceDate), 46, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Service For: Name: ', 20) || RPAD(TRIM(v_customerName), 111, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Address: ', 20) || RPAD(TRIM(v_customerAddress), 111, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD(' ', 20) || RPAD('_', 111, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('City: ', 20) || RPAD(TRIM(v_customerCity), 55, '_') || LPAD('Postal Code: ', 16) || RPAD(TRIM(v_customerPostalCode), 40, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Telephone Work: ', 20) || RPAD(v_customerWorkPhone, 52, '_') || LPAD('Home: ', 8) || RPAD(TRIM(v_customerHomePhone), 51, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 20, '-') || RPAD('+', 20, '-') || RPAD('+', 30, '-') || RPAD('+', 20, '-') || RPAD('+', 40, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Serial Number', 20) || RPAD('| Make', 20) || RPAD('| Model', 30) || RPAD('| Year', 20) || RPAD('| Color', 40) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 20, '-') || RPAD('+', 20, '-') || RPAD('+', 30, '-') || RPAD('+', 20, '-') || RPAD('+', 40, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carSerial), 20) || RPAD('| ' || TRIM(v_carMake), 20) || RPAD('| ' || TRIM(v_carModel), 30) || RPAD('| ' || TRIM(v_carYear), 20) || RPAD('| ' || TRIM(v_carColor), 40) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 20, '-') || RPAD('+', 20, '-') || RPAD('+', 30, '-') || RPAD('+', 20, '-') || RPAD('+', 40, '-') || '+');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Work to be Done: ', 20) || RPAD(v_workDescList, 904, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('Costs:');
	DBMS_OUTPUT.PUT_LINE(LPAD('Parts: ', 11) || RPAD(TRIM(TO_CHAR(TRIM(v_servinvPartsCost), '$99,999.99')), 30, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Labor: ', 11) || RPAD(TRIM(TO_CHAR(TRIM(v_servinvLabourCost), '$99,999.99')), 30, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Tax: ', 11) || RPAD(TRIM(TO_CHAR(TRIM(v_servinvTax), '$99,999.99')), 30, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Total: ', 11) || RPAD(TRIM(TO_CHAR(TRIM((v_servinvPartsCost + v_servinvLabourCost + v_servinvTax)), '$99,999.99')), 30, '_'));

-- Handle Exception
EXCEPTION
	-- Handle when no data is found
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Oops... That looks to be an invalid Service Invoice Number as it cannot be found in the database.  Please try again.');

	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Service Invoice Number to view the Service Work Order.  Please try again.');
END;
/




/*
 *
 * Procedure to handle Single Prospect Reporting
 *
 */
/*
 *
 * File: Single_Prospect_Procedure.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 7, 2018
 * Task: File is used to create the procedure that handles viewing a single prospective customer report
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Create the singleProspectReport procedure
CREATE OR REPLACE PROCEDURE singleProspectReport (
	pl_customerName customer.cname%TYPE
)
AS
	-- Declare needed variables & cursor
	-- Create needed variables to hold rows from tables and count of items
	v_prospectCName prospect.cname%TYPE;
	v_prospectMake prospect.make%TYPE;
	v_prospectModel prospect.model%TYPE;
	v_prospectCYear prospect.cyear%TYPE;
	v_prospectColor prospect.color%TYPE;
	v_prospectTrim prospect.trim%TYPE;
	v_prospectOption options%ROWTYPE;
	v_prospectCount NUMBER;
	v_optionsCount NUMBER;

	-- Cursor to store the order options for the prospective entries
	CURSOR c_prospectCustomersOptions IS
		SELECT o.*
		  FROM prospect p
		 INNER JOIN options o
			ON p.ocode = o.ocode
		 WHERE TRIM(UPPER(p.cname)) = TRIM(UPPER(pl_customerName))
		   AND TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
		   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
		   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
		   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
		   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));

	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Customer Name
	IF (LENGTH(TRIM(pl_customerName)) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- Select the Needed Data from the view
	SELECT *
	  INTO v_prospectCName, v_prospectMake, v_prospectModel, v_prospectCYear, v_prospectColor, v_prospectTrim
	  FROM prospectCustomerCars
	 WHERE TRIM(UPPER(cname)) = TRIM(UPPER(pl_customerName));

	-- Get and store the number of prospect entries based on the prompted name
	SELECT COUNT(*)
	  INTO v_prospectCount
	  FROM prospectCustomerCars
	 WHERE TRIM(UPPER(cname)) = TRIM(UPPER(pl_customerName));

	-- Format the display of the output to display like report
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 65, '-'));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Perspective Customer Information', 66));
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 65, '-'));

	-- Display the Prospective Customers Name
	DBMS_OUTPUT.PUT_LINE('Prospect Name: ' || TRIM(UPPER(pl_customerName)));

	-- Get the count of options
	SELECT COUNT(ocode)
	  INTO v_optionsCount
	  FROM prospect
	 WHERE TRIM(UPPER(cname)) = TRIM(UPPER(pl_customerName))
	   AND TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
	   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
	   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
	   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
	   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));

	-- Display prospective car information
	DBMS_OUTPUT.PUT_LINE('Prospective Car: ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectModel) || ' (' || TRIM(v_prospectCYear) || ') ' || TRIM(v_prospectColor) || ' ' || TRIM(v_prospectTrim));

	-- Display section headding
	DBMS_OUTPUT.PUT_LINE('Options: ');

	-- Check if the prospect has any car options
	IF (v_optionsCount > 0) THEN
		-- Open the c_prospectCustomersOptions cursor
		OPEN c_prospectCustomersOptions;
			-- Loop through the results of the cursor and then display it to the console
			LOOP
				-- Fetch the results from the cursor into the prospect object variable
				FETCH c_prospectCustomersOptions INTO v_prospectOption;

				-- Exit the loop when there is nothing found in the cursor
				EXIT WHEN c_prospectCustomersOptions%NOTFOUND;

				-- Display options
				DBMS_OUTPUT.PUT_LINE(CHR(9) || '- ' || TRIM(v_prospectOption.odesc));
			-- End the loop
			END LOOP;

			-- Formatting extra line
			DBMS_OUTPUT.PUT_LINE('');
		-- Close the prospect List cursor
		CLOSE c_prospectCustomersOptions;
	ELSE
		-- Displae no options mesage
		DBMS_OUTPUT.PUT_LINE(CHR(9) || '- No Options');

		-- Formatting extra line
		DBMS_OUTPUT.PUT_LINE('');
	END IF;

-- Handle Exception
EXCEPTION
	-- Handle when no data is found
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Oops... That looks to be an invalid Customer Name as it cannot be found in the database.  Please try again.');

	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Customer Name to view the Customer Prospect List.  Please try again.');
END;
/




/*
 *
 * Procedure to handle Vehicle Inventory Record Reporting
 *
 */
/*
 *
 * File: Vehicle_Inventory_Report_Proceture.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to create the procedure that handles viewing the vehicle inventory report
 *
 */

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Create the vehicleInventoryRecordReport procedure
CREATE OR REPLACE PROCEDURE vehicleInventoryRecordReport (
	pl_serialNumber car.serial%TYPE
)
AS
	-- Declare needed variables & cursor
	-- Create the needed report variables
	v_carSerial car.serial%TYPE;
	v_carMake car.make%TYPE;
	v_carModel car.model%TYPE;
	v_carYear car.cyear%TYPE;
	v_carColor car.color%TYPE;
	v_carTrim car.trim%TYPE;
	v_carPurchasedFrom car.purchfrom%TYPE;
	v_carPurchInvNo car.purchinv%TYPE;
	v_carPurchaseDate car.purchdate%TYPE;
	v_carPurchaseCost car.purchcost%TYPE;
	v_carListPrice car.listprice%TYPE;
	v_carOption options%ROWTYPE;

	-- Cursor to store the base options entries in the DB
	CURSOR c_baseOptions IS
		SELECT op.*
		  FROM baseoption bo
		 INNER JOIN options op
			ON bo.ocode = op.ocode
		 WHERE TRIM(UPPER(bo.serial)) = TRIM(UPPER(pl_serialNumber));

	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Serial Number
	IF (LENGTH(TRIM(pl_serialNumber)) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- Perform a SELECT on the data for the report (minus the work descriptions)
	SELECT ca.serial, ca.make, ca.model, ca.cyear, ca.color, ca.trim, ca.purchfrom, ca.purchinv, ca.purchdate, ca.purchcost, ca.listprice
	  INTO v_carSerial, v_carMake, v_carModel, v_carYear, v_carColor, v_carTrim, v_carPurchasedFrom, v_carPurchInvNo, v_carPurchaseDate, v_carPurchaseCost, v_carListPrice
	  FROM car ca
	 WHERE TRIM(UPPER(ca.serial)) = TRIM(UPPER(pl_serialNumber));

	-- Format the display of the output to display like report
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Vehicle Inventory Record', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Serial No.', 24) || RPAD('| Make', 24) || RPAD('| Model', 24) || RPAD('| Year', 10) || RPAD('| Exterior Color', 24) || RPAD('| Trim', 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carSerial), 24) || RPAD('| ' || TRIM(v_carMake), 24) || RPAD('| ' || TRIM(v_carModel), 24) || RPAD('| ' || TRIM(v_carYear), 10) || RPAD('| ' || TRIM(v_carColor), 24) || RPAD('| ' || TRIM(v_carTrim), 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Purchased From', 24) || RPAD('| Purch. Inv. No.', 24) || RPAD('| Purchase Date', 24) || RPAD('|', 10) || RPAD('| Purchase Cost', 24) || RPAD('| List Base Price', 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, ' ') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carPurchasedFrom), 24) || RPAD('| ' || TRIM(v_carPurchInvNo), 24) || RPAD('| ' || TRIM(v_carPurchaseDate), 24) || RPAD('|', 10) || RPAD('| ' || TRIM(TO_CHAR(TRIM(v_carPurchaseCost), '$99,999.99')), 24) || RPAD('| ' || TRIM(TO_CHAR(TRIM(v_carListPrice), '$99,999.99')), 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, ' ') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Optional Equiptment and Accessories - Factory', 132));
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 82, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Code', 24) || RPAD('| Description', 82) || RPAD('| List Price', 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 82, '-') || RPAD('+', 24, '-') || '+');

	-- Open the c_baseOptions cursor
	OPEN c_baseOptions;
		-- Loop through the results of the cursor and then display it to the console
		LOOP
			-- Fetch the results from the cursor into the option object variable
			FETCH c_baseOptions INTO v_carOption;
				-- Exit the loop when there is nothing found in the cursor
				EXIT WHEN c_baseOptions%NOTFOUND;

				-- Display the data to the console
				DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carOption.ocode), 24) || RPAD('| ' || TRIM(v_carOption.odesc), 82) || RPAD('| ' || TRIM(TO_CHAR(TRIM(v_carOption.olist), '$99,999.99')), 24) || '|');
				DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 82, '-') || RPAD('+', 24, '-') || '+');
		-- End the loop
		END LOOP;
	-- Close the car options cursor
	CLOSE c_baseOptions;

-- Handle Exception
EXCEPTION
	-- Handle when no data is found
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Oops... That looks to be an invalid Car Serial Number as it cannot be found in the database.  Please try again.');

	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Car Serial Number to view the Vehicle Inventory Record.  Please try again.');
END;
/




/*
 *
 * Procedure to handle adding a new customer to the database
 *
 */
CREATE OR REPLACE PROCEDURE NEW_CUSTOMER (

  	errorcode  OUT SMALLINT,
	cname  customer.cname%TYPE,
	street customer.cstreet%TYPE,
	city   customer.ccity%TYPE,
	prov   customer.cprov%TYPE,
	postal customer.cpostal%TYPE  DEFAULT NULL,
	hphone customer.chphone%TYPE  DEFAULT NULL,
	bphone customer.cbphone%TYPE  DEFAULT NULL
)
AS

  v_count SMALLINT;
BEGIN

 	IF cname IS NULL
	  THEN

	  	errorcode := -6;
		RETURN;
	END IF;

  IF street IS NULL
  THEN

	errorcode := -7;
	RETURN;
  END IF;

  IF city IS NULL
  THEN

	errorcode := -8;
	RETURN;
  END IF;

  IF prov IS NULL
  THEN

	errorcode := -9;
	RETURN;
  END IF;


  IF postal IS NOT NULL AND NOT REGEXP_LIKE(LOWER(postal), '[a-z]\d[a-z][ \-]?\d[a-z]\d')
        THEN

            errorcode := -3;
		  RETURN;
    END IF;

    IF hphone IS NOT NULL AND NOT hphone IS NOT NULL AND REGEXP_LIKE(hphone, '\(\d{3}\)\d{3}-\d{4}')
        THEN

            errorcode := -4;
		  RETURN;
    END IF;

    IF bphone IS NOT NULL AND NOT bphone IS NOT NULL AND REGEXP_LIKE(bphone, '\(\d{3}\)\d{3}-\d{4}')
        THEN

            errorcode := -5;
		  RETURN;
    END IF;

    INSERT INTO customer
    	(
    	   cname,
    	   cstreet,
    	   ccity,
    	   cprov,
    	   cpostal,
    	   chphone,
    	   cbphone
    	)
    VALUES (
       cname,
       street,
       city,
       prov,
       postal,
       hphone,
       bphone
     );

    errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
             errorcode := -2;

    WHEN OTHERS THEN
             errorcode := -1;
END;
/

/** OUTPUT:
 * Function NEW_CUSTOMER compiled
 *
 **/
 
 
 
 
/*
 *
 * Procedure to handle adding a new prospect to the database
 *
 */
CREATE OR REPLACE PROCEDURE NEW_PROSPECT
(
    errorcode  OUT SMALLINT,
    ccname prospect.cname%TYPE,
    make  prospect.make%TYPE,
    model prospect.model%TYPE DEFAULT NULL,
    cyear prospect.cyear%TYPE DEFAULT NULL,
    color prospect.color%TYPE DEFAULT NULL,
    trim  prospect.trim%TYPE  DEFAULT NULL,
    ocode prospect.ocode%TYPE DEFAULT NULL
)
AS

    v_count SMALLINT;
BEGIN

    SELECT COUNT(*)
        INTO v_count
        FROM customer c
        WHERE UPPER(c.cname) = UPPER(ccname);

  IF v_count = 0
	THEN

		errorcode := -3;
	  RETURN;
  END IF;

    IF UPPER(RTRIM(make)) NOT IN('ACURA', 'LAND ROVER', 'MERCEDES', 'JAGUAR')
      THEN

        errorcode := -4;
		RETURN;
    END IF;

    SELECT COUNT(*)
        INTO v_count
        FROM options o
        WHERE o.ocode = ocode;

    IF v_count = 0
        THEN

            errorcode := -5;
	  		RETURN;
    END IF;

  INSERT INTO prospect p (
       p.cname,
       p.make,
       p.model,
       p.cyear,
       p.color,
       p.trim,
       p.ocode
   )
  VALUES (
	 ccname,
     make,
     model,
     cyear,
     color,
     trim,
     ocode
  );

  errorcode := 0;
EXCEPTION

    WHEN OTHERS
        THEN

            errorcode := -1;
END;
/

/** OUTPUT:
 * Function NEW_PROSPECT compiled
 *
 **/

 
 
 
/*
 *
 * Procedure to handle adding a new sale to the database
 *
 */
CREATE OR REPLACE PROCEDURE NEW_SALE
(
	errorcode OUT SMALLINT,
    saleinv     saleinv.saleinv%TYPE,
    ccname      saleinv.cname%TYPE,
    csalesman    saleinv.salesman%TYPE,
    csaledate    CHAR,
    cserial      saleinv.serial%TYPE,
    totalprice  saleinv.totalprice%TYPE  DEFAULT NULL,
    discount    saleinv.discount%TYPE    DEFAULT NULL,
    licfee      saleinv.licfee%TYPE      DEFAULT NULL,
    commission  saleinv.commission%TYPE  DEFAULT NULL,
    ctradeserial saleinv.tradeserial%TYPE DEFAULT NULL,
    tradeallow  saleinv.tradeallow%TYPE  DEFAULT NULL,
	fire        saleinv.fire%TYPE        DEFAULT 'N',
	collision   saleinv.collision%TYPE   DEFAULT 'N',
	liability   saleinv.liability%TYPE   DEFAULT 'N',
	property    saleinv.property%TYPE    DEFAULT 'N'
)
AS

    v_count NUMBER;
  	v_serdate DATE := TO_DATE(csaledate, 'YYYY-MM-DD');
BEGIN

  IF saleinv IS NULL
  THEN

	errorcode := -21;
	RETURN;
  END IF;

  IF ccname IS NULL
  THEN

	errorcode := -22;
	RETURN;
  END IF;

  IF csalesman IS NULL
  THEN

	errorcode := -23;
	RETURN;
  END IF;

  IF csaledate IS NULL
  THEN

	errorcode := -24;
	RETURN;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = cserial
	AND c.cname IS NULL;

  IF cserial IS NULL OR v_count = 0
  THEN

	errorcode := -12;
	RETURN;
  END IF;

  IF totalprice IS NOT NULL AND totalprice < 0
    THEN

        errorcode := -3;
	  RETURN;
    END IF;

   IF discount IS NOT NULL AND discount < 0
    THEN

        errorcode := -4;
	  RETURN;
    END IF;

   IF licfee IS NOT NULL AND licfee < 0
    THEN

        errorcode := -5;
	  RETURN;
    END IF;

   IF commission IS NOT NULL AND commission < 0
    THEN

        errorcode := -6;
	  RETURN;
    END IF;

   IF tradeallow IS NOT NULL AND tradeallow < 0
    THEN

        errorcode := -7;
	  RETURN;
    END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM customer c
  WHERE c.cname = ccname;

  IF v_count = 0
  THEN

	errorcode := -13;
	RETURN;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM employee e
  WHERE e.empname = csalesman;

  IF v_count = 0
  THEN

	errorcode := -14;
	RETURN;
  END IF;

  IF v_serdate > SYSDATE OR csaledate < '1885/01/01'
  THEN

	errorcode := -15;
	RETURN;
  END IF;

  IF ctradeserial IS NOT NULL
	THEN
  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = ctradeserial;

  IF v_count = 0
  THEN

	errorcode := -16;
	RETURN;
  END IF;
	  END IF;

  IF fire IS NOT NULL AND UPPER(fire) NOT IN ('Y', 'N')
  THEN

	errorcode := -17;
	RETURN;
  END IF;

  IF collision IS NOT NULL AND UPPER(collision) NOT IN ('Y', 'N')
  THEN

	errorcode := -18;
	RETURN;
  END IF;

  IF liability IS NOT NULL AND UPPER(liability) NOT IN ('Y', 'N')
  THEN

	errorcode := -19;
	RETURN;
  END IF;

  IF property IS NOT NULL AND UPPER(property) NOT IN ('Y', 'N')
  THEN

	errorcode := -20;
	RETURN;
  END IF;

   INSERT INTO saleinv s (
  	     s.saleinv,
  	     s.cname,
  	     s.salesman,
  	     s.saledate,
  	     s.serial,
  	     s.totalprice,
  	     s.discount,
  	     s.net,
  	     s.tax,
  	     s.licfee,
  	     s.commission,
  	     s.tradeserial,
  	     s.tradeallow,
  	     s.fire,
  	     s.collision,
  	     s.liability,
  	     s.property
  	 )
  	VALUES (
  	  saleinv,
  	  ccname,
  	  csalesman,
	  v_serdate,
	  cserial,
  	  totalprice,
  	  discount,
  	  totalprice - discount,
      0.13 * (totalprice - discount),
  	  licfee,
  	  commission,
  	  ctradeserial,
  	  tradeallow,
  	  fire,
  	  collision,
  	  liability,
  	  property
  	);

    UPDATE car c
        SET c.cname = ccname
        WHERE c.serial = serial;

  errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

         errorcode := -2;
     WHEN OTHERS THEN

    	 errorcode := -1;
END;
/
/** OUTPUT:
 * Function NEW_SALE compiled
 *
 **/

 
 
 
 
/*
 *
 * Procedure to handle adding a new service to the database
 *
 */
 CREATE OR REPLACE PROCEDURE NEW_SERVICE
(
    errorcode OUT SMALLINT,
    servinv   servinv.servinv%TYPE,
    serdate   CHAR,
    ccname     servinv.cname%TYPE,
    cserial    servinv.serial%TYPE,
    workdesc  servwork.workdesc%TYPE,
    partscost servinv.partscost%TYPE DEFAULT 0,
    labourcost servinv.labourcost%TYPE DEFAULT 0
)
AS

  	v_serdate DATE := TO_DATE(serdate, 'YYYY-MM-DD');
  	v_count SMALLINT;
BEGIN

  SELECT COUNT(*)
	  INTO v_count
  	FROM customer c
  	WHERE UPPER(c.cname) = UPPER(ccname);

  IF v_count = 0
  THEN

	errorcode := -5;
	RETURN;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE UPPER(c.serial) = UPPER(cserial);

  IF v_count = 0
  THEN

	errorcode := -6;
	RETURN;
  END IF;

  IF RTRIM(workdesc) = ''
  THEN

	errorcode := -7;
	RETURN;
  END IF;

  IF v_serdate > SYSDATE OR serdate < '1885/01/01'
	  THEN

		errorcode := -8;
		RETURN;
  END IF;

   IF partscost < 0
    THEN

        errorcode := -3;
	  RETURN;
    END IF;

   IF labourcost < 0
    THEN

        errorcode := -4;
	  RETURN;
    END IF;

    INSERT INTO servinv s (
	  s.servinv,
	  s.serdate,
	  s.cname,
	  s.serial,
	  s.partscost,
	  s.labourcost,
	  s.tax
    )
        VALUES (
		  servinv,
		  v_serdate,
		  ccname,
		  cserial,
		  partscost,
		  labourcost,
		  ((partscost + labourcost) * 0.13)
         );

    INSERT INTO servwork s (
	  s.servinv,
	  s.workdesc
    )
        VALUES (
		  servinv,
          workdesc
         );
        errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

         errorcode := -2;
END;
/

/** OUTPUT:
 * Function NEW_SERVICE compiled
 *
 **/

 
 
 
 
/*
 *
 * Procedure to handle adding a new vehicle to the database
 *
 */
CREATE OR REPLACE PROCEDURE NEW_VEHICLE
(
 	errorcode  OUT SMALLINT,
    serial     car.serial%TYPE,
    make       car.make%TYPE,
    model      car.model%TYPE,
    cyear      car.cyear%TYPE,
    color      car.color%TYPE,
    trim       car.trim%TYPE,
    enginetype car.enginetype%TYPE,
    ccname      car.cname%TYPE        DEFAULT NULL,
    purchinv   car.purchinv%TYPE     DEFAULT NULL,
    purchdate  car.purchdate%TYPE    DEFAULT NULL,
    purchfrom  car.purchfrom%TYPE    DEFAULT NULL,
    purchcost  car.purchcost%TYPE    DEFAULT 0,
    freightcost car.freightcost%TYPE DEFAULT 0,
    listprice  car.listprice%TYPE    DEFAULT 0
)
AS

  	v_count SMALLINT;
BEGIN

  IF serial IS NULL
	  THEN

		errorcode := -6;
		RETURN;
  END IF;

  IF make IS NULL
  THEN

	errorcode := -7;
	RETURN;
  END IF;

  IF make NOT IN('ACURA', 'LAND ROVER', 'MERCEDES', 'JAGUAR')
	  THEN

		errorcode := -13;
		RETURN;
  END IF;

  IF model IS NULL
  THEN

	errorcode := -8;
	RETURN;
  END IF;

  IF cyear IS NULL
  THEN

	errorcode := -9;
	RETURN;
  END IF;

  IF color IS NULL
  THEN

	errorcode := -10;
	RETURN;
  END IF;

  IF trim IS NULL
  THEN

	errorcode := -11;
	RETURN;
  END IF;

  IF enginetype IS NULL
  THEN

	errorcode := -12;
	RETURN;
  END IF;

IF ccname IS NOT NULL
  THEN
  SELECT COUNT(*)
	  INTO v_count
  FROM customer c
  WHERE UPPER(c.cname) = UPPER(ccname);

  IF v_count = 0
	THEN

		errorcode := -13;
	  RETURN;
  END IF;
	END IF;

  IF purchinv IS NOT NULL
	THEN

	  SELECT COUNT(*)
		  INTO v_count
	  FROM saleinv c
	  WHERE UPPER(c.saleinv) = UPPER(purchinv);

	  IF v_count = 0
	  THEN

		errorcode := -14;
		RETURN;
	  END IF;
  END IF;

  IF purchcost < 0
    THEN

        errorcode := -3;
	  RETURN;
    END IF;

   IF freightcost < 0
    THEN

        errorcode := -4;
	  RETURN;
    END IF;

   IF listprice < 0
    THEN

        errorcode := -5;
	  RETURN;
    END IF;

  INSERT INTO car c (
  		c.serial,
  		c.cname,
  		c.make,
  		c.model,
  		c.cyear,
  		c.color,
  		c.trim,
  		c.enginetype,
  		c.purchinv,
  		c.purchdate,
  		c.purchfrom,
  		c.purchcost,
  		c.freightcost,
  		c.totalcost,
  		c.listprice
  )
  VALUES (
            serial,
			ccname,
            make,
            model,
            cyear,
            color,
            trim,
            enginetype,
            purchinv,
            purchdate,
            purchfrom,
            purchcost,
            freightcost,
            purchcost + freightcost,
            listprice
  );
  errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
             errorcode := -2;

    WHEN OTHERS THEN
             errorcode := -1;
END;
/

/** OUTPUT:
 * Function NEW_VEHICLE compiled
 *
 **/
 
 
 
 
/*
 *
 * Procedure to delete a prospective customer from the database
 *
 */
/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: DELETE_PROSPECT.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Remove prospect from the database
*/

CREATE OR REPLACE PROCEDURE DELETE_PROSPECT
  (
  	v_errorCode OUT SMALLINT,
	ccname prospect.cname%TYPE
  )
AS
	v_count SMALLINT;
  BEGIN

	SELECT COUNT(*)
		INTO v_count
		FROM customer c
			WHERE UPPER(c.cname) = UPPER(ccname);

	IF v_count != 1
		THEN

		v_errorCode := -3;
		RETURN;
	END IF;

	SELECT COUNT(*)
		INTO v_count
		FROM prospect p
			WHERE UPPER(p.cname) = UPPER(ccname);

	IF v_count < 1
		THEN

		v_errorCode := -2;
		RETURN;
	END IF;

	DELETE FROM prospect p
		WHERE UPPER(p.cname) = UPPER(ccname);

v_errorCode := 0;
	EXCEPTION

		WHEN OTHERS
			THEN

				v_errorCode := -1;
  END;
/