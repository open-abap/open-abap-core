CLASS cl_abap_random DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create RETURNING VALUE(ro_random) TYPE REF TO cl_abap_random.
    METHODS int RETURNING VALUE(rv_integer) TYPE i.
* todo, use "crypto." instead
ENDCLASS.

CLASS cl_abap_random IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ro_random.
  ENDMETHOD.

  METHOD int.
* todo, currently only positive integers are returned
    WRITE '@KERNEL rv_integer.set(Math.floor(Math.random() * 2147483647));'.
  ENDMETHOD.
ENDCLASS.