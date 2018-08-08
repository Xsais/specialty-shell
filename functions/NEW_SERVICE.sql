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
    serdate   servinv.serdate%TYPE,
    cname     servinv.cname%TYPE,
    serial    servinv.serial%TYPE,
    partscost servinv.partscost%TYPE,
    labourcost servinv.laborcost%TYPE
)
RETURN SMALLINT
AS
BEGIN

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
		  serdate,
		  cname,
		  serial,
		  partscost,
		  labourcost,
		  ((partscost + labourcost) * 0.13)
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
 * Function NEW_SERVICE compiled
 *
 **/