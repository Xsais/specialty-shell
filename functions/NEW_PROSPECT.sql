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
    ccname prospect.cname%TYPE,
    make  prospect.make%TYPE,
    model prospect.model%TYPE DEFAULT NULL,
    cyear prospect.cyear%TYPE DEFAULT NULL,
    color prospect.color%TYPE DEFAULT NULL,
    trim  prospect.trim%TYPE  DEFAULT NULL,
    ocode prospect.ocode%TYPE DEFAULT NULL
)
RETURN BOOLEAN
AS
BEGIN
    
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
     ccname,
     make,
     model,
     cyear,
     color,
     trim,
     ocode
  );
                    
  RETURN TRUE;
EXCEPTION

    WHEN OTHERS
        THEN
            
            RETURN FALSE;
END;
/

/** OUTPUT:
 * Function NEW_PROSPECT compiled
 *
 **/
