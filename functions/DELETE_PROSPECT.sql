/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: DELETE_PROSPECT.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Remove prospect from the database
*/

CREATE OR REPLACE PROCEDURE NEW_VEHICLE
  (
  	v_errorCode OUT SMALLINT,
	ccname prospect.cname%TYPE
  )
AS
	v_count SMALLINT;
  BEGIN

	SELECT COUNT(*)
		INTO v_count
		FROM customer c
			WHERE UPPER(c.cname) = UPPER(ccname);

	IF v_count != 1
		THEN

		v_errorCode := -3;
		RETURN;
	END IF;

	SELECT COUNT(*)
		INTO v_count
		FROM prospect p
			WHERE UPPER(p.cname) = UPPER(ccname);

	IF v_count != 0
		THEN

		v_errorCode := -2;
		RETURN;
	END IF;

	DELETE FROM prospect p
		WHERE UPPER(p.cname) = UPPER(ccname);

v_errorCode := 0;
	EXCEPTION

		WHEN OTHERS
			THEN

				v_errorCode := -1;
  END;
/