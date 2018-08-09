/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: NEW_PROSPECT.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a new prospect tto the database
*/

CREATE OR REPLACE FUNCTION NEW_PROSPECT
(
    cname prospect.cname%TYPE,
    make  prospect.make%TYPE,
    model prospect.model%TYPE DEFAULT NULL,
    cyear prospect.cyear%TYPE DEFAULT NULL,
    color prospect.color%TYPE DEFAULT NULL,
    trim  prospect.trim%TYPE  DEFAULT NULL,
    ocode prospect.ocode%TYPE DEFAULT NULL
)
RETURN SMALLINT
AS

    v_count SMALLINT;
BEGIN
    
    IF UPPER(RTRIM(make)) NOT IN('ACURA', 'LAND ROVER', 'MERCEDES', 'JAGUAR')
      THEN

        RETURN -3;
    END IF;
        
    SELECT COUNT(*)
        INTO v_count
        FROM options o
        WHERE o.ocode = ocode;
        
    IF v_count = 0
        THEN
            
            RETURN -4;
    END IF;
        
  INSERT INTO prospect p (
       p.cname,
       p.make,
       p.model,
       p.cyear,
       p.color,
       p.trim,
       p.ocode
   )
  VALUES (
     cname,
     make,
     model,
     cyear,
     color,
     trim,
     ocode
  );
                    
  RETURN 0;
EXCEPTION

    WHEN OTHERS
        THEN

            RETURN -1;
END;
/

/** OUTPUT:
 * Function NEW_PROSPECT compiled
 *
 **/
