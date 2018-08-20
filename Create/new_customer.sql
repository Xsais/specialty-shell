/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: new_customer.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a customer the database
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to insert a new customer;
PROMPT;
ACCEPT p_cname PROMPT  '     Enter the desired customer name: ';
ACCEPT p_street PROMPT '     Enter &p_cname''s address: ';
ACCEPT p_city PROMPT   '     Enter &p_cname''s city: ';
ACCEPT p_prov PROMPT   '     Enter &p_cname''s province: ';
ACCEPT p_postal PROMPT '     Enter &p_cname''s postal code: ';
ACCEPT p_hphone PROMPT '     Enter &p_cname''s home phone number: ';
ACCEPT p_bphone PROMPT '     Enter &p_cname''s business phone number: ';

DECLARE

    v_errorCode SMALLINT;

    customer_exits EXCEPTION;
    incorrect_postal EXCEPTION;
    incorrect_phone EXCEPTION;
    internal_exception EXCEPTION;
    incorrect_street EXCEPTION;
    incorrect_city EXCEPTION;
    incorrect_prov EXCEPTION;
    customer_blank EXCEPTION;
BEGIN

NEW_CUSTOMER(v_errorCode, '&p_cname', '&p_street', '&p_city', '&p_prov', '&p_postal', '&p_hphone', '&p_bphone');

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('&p_cname Was successfully inserted into the database');
        WHEN v_errorCode = -2
            THEN

                RAISE customer_exits;
        WHEN v_errorCode = -6
        	THEN

        		RAISE customer_blank;
        WHEN v_errorCode = -3
            THEN

                RAISE incorrect_postal;
        WHEN v_errorCode = -7
        	THEN

        		RAISE incorrect_street;
        WHEN v_errorCode = -8
        	THEN

        		RAISE incorrect_city;
        WHEN v_errorCode = -9
        	THEN

        		RAISE incorrect_prov;
        WHEN v_errorCode = -4 OR v_errorCode = -5
            THEN

                RAISE incorrect_phone;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION

    WHEN customer_exits
        THEN

            DBMS_OUTPUT.PUT_LINE('A customer with the name of &p_cname already exits');
    WHEN incorrect_postal
        THEN

            DBMS_OUTPUT.PUT_LINE('Invalid postal code, must be in the format ''V5V V5V''');
    WHEN customer_blank
    	THEN

    		DBMS_OUTPUT.PUT_LINE('The customer street must not be blank');
    WHEN incorrect_street
        THEN

            DBMS_OUTPUT.PUT_LINE('The street must not be blank');
    WHEN incorrect_prov
        THEN

            DBMS_OUTPUT.PUT_LINE('The province must not be blank');
    WHEN incorrect_city
        THEN

            DBMS_OUTPUT.PUT_LINE('The city must be not blank');
    WHEN incorrect_phone
        THEN

            DBMS_OUTPUT.PUT_LINE('Invalid phone number, must be in the format ''(000)000-0000''');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NC' || v_errorCode);
END;
/

EXIT;