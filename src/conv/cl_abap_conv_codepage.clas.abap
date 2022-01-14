CLASS cl_abap_conv_codepage DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS create_in
      RETURNING
        VALUE(instance) TYPE REF TO if_abap_conv_in
      RAISING
        cx_parameter_invalid_range.

    CLASS-METHODS create_out
      RETURNING
        VALUE(instance) TYPE REF TO if_abap_conv_out
      RAISING
        cx_parameter_invalid_range.

ENDCLASS.

CLASS cl_abap_conv_codepage IMPLEMENTATION.

  METHOD create_in.
    CREATE OBJECT instance TYPE lcl_in.
  ENDMETHOD.

  METHOD create_out.
    CREATE OBJECT instance TYPE lcl_out.
  ENDMETHOD.
  
ENDCLASS.