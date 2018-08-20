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

CREATE OR REPLACE PROCEDURE NEW_SALE
(
	errorcode OUT SMALLINT,
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
AS

    v_count NUMBER;
  	v_serdate DATE := TO_DATE(csaledate, 'YYYY-MM-DD');
BEGIN

  IF saleinv IS NULL
  THEN

	errorcode := -21;
	RETURN;
  END IF;

  IF ccname IS NULL
  THEN

	errorcode := -22;
	RETURN;
  END IF;

  IF csalesman IS NULL
  THEN

	errorcode := -23;
	RETURN;
  END IF;

  IF csaledate IS NULL
  THEN

	errorcode := -24;
	RETURN;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = cserial
	AND c.cname IS NULL;

  IF cserial IS NULL OR v_count = 0
  THEN

	errorcode := -12;
	RETURN;
  END IF;

  IF totalprice IS NOT NULL AND totalprice < 0
    THEN

        errorcode := -3;
	  RETURN;
    END IF;

   IF discount IS NOT NULL AND discount < 0
    THEN

        errorcode := -4;
	  RETURN;
    END IF;

   IF licfee IS NOT NULL AND licfee < 0
    THEN

        errorcode := -5;
	  RETURN;
    END IF;

   IF commission IS NOT NULL AND commission < 0
    THEN

        errorcode := -6;
	  RETURN;
    END IF;

   IF tradeallow IS NOT NULL AND tradeallow < 0
    THEN

        errorcode := -7;
	  RETURN;
    END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM customer c
  WHERE c.cname = ccname;

  IF v_count = 0
  THEN

	errorcode := -13;
	RETURN;
  END IF;

  SELECT COUNT(*)
	  INTO v_count
  FROM employee e
  WHERE e.empname = csalesman;

  IF v_count = 0
  THEN

	errorcode := -14;
	RETURN;
  END IF;

  IF v_serdate > SYSDATE OR csaledate < '1885/01/01'
  THEN

	errorcode := -15;
	RETURN;
  END IF;

  IF ctradeserial IS NOT NULL
	THEN
  SELECT COUNT(*)
	  INTO v_count
  FROM car c
  WHERE c.serial = ctradeserial;

  IF v_count = 0
  THEN

	errorcode := -16;
	RETURN;
  END IF;
	  END IF;

  IF fire IS NOT NULL AND UPPER(fire) NOT IN ('Y', 'N')
  THEN

	errorcode := -17;
	RETURN;
  END IF;

  IF collision IS NOT NULL AND UPPER(collision) NOT IN ('Y', 'N')
  THEN

	errorcode := -18;
	RETURN;
  END IF;

  IF liability IS NOT NULL AND UPPER(liability) NOT IN ('Y', 'N')
  THEN

	errorcode := -19;
	RETURN;
  END IF;

  IF property IS NOT NULL AND UPPER(property) NOT IN ('Y', 'N')
  THEN

	errorcode := -20;
	RETURN;
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

  errorcode := 0;
EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

         errorcode := -2;
     WHEN OTHERS THEN

    	 errorcode := -1;
END;
/
/** OUTPUT:
 * Function NEW_SALE compiled
 *
 **/