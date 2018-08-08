/*
 *
 * * Name: Nathaniel Primo (991455464)
 * * File: NEW_SALE.sql
 * * Creation Date: 2018/08/08
 * * Last Modified: 201808/08
 * * Assignment: Final Assignment
 * * Course: DBAS32100 - 1185_45509
 * * Description: Adds a new sale invoice tto the database
*/

CREATE OR REPLACE FUNCTION NEW_SALE
(
    saleinv     saleinv.saleinv%TYPE,
    cname       saleinv.cname%TYPE,
    salesman    saleinv.salesman%TYPE,
    saledate    saleinv.saledate%TYPE,
    serial      saleinv.serial%TYPE,
    totalprice  saleinv.totalprice%TYPE,
    discount    saleinv.discount%TYPE,
    licfee      saleinv.licfee%TYPE,
    commission  saleinv.commission%TYPE,
    tradeserial saleinv.tradeserial%TYPE,
    tradeallow  saleinv.tradeallow%TYPE,
    fire        saleinv.fire%TYPE,
    collision   saleinv.collision%TYPE,
    liability   saleinv.liability%TYPE,
    property    saleinv.property%TYPE
)
RETURN SMALLINT
AS
BEGIN

   IF totalprice < 0
    THEN

        RETURN -3;
    END IF;
    
   IF discount < 0
    THEN

        RETURN -4;
    END IF;
    
   IF licfee < 0
    THEN

        RETURN -5;
    END IF;
    
   IF commission < 0
    THEN

        RETURN -6;
    END IF;
    
   IF tradeallow < 0
    THEN

        RETURN -7;
    END IF;
    
   IF NOT REGEXP_LIKE(fire, 'yes|no')
    THEN

        RETURN -8;
    END IF;
    
   IF NOT REGEXP_LIKE(collision, 'yes|no')
    THEN

        RETURN -9;
    END IF;
    
   IF NOT REGEXP_LIKE(liability, 'yes|no')
    THEN

        RETURN -10;
    END IF;
    
   IF NOT REGEXP_LIKE(property, 'yes|no')
    THEN

        RETURN -11;
    END IF;
        
   IF v_ownedCount != 0
        THEN
        
            RETURN -12;
    END IF;

   INSERT INTO saleinv s (
  	     s.saleinv,
  	     s.cname,
  	     s.salesman,
  	     s.saledate,
  	     s.serial,
  	     s.totalprice,
  	     s.discount,
  	     s.net,
  	     s.tax,
  	     s.licfee,
  	     s.commission,
  	     s.tradeserial,
  	     s.tradeallow,
  	     s.fire,
  	     s.collision,
  	     s.liability,
  	     s.property
  	 )
  	VALUES (
  	  saleinv,
  	  cname,
  	  salesman,
  	  saledate,
  	  serial,
  	  totalprice,
  	  discount,
  	  totalprice - discount,
      0.13 * (totalprice - discount),
  	  licfee,
  	  commission,
  	  tradeserial,
  	  tradeallow,
  	  fire,
  	  collision,
  	  liability,
  	  property
  	);
    
    UPDATE car c
        SET c.cname = cname
        WHERE c.serial = serial;
  
  RETURN 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

         RETURN -2;
    WHEN OTHERS THEN

    	RETURN -1;
END;
/
/** OUTPUT:
 * Function NEW_SALE compiled
 *
 **/