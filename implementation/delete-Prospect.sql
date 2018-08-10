/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: delete_prospect.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Deletes a prospect the database
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to delete a prospect list
PROMPT;
ACCEPT p_cname PROMPT  '     Enter the desired customer name: ';

DECLARE

    v_errorCode SMALLINT;

    customer_exits EXCEPTION;
    customer_invalid EXCEPTION;
    internal_exception EXCEPTION;

BEGIN

DELETE_PROSPECT(v_errorCode, '&p_cname');

    DBMS_OUTPUT.PUT_LINE(CHR(10));

    CASE
        WHEN v_errorCode = -2
            THEN

                RAISE customer_exits;
        WHEN v_errorCode = -3
        	THEN

        		RAISE customer_invalid;
        ELSE

            RAISE internal_exception;
    END CASE;

    COMMIT WORK;
EXCEPTION
    WHEN customer_invalid
        THEN

            DBMS_OUTPUT.PUT_LINE('No costumer found to delete');
END;
/