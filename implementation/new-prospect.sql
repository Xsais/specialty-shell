SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to insert a new vehicle;
PROMPT;
ACCEPT p_cname PROMPT    '     Enter the customers name: ';
ACCEPT p_make PROMPT     '     Enter the customers desired make: ';
ACCEPT p_model PROMPT    '     Enter the customers desired model: ';
ACCEPT p_cyear PROMPT    '     Enter the customers desired year: ';
ACCEPT p_color PROMPT    '     Enter the customers desired color: ';
ACCEPT p_trim PROMPT     '     Enter the customers desired trim: ';
ACCEPT p_ocode PROMPT    '     Enter the customers desired option code: ';

DECLARE

    v_errorCode SMALLINT := NEW_PROSPECT('&p_cname', '&p_make', '&p_model', '&p_cyear', '&p_color', '&p_trim', '&p_ocode');

    prospect_exits EXCEPTION;
    internal_exception EXCEPTION;
    invalid_make EXCEPTION;
    invalid_ocode EXCEPTION;
BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('The desired customer prospect wa inserted into the database');
        WHEN v_errorCode = -2
            THEN

                RAISE prospect_exits;
        WHEN v_errorCode = -3
            THEN

                RAISE invalid_make;
        WHEN v_errorCode = -4
            THEN
            
                RAISE invalid_ocode;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION
    
    WHEN prospect_exits
        THEN
        
            DBMS_OUTPUT.PUT_LINE('The desired prospect already exists');
    WHEN invalid_make
        THEN
        
            DBMS_OUTPUT.PUT_LINE('The entered make was not valid');
    WHEN invalid_ocode
        THEN
        
            DBMS_OUTPUT.PUT_LINE('The entered option was not found');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NP' || v_errorCode);
END;
/