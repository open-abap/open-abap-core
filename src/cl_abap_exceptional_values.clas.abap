CLASS cl_abap_exceptional_values DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_max_value
      IMPORTING
        in TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.

    CLASS-METHODS get_min_value
      IMPORTING
        in TYPE any
      RETURNING
        VALUE(out) TYPE REF TO data.
ENDCLASS.

CLASS cl_abap_exceptional_values IMPLEMENTATION.

  METHOD get_max_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_min_value.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.