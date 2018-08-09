-- James Grau
-- August 7, 2018

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a customer name
ACCEPT p_customerName PROMPT 'Enter a Customers Name:'

-- Declare needed variable
DECLARE
	-- Create needed variables to hold the row from the table
	v_customer customer%ROWTYPE;
		 
	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Customer Name
	IF (LENGTH(TRIM('&p_customerName')) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;
	
	-- See if the customer is in the database
	SELECT *
	  INTO v_customer
	  FROM customer
	 WHERE UPPER(TRIM(cname)) = TRIM(UPPER('&p_customerName'));
	
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
