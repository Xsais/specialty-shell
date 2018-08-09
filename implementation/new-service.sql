SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to insert a new vehicle;
PROMPT;
ACCEPT p_servinv PROMPT    '     Enter the invoice option of the service: ';
ACCEPT p_servdate PROMPT   '     Enter the date of the service: ';
ACCEPT p_cname PROMPT      '     Enter the customer that requested the service: ';
ACCEPT p_serial PROMPT     '     Enter the serial number for the car serviced: ';
ACCEPT p_workdesc PROMPT   '     Enter the description of the work did: ';
ACCEPT p_partscost PROMPT  '     Enter the total cost of the parts used for the service: ';
ACCEPT p_labourcost PROMPT '     Enter the total cost fo r the labour for the service: ';

DECLARE

    v_errorCode SMALLINT := NEW_SERVICE('&p_servinv', '&p_servdate', '&p_cname', '&p_serial', '&p_workdesc', '&p_partscost', '&p_labourcost');

    invalid_cost EXCEPTION;
    service_exits EXCEPTION;
    internal_exception EXCEPTION;
BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('The service invoice number &p_servinv was inserted into the database');
        WHEN v_errorCode = -2
            THEN

                RAISE service_exits;
        WHEN v_errorCode = -3 OR v_errorCode = -4 OR v_errorCode = -5
            THEN
            
                RAISE invalid_cost;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION
    
    WHEN service_exits
        THEN
        
            DBMS_OUTPUT.PUT_LINE('The provided service invoice number already exists');
    WHEN invalid_cost
        THEN
        
            DBMS_OUTPUT.PUT_LINE('Invalid number, cost must be greater or equal to zero');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NSE' || v_errorCode);
END;
/