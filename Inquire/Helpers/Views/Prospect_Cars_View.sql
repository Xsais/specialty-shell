/*
 *
 * File: Prospect_Cars_View.sql
 * Developer: James Grau
 * Student Number: 991443203
 * Date: August 7, 2018
 * Task: File is used to create the prospect View that shows the prospect table without the options code
 *
 */

-- Create a view to hold the prospectCustomerCars
CREATE OR REPLACE VIEW prospectCustomerCars AS
	SELECT DISTINCT cname, make, model, cyear, color, trim
	  FROM prospect;