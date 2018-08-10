/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: delete_prospect.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Deletes a prospect from the database
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET FEEDBACK OFF;

PROMPT Enter the information bellow to delete a prospect list
PROMPT;
ACCEPT p_cname PROMPT  '     Enter the desired customer name: ';

DECLARE

  v_errorcode SMALLINT;

	customer_invalid EXCEPTION;
	internal_exception EXCEPTION;

BEGIN

  DELETE_PROSPECT(v_errorcode, '&p_cname');

  dbms_output.PUT_LINE(CHR(10));

  CASE

        WHEN v_errorCode = 0
            THEN

                DBMS_OUTPUT.PUT_LINE('The desired customer prospect was deleted');
	WHEN v_errorcode = -3
	THEN

	  RAISE customer_invalid;
  ELSE

	RAISE internal_exception;
  END CASE;

  COMMIT WORK;
  EXCEPTION
  WHEN customer_invalid
  THEN

	dbms_output.PUT_LINE('No costumer found to delete');
    WHEN internal_exception
        THEN

            DBMS_OUTPUT.PUT_LINE('Internal server error, please contact the server admin'
                                 || CHR(10) || CHR(10) || CHR(9) || 'Error code: DP' || v_errorCode);
END;
/