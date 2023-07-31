CLASS cl_abap_random_int DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        seed TYPE i OPTIONAL
        min  TYPE i DEFAULT -2147483648
        max  TYPE i DEFAULT 2147483647
        PREFERRED PARAMETER seed
      RETURNING
        VALUE(prng) TYPE REF TO cl_abap_random_int
      RAISING
        cx_abap_random.

    METHODS get_next
      RETURNING
        VALUE(value) TYPE i.

  PRIVATE SECTION.
    DATA mv_min TYPE i.
    DATA mv_max TYPE i.
ENDCLASS.

CLASS cl_abap_random_int IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT prng.
    prng->mv_min = min.
    prng->mv_max = max.
  ENDMETHOD.

  METHOD get_next.
    value = cl_abap_random=>create( )->intinrange(
      low  = mv_min
      high = mv_max ).
  ENDMETHOD.
ENDCLASS.