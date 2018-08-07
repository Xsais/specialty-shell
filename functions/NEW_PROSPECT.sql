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
    model prospect.model%TYPE,
    cyear prospect.cyear%TYPE,
    color prospect.color%TYPE,
    trim  prospect.trim%TYPE,
    ocode prospect.ocode%TYPE
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
     cname,
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
