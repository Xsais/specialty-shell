-- James Grau
-- August 7, 2018

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Prompt the user for a customer name
ACCEPT p_customerName PROMPT 'Enter a Prospective Customers Name: '

-- Declare needed variables & cursor
DECLARE
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

	-- Cursor to store the prospect entries in the DB
	CURSOR c_prospectiveCustomers IS 
		SELECT *
		  FROM prospectCustomerCars
		 WHERE TRIM(UPPER(cname)) = TRIM(UPPER('&p_customerName'));

	-- Cursor to store the order options for the prospective entries
	CURSOR c_prospectCustomersOptions IS 
		SELECT o.*
		  FROM prospect p
		 INNER JOIN options o
			ON p.ocode = o.ocode
		 WHERE TRIM(UPPER(p.cname)) = TRIM(UPPER('&p_customerName'))
		   AND TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
		   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
		   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
		   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
		   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));
		 
	-- Custom Exception to handle when user didn't enter a value
	e_no_data_entry EXCEPTION;
BEGIN
	-- Check if the user entered a Customer Name
	IF (LENGTH(TRIM('&p_customerName')) IS NULL) THEN
		-- Raise the custom invalid entry exception
		RAISE e_no_data_entry;
	END IF;

	-- Get and store the number of prospect entries based on the prompted name
	SELECT COUNT(*)
	  INTO v_prospectCount
	  FROM prospectCustomerCars
	 WHERE TRIM(UPPER(cname)) = TRIM(UPPER('&p_customerName'));

	-- Format the display of the output to display like report
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 65, '-'));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Perspective Customer Information', 66));
	DBMS_OUTPUT.PUT_LINE(LPAD('-', 65, '-'));

	-- Display the Prospective Customers Name
	DBMS_OUTPUT.PUT_LINE('Prospect Name: ' || TRIM(UPPER('&p_customerName')));

	-- Open the prospect customer cursor
	OPEN c_prospectiveCustomers;
		-- Dispaly the number of cars Prospecting
		DBMS_OUTPUT.PUT_LINE('Number of Cars Prospected: ' || v_prospectCount || CHR(10));

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
			 WHERE TRIM(UPPER(cname)) = TRIM(UPPER('&p_customerName'))
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
		-- End the loop
		END LOOP;

	-- Close the prospect List cursor
	CLOSE c_prospectiveCustomers;
	
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
