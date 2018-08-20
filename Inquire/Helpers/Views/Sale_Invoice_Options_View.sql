/*
 *
 * File: Sale_Invoice_Options_View.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to create the view that holds the sales invoice options
 *
 */

-- Create a view to hold sale invoice options
CREATE OR REPLACE VIEW saleInvOptions AS
	SELECT io.saleinv, io.ocode, io.saleprice, op.odesc
	  FROM invoption io
	 INNER JOIN options op
		ON io.ocode = op.ocode;