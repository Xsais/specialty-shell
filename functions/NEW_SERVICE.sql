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

CREATE OR REPLACE FUNCTION NEW_SERVICE
(
    servinv   servinv.servinv%TYPE,
    serdate   CHAR,
    ccname     servinv.cname%TYPE,
    cserial    servinv.serial%TYPE,
    workdesc  servwork.workdesc%TYPE,
    partscost servinv.partscost%TYPE DEFAULT 0,
    labourcost servinv.laborcost%TYPE DEFAULT 0
)
RETURN SMALLINT
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

	RETURN -5;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE UPPER(c.serial) = UPPER(cserial);

  IF v_count = 0
  THEN

	RETURN -6;
  END IF;

  IF RTRIM(workdesc) = ''
  THEN

	RETURN -7;
  END IF;

  IF v_serdate > SYSDATE OR serdate < '1885/01/01'
	  THEN

		RETURN -8;
  END IF;

   IF partscost < 0
    THEN
        
        RETURN -3;
    END IF;
    
   IF labourcost < 0
    THEN
        
        RETURN -4;
    END IF;
    
    INSERT INTO servinv s (
	  s.servinv,
	  s.serdate,
	  s.cname,
	  s.serial,
	  s.partscost,
	  s.laborcost,
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
        RETURN 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

         RETURN -2;
END;
/

/** OUTPUT:
 * Function NEW_SERVICE compiled
 *
 **/