/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: NEW_CUSTOMER.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a new customer tto the database
*/

CREATE OR replace FUNCTION NEW_CUSTOMER (
	cname  customer.cname%TYPE,
	street customer.cstreet%TYPE,
	city   customer.ccity%TYPE,
	prov   customer.cprov%TYPE,
	postal customer.cpostal%TYPE,
	hphone customer.chphone%TYPE,
	bphone customer.cbphone%TYPE
)
RETURN SMALLINT
AS
BEGIN

    IF NOT REGEXP_LIKE(postal, '(\d{5}([ \-]\d{4})?)|([ABCEGHJKLMNPRSTVXY]{1}\d{1}[A-Z]{1}[ \-]\d{1}[A-Z]{1}\d{1})')
        THEN

            RETURN -3;
    END IF;

    IF NOT REGEXP_LIKE(hphone, '\s*(?:\+?(\d{1,3}))?([-. (]*(\d{3})[-. )]*)?((\d{3})[-. ]*(\d{2,4})(?:[-.x ]*(\d+))?)\s*')
        THEN

            RETURN -4;
    END IF;

    IF NOT REGEXP_LIKE(bphone, '\s*(?:\+?(\d{1,3}))?([-. (]*(\d{3})[-. )]*)?((\d{3})[-. ]*(\d{2,4})(?:[-.x ]*(\d+))?)\s*')
        THEN

            RETURN -5;
    END IF;

    INSERT INTO customer
    	(
    	   cname,
    	   cstreet,
    	   ccity,
    	   cprov,
    	   cpostal,
    	   chphone,
    	   cbphone
    	)
    VALUES (
       cname,
       street,
       city,
       prov,
       postal,
       hphone,
       bphone
     );

    RETURN 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
             RETURN -2;

    WHEN OTHERS THEN
             RETURN -1;
END;
/

/** OUTPUT:
 * Function NEW_CUSTOMER compiled
 *
 **/