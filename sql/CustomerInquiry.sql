-- James Gr
-- 991443203
-- August 7, 2018

SET SERVEROUTPUT ON;

ACCEPT p_customerName PROMPT 'Enter Customer Name: '
DECLARE
	v_customer customer%ROWTYPE;
BEGIN
	-- See if the customer is in the database
	SELECT *
	  INTO v_customer
	  FROM customer
	 WHERE UPPER(TRIM(cname)) = TRIM(UPPER('&p_customerName'));
	
	-- Display the customer information
	DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------' || CHR(10) || CHR(9) || CHR(9) || CHR(9) || TRIM(v_customer.cname) || ' Customer Information' || CHR(10) || '------------------------------------------------------------' || CHR(10) || 'Address: ' || TRIM(v_customer.cstreet) || ', ' || TRIM(v_customer.ccity) || ', ' || TRIM(v_customer.cprov) || ' ' || TRIM(v_customer.cpostal) || CHR(10) || 'Home: ' || TRIM(v_customer.chphone) || CHR(10) || 'Work: ' || TRIM(v_customer.cbphone));
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Oops...  That customer cannot be found.  Please try again.');
END;
/
