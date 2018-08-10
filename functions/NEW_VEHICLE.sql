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
 	errorcode  OUT SMALLINT,
    serial     car.serial%TYPE,
    make       car.make%TYPE,
    model      car.model%TYPE,
    cyear      car.cyear%TYPE,
    color      car.color%TYPE,
    trim       car.trim%TYPE,
    enginetype car.enginetype%TYPE,
    ccname      car.cname%TYPE        DEFAULT NULL,
    purchinv   car.purchinv%TYPE     DEFAULT NULL,
    purchdate  car.purchdate%TYPE    DEFAULT NULL,
    purchfrom  car.purchfrom%TYPE    DEFAULT NULL,
    purchcost  car.purchcost%TYPE    DEFAULT 0,
    freightcost car.freightcost%TYPE DEFAULT 0,
    listprice  car.listprice%TYPE    DEFAULT 0
)
AS

  	v_count SMALLINT;
BEGIN

  IF serial IS NULL
	  THEN

		errorcode := -6;
		RETURN;
  END IF;

  IF make IS NULL
  THEN

	errorcode := -7;
	RETURN;
  END IF;

  IF make NOT IN('ACURA', 'LAND ROVER', 'MERCEDES', 'JAGUAR')
	  THEN

		errorcode := -13;
		RETURN;
  END IF;

  IF model IS NULL
  THEN

	errorcode := -8;
	RETURN;
  END IF;

  IF cyear IS NULL
  THEN

	errorcode := -9;
	RETURN;
  END IF;

  IF color IS NULL
  THEN

	errorcode := -10;
	RETURN;
  END IF;

  IF trim IS NULL
  THEN

	errorcode := -11;
	RETURN;
  END IF;

  IF enginetype IS NULL
  THEN

	errorcode := -12;
	RETURN;
  END IF;

IF ccname IS NOT NULL
  THEN
  SELECT COUNT(*)
	  INTO v_count
  FROM customer c
  WHERE UPPER(c.cname) = UPPER(ccname);

  IF v_count = 0
	THEN

		errorcode := -13;
	  RETURN;
  END IF;
	END IF;

  IF purchinv IS NOT NULL
	THEN

	  SELECT COUNT(*)
		  INTO v_count
	  FROM saleinv c
	  WHERE UPPER(c.saleinv) = UPPER(purchinv);

	  IF v_count = 0
	  THEN

		errorcode := -14;
		RETURN;
	  END IF;
  END IF;

  IF purchcost < 0
    THEN
        
        errorcode := -3;
	  RETURN;
    END IF;

   IF freightcost < 0
    THEN
        
        errorcode := -4;
	  RETURN;
    END IF;

   IF listprice < 0
    THEN
        
        errorcode := -5;
	  RETURN;
    END IF;

  INSERT INTO car c (
  		c.serial,
  		c.cname,
  		c.make,
  		c.model,
  		c.cyear,
  		c.color,
  		c.trim,
  		c.enginetype,
  		c.purchinv,
  		c.purchdate,
  		c.purchfrom,
  		c.purchcost,
  		c.freightcost,
  		c.totalcost,
  		c.listprice
  )
  VALUES (
            serial,
			ccname,
            make,
            model,
            cyear,
            color,
            trim,
            enginetype,
            purchinv,
            purchdate,
            purchfrom,
            purchcost,
            freightcost,
            purchcost + freightcost,
            listprice
  );
  errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
             errorcode := -2;

    WHEN OTHERS THEN
             errorcode := -1;
END;
/

/** OUTPUT:
 * Function NEW_VEHICLE compiled
 *
 **/
