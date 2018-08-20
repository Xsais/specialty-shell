/*
 *
 * File: Function.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 8, 2018
 * Task: File is used to list all of the used function isn the project
 *
 */

-- Create a function that takes a string and the line size and then makes the string center to the page
CREATE OR REPLACE FUNCTION centerString (
	v_inputStr IN VARCHAR2,
	v_lineSize IN INT
)
RETURN VARCHAR2
AS
formatted VARCHAR2(255);
BEGIN
	-- Left pad the string to be centered
	formatted := LPAD(v_inputStr, (ROUND(((v_lineSize - ROUND((LENGTH(v_inputStr) / 2), 0)) / 2), 0) + LENGTH(v_inputStr)));

	-- Return the fornated string
	RETURN formatted;
END;
/