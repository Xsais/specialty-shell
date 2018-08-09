-- James Grau
-- August 9, 2018

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132

-- Prompt the user for a service invoice number
ACCEPT p_serviceInvoiceNumber PROMPT 'Enter a Service Invoice Number:'

-- Declare needed variables & cursor
DECLARE
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
		 WHERE TRIM(UPPER(servinv)) = TRIM(UPPER('&p_serviceInvoiceNumber'));
		 
	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Service Invoice Number
	IF (LENGTH('&p_serviceInvoiceNumber') IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- Perform a SELECT on the data for the report (minus the work descriptions)
	SELECT si.servinv, si.serdate, cu.cname, cu.cstreet, cu.ccity, cu.cpostal, cu.cbphone, cu.chphone, ca.serial, ca.make, ca.model, ca.cyear, ca.color, si.partscost, si.labourcost, si.tax
	  INTO v_serviceInvoiceNo, v_serviceDate, v_customerName, v_customerAddress, v_customerCity, v_customerPostalCode, v_customerWorkPhone, v_customerHomePhone, v_carSerial, v_carMake, v_carModel, v_carYear, v_carColor, v_servinvPartsCost, v_servinvLabourCost, v_servinvTax
	  FROM servinv si
	 INNER JOIN customer cu
		ON si.cname = cu.cname
	 INNER JOIN car ca
		ON si.serial = ca.serial
	 WHERE TRIM(UPPER(si.servinv)) = TRIM(UPPER('&p_serviceInvoiceNumber'));
	 
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
	DBMS_OUTPUT.PUT('-----------------------------------------------------------------------------------------------------------------------------------');
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
	DBMS_OUTPUT.PUT_LINE('+---------------------------------------------------------------------------------------------------------------------------------+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Serial Number', 20) || RPAD('| Make', 20) || RPAD('| Model', 30) || RPAD('| Year', 20) || RPAD('| Color', 40) || '|');
	DBMS_OUTPUT.PUT_LINE('+---------------------------------------------------------------------------------------------------------------------------------+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carSerial), 20) || RPAD('| ' || TRIM(v_carMake), 20) || RPAD('| ' || TRIM(v_carModel), 30) || RPAD('| ' || TRIM(v_carYear), 20) || RPAD('| ' || TRIM(v_carColor), 40) || '|');
	DBMS_OUTPUT.PUT_LINE('+---------------------------------------------------------------------------------------------------------------------------------+');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(LPAD('Work to be Done: ', 20) || RPAD(v_workDescList, 904, '_'));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE('Costs:');
	DBMS_OUTPUT.PUT_LINE(LPAD('Parts: ', 11) || RPAD(TO_CHAR(TRIM(v_servinvPartsCost), '$99,999.99' ), 30, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Labor: ', 11) || RPAD(TO_CHAR(TRIM(v_servinvLabourCost), '$99,999.99' ), 30, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Tax: ', 11) || RPAD(TO_CHAR(TRIM(v_servinvTax), '$99,999.99' ), 30, '_'));
	DBMS_OUTPUT.PUT_LINE(LPAD('Total: ', 11) || RPAD(TO_CHAR(TRIM((v_servinvPartsCost + v_servinvLabourCost + v_servinvTax)), '$99,999.99' ), 30, '_'));

-- Handle Exception
EXCEPTION
	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Service Invoice Number to view the information.  Please try again.');
END;
/
