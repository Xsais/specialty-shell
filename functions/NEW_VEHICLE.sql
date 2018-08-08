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

CREATE OR REPLACE FUNCTION NEW_VEHICLE
(
    serial     car.serial%TYPE,
    make       car.make%TYPE,
    model      car.model%TYPE,
    cyear      car.cyear%TYPE,
    color      car.color%TYPE,
    trim       car.trim%TYPE,
    enginetype car.enginetype%TYPE,
    cname      car.cname%TYPE        DEFAULT NULL,
    purchinv   car.purchinv%TYPE     DEFAULT NULL,
    purchdate  car.purchdate%TYPE    DEFAULT NULL,
    purchfrom  car.purchfrom%TYPE    DEFAULT NULL,
    purchcost  car.purchcost%TYPE    DEFAULT 0,
    freightcost car.freightcost%TYPE DEFAULT 0,
    listprice  car.listprice%TYPE    DEFAULT 0
)
RETURN SMALLINT
AS
BEGIN

   IF purchcost < 0
    THEN
        
        RETURN -3;
    END IF;

   IF freightcost < 0
    THEN
        
        RETURN -4;
    END IF;

   IF listprice < 0
    THEN
        
        RETURN -5;
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
            cname,
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
  RETURN 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
             RETURN -2;

    WHEN OTHERS THEN
             RETURN -1;
END;
/

/** OUTPUT:
 * Function NEW_VEHICLE compiled
 *
 **/
