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
    ccname      saleinv.cname%TYPE,
    csalesman    saleinv.salesman%TYPE,
    csaledate    CHAR,
    cserial      saleinv.serial%TYPE,
    totalprice  saleinv.totalprice%TYPE  DEFAULT NULL,
    discount    saleinv.discount%TYPE    DEFAULT NULL,
    licfee      saleinv.licfee%TYPE      DEFAULT NULL,
    commission  saleinv.commission%TYPE  DEFAULT NULL,
    ctradeserial saleinv.tradeserial%TYPE DEFAULT NULL,
    tradeallow  saleinv.tradeallow%TYPE  DEFAULT NULL,
	fire        saleinv.fire%TYPE        DEFAULT 'N',
	collision   saleinv.collision%TYPE   DEFAULT 'N',
	liability   saleinv.liability%TYPE   DEFAULT 'N',
	property    saleinv.property%TYPE    DEFAULT 'N'
)
RETURN SMALLINT
AS

    v_count NUMBER;
  	v_serdate DATE := TO_DATE(csaledate, 'YYYY-MM-DD');
BEGIN

  IF saleinv IS NULL
  THEN

	RETURN -21;
  END IF;

  IF ccname IS NULL
  THEN

	RETURN -22;
  END IF;

  IF csalesman IS NULL
  THEN

	RETURN -23;
  END IF;

  IF csaledate IS NULL
  THEN

	RETURN -24;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = cserial;

  DBMS_OUTPUT.PUT_LINE(v_count);

  IF cserial IS NULL OR v_count = 0
  THEN

	RETURN -12;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = cserial
	 AND cname != NULL;

  IF  v_count = 0
  THEN

	RETURN -12;
  END IF;

  IF totalprice IS NOT NULL AND totalprice < 0
    THEN

        RETURN -3;
    END IF;
    
   IF discount IS NOT NULL AND discount < 0
    THEN

        RETURN -4;
    END IF;
    
   IF licfee IS NOT NULL AND licfee < 0
    THEN

        RETURN -5;
    END IF;
    
   IF commission IS NOT NULL AND commission < 0
    THEN

        RETURN -6;
    END IF;
    
   IF tradeallow IS NOT NULL AND tradeallow < 0
    THEN

        RETURN -7;
    END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM customer c
  WHERE c.cname = ccname;

  IF v_count = 0
  THEN

	RETURN -13;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM employee e
  WHERE e.empname = csalesman;

  IF v_count = 0
  THEN

	RETURN -14;
  END IF;

  IF v_serdate > SYSDATE OR csaledate < '1885/01/01'
  THEN

	RETURN -15;
  END IF;

  IF ctradeserial IS NOT NULL
	THEN
  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = ctradeserial;

  IF v_count = 0
  THEN

	RETURN -16;
  END IF;
	  END IF;

  IF fire IS NOT NULL AND UPPER(fire) NOT IN ('Y', 'N')
  THEN

	RETURN -17;
  END IF;

  IF collision IS NOT NULL AND UPPER(collision) NOT IN ('Y', 'N')
  THEN

	RETURN -18;
  END IF;

  IF liability IS NOT NULL AND UPPER(liability) NOT IN ('Y', 'N')
  THEN

	RETURN -19;
  END IF;

  IF property IS NOT NULL AND UPPER(property) NOT IN ('Y', 'N')
  THEN

	RETURN -20;
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
  	  csalesman,
	  v_serdate,
	  cserial,
  	  totalprice,
  	  discount,
  	  totalprice - discount,
      0.13 * (totalprice - discount),
  	  licfee,
  	  commission,
  	  ctradeserial,
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