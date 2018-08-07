ACCEPT p_customerName PROMPT 'Enter a Prospective Customers Name: '

DECLARE
	-- Create needed variables to hold rows from tables and count of items
	v_prospect prospect%ROWTYPE;
	v_prospectOption options%ROWTYPE;
	v_prospectCount NUMBER;

	-- Cursor to store the prospect entries in the DB
	CURSOR prospectiveCustomers_cur IS 
	SELECT *
	  FROM prospect
	 WHERE TRIM(UPPER(cname)) = TRIM(UPPER('&p_customerName'));

	-- Cursor to store the order options for the prospective entries
	CURSOR prospectCustomersOptions_cur IS 
	SELECT o.*
	  FROM prospect p
	 INNER JOIN options o
		ON p.ocode = o.ocode
	 WHERE TRIM(UPPER(p.cname)) = TRIM(UPPER('&p_customerName'));

	-- Create custom exception
	ex_no_data_found EXCEPTION;
BEGIN
	-- Get and store the number of prospect entries based on the prompted name
	SELECT COUNT(*)
	  INTO v_prospectCount
	  FROM prospect
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
			FETCH prospectiveCustomers_cur INTO v_prospect;

			-- Exit the loop when there is nothing found in the cursor
			EXIT WHEN prospectiveCustomers_cur%NOTFOUND;

			-- Display prospective car information
			DBMS_OUTPUT.PUT_LINE('Prospective Car: ' || TRIM(v_prospect.make) || ' ' || TRIM(v_prospect.model) || ' (' || TRIM(v_prospect.cyear) || ') ' || TRIM(v_prospect.color) || ' ' || TRIM(v_prospect.trim));

			-- Display section headding
			DBMS_OUTPUT.PUT_LINE('Options: ');

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

				DBMS_OUTPUT.PUT_LINE(CHR(10));
		-- End the loop
		END LOOP;

	-- Close the prospect List cursor
	CLOSE prospectiveCustomers_cur;
END;
/
