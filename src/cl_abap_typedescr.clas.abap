CLASS cl_abap_typedescr DEFINITION PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS
      describe_by_data
        IMPORTING data TYPE any
        RETURNING VALUE(type) TYPE REF TO cl_abap_typedescr.

ENDCLASS.

CLASS cl_abap_typedescr IMPLEMENTATION.

  METHOD describe_by_data.
  ENDMETHOD.

ENDCLASS.