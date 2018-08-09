SET SERVEROUTPUT ON;
SET VERIFY OFF

PROMPT Enter the information bellow to insert a new vehicle;
PROMPT;
ACCEPT p_serial PROMPT '     Enter the car serial number: ';
ACCEPT p_make PROMPT '     Enter the make of the car: ';
ACCEPT p_model PROMPT '     Enter the model of the car: ';
ACCEPT p_cyear PROMPT '     Enter the year of the car: ';
ACCEPT p_color PROMPT '     Enter the color of the car: ';
ACCEPT p_trim PROMPT '     Enter the trim of the car: ';
ACCEPT p_engine PROMPT '     Enter the type of engine the car contains: ';
ACCEPT p_cname PROMPT '     Enter the owner of the car: ';
ACCEPT p_purchinv PROMPT '     Enter the invoice number of the purchase order: ';
ACCEPT p_purchdate PROMPT '     Enter the date in which the car was purchased: ';
ACCEPT p_purchfrom PROMPT '     Enter the business or the person the car was purchased from: ';
ACCEPT p_purchcost PROMPT '     Enter the cost specialty imports paid to acquire the car: ';
ACCEPT p_freightcost PROMPT '     Enter the cost to import the car: ';
ACCEPT p_listprice PROMPT '     Enter the priced in which th car is listed: ';

DECLARE

    v_errorCode SMALLINT := NEW_VEHICLE('&p_serial', '&p_make', '&p_cyear', '&p_color', '&p_trim', '&p_engine', '&p_cname', '&p_purchinv', '&p_purchdate', '&p_purchfrom', '&p_purchcost', '&p_freightcost', '&p_listprice');

    invalid_cost EXCEPTION;
    vehcile_exits EXCEPTION;
    internal_exception EXCEPTION;
BEGIN

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
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION
    
    WHEN vehcile_exits
        THEN
        
            DBMS_OUTPUT.PUT_LINE('A vehcile with that serial number already exists');
    WHEN invalid_cost
        THEN
        
            DBMS_OUTPUT.PUT_LINE('Invalid number, cost must be greater or equal to zero');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NV-' || v_errorCode);
END;
/