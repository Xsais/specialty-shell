/*
 *
 * File: Sales_Invoice_View.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 9, 2018
 * Task: File is used to create the view that holds the sales invoice data
 *
 */

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