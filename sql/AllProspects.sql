-- James Grau
-- August 7, 2018

-- Set Serveroutput and format and then console linesize
SET SERVEROUTPUT ON FORMAT WRAPPED;
SET LINESIZE 132;
SET FEEDBACK OFF;

-- Declare needed variables and cursor
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
	DBMS_OUTPUT.PUT(LPAD('-', 131, '-'));
	DBMS_OUTPUT.PUT_LINE(CENTERSTRING('Perspect List', 132));
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
