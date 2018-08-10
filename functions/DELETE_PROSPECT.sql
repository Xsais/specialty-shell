/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: NEW_VEHICLE.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a car tto the database
*/

CREATE OR REPLACE PROCEDURE DELETE_PROSPECT
  (
  	v_errorCode OUT SMALLINT,
	ccname prospect.cname%TYPE
  )
AS
	v_count SMALLINT;
  BEGIN
  
  SELECT COUNT(*)
    INTO v_count
    FROM prospect p
    WHERE UPPER(p.cname) = UPPER(ccname);

	IF v_count < 1
		THEN

		v_errorCode := -3;
        RETURN;
	END IF;

	DELETE FROM prospect p
		WHERE UPPER(p.cname) = UPPER(ccname);
  END;
/