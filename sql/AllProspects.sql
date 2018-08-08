SET SERVEROUTPUT ON;

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

	-- Cursor to store the prospect entries in the DB
	CURSOR prospectiveCustomers_cur IS 
		SELECT *
		  FROM prospectCustomerCars;

	-- Cursor to store the order options for the prospective entries
	CURSOR prospectCustomersOptions_cur IS 
		SELECT o.*
		  FROM prospect p
		 INNER JOIN options o
			ON p.ocode = o.ocode
		 WHERE TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
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
	 WHERE TRIM(UPPER(make)) = TRIM(UPPER(v_prospectMake))
		   AND TRIM(UPPER(model)) = TRIM(UPPER(v_prospectModel))
		   AND TRIM(UPPER(cyear)) = TRIM(UPPER(v_prospectCYear))
		   AND TRIM(UPPER(color)) = TRIM(UPPER(v_prospectColor))
		   AND TRIM(UPPER(trim)) = TRIM(UPPER(v_prospectTrim));

	-- Display Report Title & Headdings
	DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || 'Perspect List' || CHR(10) || CHR(10) || 'Name                 Want' || CHR(10) || '-------------------- --------------------------------------------------------------------------------');

	-- Open the prospectList cursor
	OPEN prospectiveCustomers_cur;
		-- Loop through the results of the cursor and then display it to the console
		LOOP
			-- Fetch the results from the cursor into the prospect object variable
			FETCH prospectiveCustomers_cur INTO v_prospectCName, v_prospectMake, v_prospectModel, v_prospectCYear, v_prospectColor, v_prospectTrim;

			-- Exit the loop when there is nothing found in the cursor
			EXIT WHEN prospectiveCustomers_cur%NOTFOUND;

			-- Display prospective car information
			IF (v_prospectCYear IS NULL) THEN
				IF (v_prospectColor IS NULL) THEN
					IF (v_prospectModel IS NULL) THEN
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectTrim));
					ELSE
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectModel) || ' ' || TRIM(v_prospectTrim));
					END IF;	
				ELSE
					IF (v_prospectModel IS NULL) THEN
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectTrim));
					ELSE
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectColor) || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectModel) || ' ' || TRIM(v_prospectTrim));
					END IF;	
				END IF;
			ELSE
				IF (v_prospectColor IS NULL) THEN
					IF (v_prospectModel IS NULL) THEN
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectCYear) || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectTrim));
					ELSE
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectCYear) || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectModel) || ' ' || TRIM(v_prospectTrim));
					END IF;	
				ELSE
					IF (v_prospectModel IS NULL) THEN
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectCYear) || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectTrim));
					ELSE
						DBMS_OUTPUT.PUT_LINE(v_prospectCName || ' ' || TRIM(v_prospectCYear) || ' ' || TRIM(v_prospectColor) || ' ' || TRIM(v_prospectMake) || ' ' || TRIM(v_prospectModel) || ' ' || TRIM(v_prospectTrim));
					END IF;	
				END IF;
			END IF;
			
			-- Display section headding
			/*DBMS_OUTPUT.PUT_LINE('Options: ');

			-- Open the prospectCustomersOptions_cur cursor
			OPEN prospectCustomersOptions_cur;
				-- Loop through the results of the cursor and then display it to the console
				LOOP
					-- Fetch the results from the cursor into the prospect object variable
					FETCH prospectCustomersOptions_cur INTO v_prospectOption;

					-- Exit the loop when there is nothing found in the cursor
					EXIT WHEN prospectCustomersOptions_cur%NOTFOUND;
						DBMS_OUTPUT.PUT_LINE(CHR(9) || '- ' || TRIM(v_prospectOption.odesc));
					-- End the loop
					END LOOP;
				-- Close the prospect List cursor
				CLOSE prospectCustomersOptions_cur;

				DBMS_OUTPUT.PUT_LINE(CHR(10));*/
		-- End the loop
		END LOOP;

	-- Close the prospect List cursor
	CLOSE prospectiveCustomers_cur;
END;
/
