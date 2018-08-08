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
    ccname       saleinv.cname%TYPE,
    salesman    saleinv.salesman%TYPE,
    saledate    saleinv.saledate%TYPE,
    serial      saleinv.serial%TYPE,
    fire        saleinv.fire%TYPE        DEFAULT 'N',
    collision   saleinv.collision%TYPE   DEFAULT 'N',
    liability   saleinv.liability%TYPE   DEFAULT 'N',
    property    saleinv.property%TYPE    DEFAULT 'N',
    totalprice  saleinv.totalprice%TYPE  DEFAULT NULL,
    discount    saleinv.discount%TYPE    DEFAULT NULL,
    licfee      saleinv.licfee%TYPE      DEFAULT NULL,
    commission  saleinv.commission%TYPE  DEFAULT NULL,
    tradeserial saleinv.tradeserial%TYPE DEFAULT NULL,
    tradeallow  saleinv.tradeallow%TYPE  DEFAULT NULL
)
RETURN SMALLINT
AS

    v_ownedCount NUMBER;
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
    
   SELECT COUNT(*)
        INTO v_ownedCount
        FROM car c
        WHERE c.serial = serial
            AND c.cname != NULL;
        
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
  	  ccname,
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
        SET c.cname = ccname
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