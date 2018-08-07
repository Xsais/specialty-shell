CREATE OR REPLACE FUNCTION NEW_VEHICLE
(
    serial     car.serial%TYPE,
    cname      car.cname%TYPE,
    make       car.make%TYPE,
    model      car.model%TYPE,
    cyear      car.cyear%TYPE,
    color      car.color%TYPE,
    trim       car.trim%TYPE,
    enginetype car.enginetype%TYPE,
    purchinv   car.purchinv%TYPE,
    purchdate  car.purchdate%TYPE,
    purchfrom  car.purchfrom%TYPE,
    purchcost  car.purchcost%TYPE,
    freightcost car.freightcost%TYPE,
    totalcost  car.totalcost%TYPE,
    listprice  car.listprice%TYPE
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

   IF totalcost < 0
    THEN
        
        RETURN -5;
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
            totalcost,
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
