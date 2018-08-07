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