CLASS cl_abap_random DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        seed TYPE i OPTIONAL
      RETURNING 
        VALUE(ro_random) TYPE REF TO cl_abap_random.
    METHODS int RETURNING VALUE(rv_integer) TYPE i.
    METHODS intinrange
      IMPORTING 
        low  TYPE i
        high TYPE i
      RETURNING 
        VALUE(rv_integer) TYPE i.
    CLASS-METHODS seed RETURNING VALUE(rv_seed) TYPE i.
* todo, use "crypto." instead, see cl_abap_hmac which also uses crypto
ENDCLASS.

CLASS cl_abap_random IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ro_random.
  ENDMETHOD.

  METHOD int.
* todo, currently only positive integers are returned
    WRITE '@KERNEL rv_integer.set(Math.floor(Math.random() * 2147483647));'.
  ENDMETHOD.

  METHOD seed.
    WRITE '@KERNEL rv_seed.set(Math.floor(Math.random() * 2147483647));'.
  ENDMETHOD.

  METHOD intinrange.
* including "low" and "high" numbers
    DATA lv_interval TYPE i.
    ASSERT high > low.
    ASSERT low >= 0.
    lv_interval = high - low + 1.
    rv_integer = abs( int( ) ).
    rv_integer = rv_integer MOD lv_interval.
    rv_integer = rv_integer + low.
  ENDMETHOD.
ENDCLASS.