CREATE OR REPLACE FUNCTION centerString (
	v_inputStr IN VARCHAR2,
	v_lineSize IN INT
)
RETURN VARCHAR2
AS
formatted VARCHAR2(255);
BEGIN
	formatted := LPAD(v_inputStr, (ROUND(((v_lineSize - ROUND((LENGTH(v_inputStr) / 2), 0)) / 2), 0) + LENGTH(v_inputStr)));
	RETURN formatted;
END;
/
