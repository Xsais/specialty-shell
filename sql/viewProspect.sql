SET SERVEROUTPUT ON;

-- Prompt the user for a customer name
ACCEPT p_customerName PROMPT 'Enter a Prospective Customers Name: '

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
	CURSOR prospectiveCustomers_cur IS 
		SELECT *
		  FROM prospectCustomerCars
		 WHERE TRIM(UPPER(cname)) = TRIM(UPPER('&p_customerName'));

	-- Cursor to store the order options for the prospective entries
	CURSOR prospectCustomersOptions_cur IS 
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

	-- Create custom exception
	ex_no_data_found EXCEPTION;
BEGIN
	-- Get and store the number of prospect entries based on the prompted name
	SELECT COUNT(*)
	  INTO v_prospectCount
	  FROM prospectCustomerCars
	 WHERE TRIM(UPPER(cname)) = TRIM(UPPER('&p_customerName'));

	-- Display Report Title
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE('|           Perspective Customer Information         |');
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');

	-- Display the Prospective Customers Name
	DBMS_OUTPUT.PUT_LINE('Prospect Name: ' || TRIM(UPPER('&p_customerName')));

	-- Open the prospectList cursor
	OPEN prospectiveCustomers_cur;
		-- Dispaly the number of cars Prospecting
		DBMS_OUTPUT.PUT_LINE('Number of Cars Prospected: ' || v_prospectCount || CHR(10));

		-- Loop through the results of the cursor and then display it to the console
		LOOP
			-- Fetch the results from the cursor into the prospect object variable
			FETCH prospectiveCustomers_cur INTO v_prospectCName, v_prospectMake, v_prospectModel, v_prospectCYear, v_prospectColor, v_prospectTrim;

			-- Exit the loop when there is nothing found in the cursor
			EXIT WHEN prospectiveCustomers_cur%NOTFOUND;

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
				-- Open the prospectCustomersOptions_cur cursor
				OPEN prospectCustomersOptions_cur;	
					-- Loop through the results of the cursor and then display it to the console
					LOOP
						-- Fetch the results from the cursor into the prospect object variable
						FETCH prospectCustomersOptions_cur INTO v_prospectOption;
	
						-- Exit the loop when there is nothing found in the cursor
						EXIT WHEN prospectCustomersOptions_cur%NOTFOUND;					
						-- Display options
						DBMS_OUTPUT.PUT_LINE(CHR(9) || '- ' || TRIM(v_prospectOption.odesc));
					-- End the loop
					END LOOP;
					
					-- Formatting extra line
					DBMS_OUTPUT.PUT_LINE(CHR(10));
				-- Close the prospect List cursor
				CLOSE prospectCustomersOptions_cur;
			ELSE
				DBMS_OUTPUT.PUT_LINE(CHR(9) || '- No Options' || CHR(10));
			END IF;
		-- End the loop
		END LOOP;

	-- Close the prospect List cursor
	CLOSE prospectiveCustomers_cur;
END;
/
