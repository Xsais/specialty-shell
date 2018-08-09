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

    v_errorCode SMALLINT := NEW_CUSTOMER('&p_cname', '&p_street', '&p_city', '&p_prov', '&p_postal', '&p_hphone', '&p_bphone');

    customer_exits EXCEPTION;
    incorrect_postal EXCEPTION;
    incorrect_phone EXCEPTION;
    internal_exception EXCEPTION;
BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('&p_cname Was successfully inserted into the database');
        WHEN v_errorCode = -2
            THEN

                RAISE customer_exits;
        WHEN v_errorCode = -3
            THEN

                RAISE incorrect_postal;
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
    WHEN incorrect_phone
        THEN

            DBMS_OUTPUT.PUT_LINE('Invalid phone number, must be in the format ''123-456-7890''');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NC-' || v_errorCode);
END;
/