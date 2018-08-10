/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: new_service.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a service the database
*/

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
    no_customer EXCEPTION;
    no_car EXCEPTION;
    invalid_work ExCEPTION;
    not_opened EXCEPTION;
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
        WHEN v_errorCode = -3 OR v_errorCode = -4
            THEN
            
                RAISE invalid_cost;
        WHEN v_errorCode = -5
            THEN

                RAISE no_customer;
        WHEN v_errorCode = -6
            THEN

                RAISE no_car;
        WHEN v_errorCode = -7
            THEN

                RAISE invalid_work;
        WHEN v_errorCode = -8
            THEN

                RAISE not_opened;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION
    
    WHEN service_exits
        THEN
        
            DBMS_OUTPUT.PUT_LINE('The service already exists');
    WHEN no_customer
        THEN

            DBMS_OUTPUT.PUT_LINE('The entered customer does not exist');
    WHEN no_car
        THEN

            DBMS_OUTPUT.PUT_LINE('The provided service invoice number already exists');
    WHEN invalid_work
        THEN

            DBMS_OUTPUT.PUT_LINE('The invoice needs a work description');
    WHEN not_opened
        THEN

            DBMS_OUTPUT.PUT_LINE('The date must be greater than (1885-01-01) and less than ('
            || TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ')');
    WHEN invalid_cost
        THEN
        
            DBMS_OUTPUT.PUT_LINE('Invalid number, cost must be greater or equal to zero');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NSE' || v_errorCode);
END;
/