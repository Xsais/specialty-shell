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