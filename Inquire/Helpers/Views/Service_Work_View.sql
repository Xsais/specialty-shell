/*
 *
 * File: Service_Work_View.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to create the view that holds service work data
 *
 */

-- Create a view to grab service work data
CREATE OR REPLACE VIEW serviceWork AS
	SELECT si.servinv, si.serdate, cu.cname, cu.cstreet, cu.ccity, cu.cpostal, cu.cbphone, cu.chphone, ca.serial, ca.make, ca.model, ca.cyear, ca.color, si.partscost, si.labourcost, si.tax
	  FROM servinv si
	 INNER JOIN customer cu
		ON si.cname = cu.cname
	 INNER JOIN car ca
		ON si.serial = ca.serial;