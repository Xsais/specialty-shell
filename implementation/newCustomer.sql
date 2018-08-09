SET SERVEROUTPUT ON;
-- SET VERIFY OFF

PROMPT Enter the information bellow to insert a new customer;
PROMPT; 
ACCEPT p_cname PROMPT '     Enter the desired customer name: ';
ACCEPT p_street PROMPT '     Enter &p_cname''s address: ';
ACCEPT p_city PROMPT '     Enter &p_cname''s city: ';
ACCEPT p_prov PROMPT '     Enter &p_cname''s province: ';
ACCEPT p_postal PROMPT '     Enter &p_cname''s postal code: ';
ACCEPT p_hphone PROMPT '     Enter &p_cname''s home phone number: ';
ACCEPT p_bphone PROMPT '     Enter &p_cname''s bussiness phone number: ';

DECLARE

    v_errorCode SMALLINT := NEW_CUSTOMER('&p_cname', '&p_street', '&p_city', '&p_prov', '&p_postal', '&p_hphone', '&p_bphone');
BEGIN

    CASE
        
        WHEN v_errorCode = 0
            THEN
            
                DBMS_OUTPUT.PUT_LINE('&p_cname Was succsesfully inserted into the database');
    END CASE;
END;
/