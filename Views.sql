/*
 *
 * File: Views.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to list all of the used project views
 *
 */

-- Create a view to hold the prospectCustomerCars
CREATE OR REPLACE VIEW prospectCustomerCars AS
	SELECT DISTINCT cname, make, model, cyear, color, trim
	  FROM prospect;

-- Create a view to hold sale invoice options
CREATE OR REPLACE VIEW saleInvOptions AS
	SELECT io.saleinv, io.ocode, io.saleprice, op.odesc
	  FROM invoption io
	 INNER JOIN options op
		ON io.ocode = op.ocode;
		
-- Create a view to hold sale invoice data
CREATE OR REPLACE VIEW salesInvoice AS
	SELECT si.saleinv, si.saledate, cu.cname, cu.cstreet, cu.ccity, cu.cprov, cu.cpostal, cu.chphone, si.salesman, ca.serial, ca.make, ca.model, ca.cyear, ca.color, si.fire, si.collision, si.liability, si.property, si.totalprice, si.tradeallow, si.discount, si.net, si.tax, tca.serial as trse, tca.make AS trma, tca.model AS trmo, tca.cyear AS tryr
	  FROM saleinv si
	 INNER JOIN customer cu
		ON si.cname = cu.cname
	 INNER JOIN car ca
		ON si.serial = ca.serial
	  LEFT OUTER JOIN car tca
		ON si.tradeserial = tca.serial;
		
-- Create a view to grab service work data
CREATE OR REPLACE VIEW serviceWork AS
	SELECT si.servinv, si.serdate, cu.cname, cu.cstreet, cu.ccity, cu.cpostal, cu.cbphone, cu.chphone, ca.serial, ca.make, ca.model, ca.cyear, ca.color, si.partscost, si.labourcost, si.tax
	  FROM servinv si
	 INNER JOIN customer cu
		ON si.cname = cu.cname
	 INNER JOIN car ca
		ON si.serial = ca.serial;