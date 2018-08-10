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

CREATE OR REPLACE PROCEDURE NEW_CUSTOMER (

  	errorcode  OUT SMALLINT,
	cname  customer.cname%TYPE,
	street customer.cstreet%TYPE,
	city   customer.ccity%TYPE,
	prov   customer.cprov%TYPE,
	postal customer.cpostal%TYPE  DEFAULT NULL,
	hphone customer.chphone%TYPE  DEFAULT NULL,
	bphone customer.cbphone%TYPE  DEFAULT NULL
)
AS

  v_count SMALLINT;
BEGIN

 	IF cname IS NULL
	  THEN

	  	errorcode := -6;
		RETURN;
	END IF;

  IF street IS NULL
  THEN

	errorcode := -7;
	RETURN;
  END IF;

  IF city IS NULL
  THEN

	errorcode := -8;
	RETURN;
  END IF;

  IF prov IS NULL
  THEN

	errorcode := -9;
	RETURN;
  END IF;


  IF postal IS NOT NULL AND NOT REGEXP_LIKE(LOWER(postal), '[a-z]\d[a-z][ \-]?\d[a-z]\d')
        THEN

            errorcode := -3;
		  RETURN;
    END IF;

    IF hphone IS NOT NULL AND NOT hphone IS NOT NULL AND REGEXP_LIKE(hphone, '\(\d{3}\)\d{3}-\d{4}')
        THEN

            errorcode := -4;
		  RETURN;
    END IF;

    IF bphone IS NOT NULL AND NOT bphone IS NOT NULL AND REGEXP_LIKE(bphone, '\(\d{3}\)\d{3}-\d{4}')
        THEN

            errorcode := -5;
		  RETURN;
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

    errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
             errorcode := -2;

    WHEN OTHERS THEN
             errorcode := -1;
END;
/

/** OUTPUT:
 * Function NEW_CUSTOMER compiled
 *
 **/