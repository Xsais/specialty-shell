SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to create a new sale;
PROMPT;
ACCEPT p_saleinv PROMPT     '     Enter the invoice for the sale: ';
ACCEPT p_cname PROMPT       '     Enter the customer that made the purchase: ';
ACCEPT p_salesman PROMPT    '     Enter the employee that made the sale: ';
ACCEPT p_saledate PROMPT    '     Enter the date in which the sale was made: ';
ACCEPT p_serial PROMPT      '     Enter the serial of the car sold: ';
ACCEPT p_totalprice PROMPT  '     Enter the selling price for the car: ';
ACCEPT p_discount PROMPT    '     Enter the discount for this sale: ';
ACCEPT p_licfee PROMPT      '     Enter the amount paid for the license: ';
ACCEPT p_commission PROMPT  '     Enter the commission &p_salesman made on the sale: ';
ACCEPT p_tradeserial PROMPT '     Enter the serial of the car that was traded in: ';
ACCEPT p_tradeallow PROMPT  '     Enter the allowed discount from the trade in: ';
ACCEPT p_fire PROMPT        '     Did the custer purchase fire insurance? ';
ACCEPT p_collision PROMPT   '     Did the custer purchase insurance insurance? ';
ACCEPT p_liability PROMPT   '     Did the custer purchase liability insurance? ';
ACCEPT p_property PROMPT    '     Did the custer purchase property insurance? ';

DECLARE

    v_errorCode SMALLINT := NEW_SALE('&p_saleinv', '&p_cname', '&p_salesman','&p_saledate', '&p_serial'
        , '&p_totalprice', '&p_discount', '&p_licfee', '&p_commission', '&p_tradeserial', '&p_tradeallow'
    	, '&p_fire', '&p_collision', '&p_liability', '&p_property');

    invalid_cost EXCEPTION;
    sale_exits EXCEPTION;
    internal_exception EXCEPTION;
BEGIN

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('The sale with an invoice number of &p_saleinv was added to the database');
        WHEN v_errorCode = -2
            THEN

                RAISE sale_exits;
        WHEN v_errorCode = -3 OR v_errorCode = -4 OR v_errorCode = -5
            THEN

                RAISE invalid_cost;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION

    WHEN sale_exits
        THEN

            DBMS_OUTPUT.PUT_LINE('The provided sale invoice number already exists');
    WHEN invalid_cost
        THEN

            DBMS_OUTPUT.PUT_LINE('Invalid number, cost must be greater or equal to zero');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: NSA' || v_errorCode);
END;
/