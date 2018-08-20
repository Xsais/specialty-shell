/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: NEW_SERVICE.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a new service invoice tto the database
*/

CREATE OR REPLACE PROCEDURE NEW_SERVICE
(
    errorcode OUT SMALLINT,
    servinv   servinv.servinv%TYPE,
    serdate   CHAR,
    ccname     servinv.cname%TYPE,
    cserial    servinv.serial%TYPE,
    workdesc  servwork.workdesc%TYPE,
    partscost servinv.partscost%TYPE DEFAULT 0,
    labourcost servinv.labourcost%TYPE DEFAULT 0
)
AS

  	v_serdate DATE := TO_DATE(serdate, 'YYYY-MM-DD');
  	v_count SMALLINT;
BEGIN

  SELECT COUNT(*)
	  INTO v_count
  	FROM customer c
  	WHERE UPPER(c.cname) = UPPER(ccname);

  IF v_count = 0
  THEN

	errorcode := -5;
	RETURN;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE UPPER(c.serial) = UPPER(cserial);

  IF v_count = 0
  THEN

	errorcode := -6;
	RETURN;
  END IF;

  IF RTRIM(workdesc) = ''
  THEN

	errorcode := -7;
	RETURN;
  END IF;

  IF v_serdate > SYSDATE OR serdate < '1885/01/01'
	  THEN

		errorcode := -8;
		RETURN;
  END IF;

   IF partscost < 0
    THEN

        errorcode := -3;
	  RETURN;
    END IF;

   IF labourcost < 0
    THEN

        errorcode := -4;
	  RETURN;
    END IF;

    INSERT INTO servinv s (
	  s.servinv,
	  s.serdate,
	  s.cname,
	  s.serial,
	  s.partscost,
	  s.labourcost,
	  s.tax
    )
        VALUES (
		  servinv,
		  v_serdate,
		  ccname,
		  cserial,
		  partscost,
		  labourcost,
		  ((partscost + labourcost) * 0.13)
         );

    INSERT INTO servwork s (
	  s.servinv,
	  s.workdesc
    )
        VALUES (
		  servinv,
          workdesc
         );
        errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

         errorcode := -2;
END;
/

/** OUTPUT:
 * Function NEW_SERVICE compiled
 *
 **/