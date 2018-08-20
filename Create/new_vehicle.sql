/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: new_vehicle.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a vehicle the database
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to insert a new vehicle;
PROMPT;
ACCEPT p_serial PROMPT      '     Enter the car serial number: ';
ACCEPT p_make PROMPT        '     Enter the make of the car: ';
ACCEPT p_model PROMPT       '     Enter the model of the car: ';
ACCEPT p_cyear PROMPT       '     Enter the year of the car: ';
ACCEPT p_color PROMPT       '     Enter the color of the car: ';
ACCEPT p_trim PROMPT        '     Enter the trim of the car: ';
ACCEPT p_engine PROMPT      '     Enter the type of engine the car contains: ';
ACCEPT p_cname PROMPT       '     Enter the owner of the car: ';
ACCEPT p_purchinv PROMPT    '     Enter the invoice number of the purchase order: ';
ACCEPT p_purchdate PROMPT   '     Enter the date in which the car was purchased: ';
ACCEPT p_purchfrom PROMPT   '     Enter the business or the person the car was purchased from: ';
ACCEPT p_purchcost PROMPT   '     Enter the cost specialty imports paid to acquire the car: ';
ACCEPT p_freightcost PROMPT '     Enter the cost to import the car: ';
ACCEPT p_listprice PROMPT   '     Enter the priced in which th car is listed: ';

DECLARE

    v_errorCode SMALLINT;

    invalid_cost EXCEPTION;
    vehcile_exits EXCEPTION;
    make_invalid EXCEPTION;
    vehicle_blank EXCEPTION;
    make_blank EXCEPTION;
    model_blank EXCEPTION;
    year_blank EXCEPTION;
    color_blank EXCEPTION;
    trim_blank EXCEPTION;
    engine_blank EXCEPTION;
    internal_exception EXCEPTION;
BEGIN

NEW_VEHICLE(v_errorCode, '&p_serial', '&p_make', '&p_model', '&p_cyear', '&p_color', '&p_trim', '&p_engine', '&p_cname', '&p_purchinv', '&p_purchdate', '&p_purchfrom', '&p_purchcost', '&p_freightcost', '&p_listprice');

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('The car with serial &p_serial was inserted into the database');
        WHEN v_errorCode = -2
            THEN

                RAISE vehcile_exits;
        WHEN v_errorCode = -3 OR v_errorCode = -4 OR v_errorCode = -5
            THEN

                RAISE invalid_cost;
        WHEN v_errorCode = -6
            THEN

                RAISE vehicle_blank;
        WHEN v_errorCode = -13
            THEN

                RAISE make_invalid;
        WHEN v_errorCode = -7
            THEN

                RAISE make_blank;
        WHEN v_errorCode = -8
            THEN

                RAISE year_blank;
        WHEN v_errorCode = -9
            THEN

                RAISE color_blank;
        WHEN v_errorCode = -10
            THEN

                RAISE trim_blank;
        WHEN v_errorCode = -11
            THEN

                RAISE engine_blank;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION

    WHEN vehcile_exits
        THEN

            DBMS_OUTPUT.PUT_LINE('A vehicle with that serial number already exists');
    WHEN make_invalid
    	THEN

            DBMS_OUTPUT.PUT_LINE('The entered make was not valid');
    WHEN vehicle_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a serial number');
    WHEN make_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a make');
    WHEN model_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a model');
    WHEN year_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a year');
    WHEN color_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a color');
    WHEN trim_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a trim');
    WHEN engine_blank
        THEN

            DBMS_OUTPUT.PUT_LINE('The vehicle must have a engine type');
    WHEN invalid_cost
        THEN

            DBMS_OUTPUT.PUT_LINE('Invalid number, cost must be greater or equal to zero');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NV' || v_errorCode);
END;
/

EXIT;