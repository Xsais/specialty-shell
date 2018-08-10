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

CREATE OR REPLACE PROCEDURE NEW_VEHICLE
  (
	cname prospect.cname%TYPE,
	make  prospect.make%TYPE,
	model prospect.model%TYPE,
	cyear prospect.cyear%TYPE,
	color prospect.color%TYPE,
	trim  prospect.trim%TYPE,
	ocode prospect.ocode%TYPE
  )
AS

	v_errorCode OUT SMALLINT;
  BEGIN



	EXCEPTION
	
  END;
/