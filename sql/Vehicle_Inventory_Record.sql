-- James Grau
-- August 9, 2018

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a service invoice number
ACCEPT p_serialNumber PROMPT 'Enter a Car Serial Number:'

-- Declare needed variables & cursor
DECLARE
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
		 WHERE TRIM(UPPER(bo.serial)) = TRIM(UPPER('&p_serialNumber'));
		 
	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Serial Number
	IF (LENGTH('&p_serialNumber') IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- Perform a SELECT on the data for the report (minus the work descriptions)
	SELECT ca.serial, ca.make, ca.model, ca.cyear, ca.color, ca.trim, ca.purchfrom, ca.purchinv, ca.purchdate, ca.purchcost, ca.listprice
	  INTO v_carSerial, v_carMake, v_carModel, v_carYear, v_carColor, v_carTrim, v_carPurchasedFrom, v_carPurchInvNo, v_carPurchaseDate, v_carPurchaseCost, v_carListPrice
	  FROM car ca
	 WHERE TRIM(UPPER(ca.serial)) = TRIM(UPPER('&p_serialNumber'));	

	-- Format the display of the output to display like report
	DBMS_OUTPUT.PUT(LPAD('-', 131, '-'));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Vehicle Inventory Record', 132));
	DBMS_OUTPUT.PUT_LINE('');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Serial No.', 24) || RPAD('| Make', 24) || RPAD('| Model', 24) || RPAD('| Year', 10) || RPAD('| Exterior Color', 24) || RPAD('| Trim', 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carSerial), 24) || RPAD('| ' || TRIM(v_carMake), 24) || RPAD('| ' || TRIM(v_carModel), 24) || RPAD('| ' || TRIM(v_carYear), 10) || RPAD('| ' || TRIM(v_carColor), 24) || RPAD('| ' || TRIM(v_carTrim), 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| Purchased From', 24) || RPAD('| Purch. Inv. No.', 24) || RPAD('| Purchase Date', 24) || RPAD('|', 10) || RPAD('| Purchase Cost', 24) || RPAD('| List Base Price', 24) || '|');
	DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || RPAD('+', 10, ' ') || RPAD('+', 24, '-') || RPAD('+', 24, '-') || '+');
	DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carPurchasedFrom), 24) || RPAD('| ' || TRIM(v_carPurchInvNo), 24) || RPAD('| ' || TRIM(v_carPurchaseDate), 24) || RPAD('|', 10) || RPAD('| ' || TO_CHAR(TRIM(v_carPurchaseCost), '$99,999.99'), 24) || RPAD('| ' || TO_CHAR(TRIM(v_carListPrice), '$99,999.99'), 24) || '|');
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
				DBMS_OUTPUT.PUT_LINE(RPAD('| ' || TRIM(v_carOption.ocode), 24) || RPAD('| ' || TRIM(v_carOption.odesc), 82) || RPAD('| ' || TO_CHAR(TRIM(v_carOption.olist), '$99,999.99'), 24) || '|');
				DBMS_OUTPUT.PUT_LINE(RPAD('+', 24, '-') || RPAD('+', 82, '-') || RPAD('+', 24, '-') || '+');
		-- End the loop
		END LOOP;
	-- Close the car options cursor
	CLOSE c_baseOptions;
	
-- Handle Exception
EXCEPTION
	-- Handle when e_no_data_entry thrown/raised
	WHEN e_no_data_entry THEN
		-- Display error message
		DBMS_OUTPUT.PUT_LINE('Oops... You must enter a Car Serial Number to view the Vehicle Inventory Record.  Please try again.');
END;
/
