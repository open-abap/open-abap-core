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
ENDCLASS.

CLASS cl_abap_random_int IMPLEMENTATION.
  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_next.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.