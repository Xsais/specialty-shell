CREATE OR REPLACE VIEW prospectCustomerCars AS
	SELECT DISTINCT cname, make, model, cyear, color, trim
	  FROM prospect;
