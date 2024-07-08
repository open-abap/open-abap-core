CLASS cl_abap_conv_codepage DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS create_in
      IMPORTING
        codepage        TYPE string DEFAULT 'UTF-8'
      RETURNING
        VALUE(instance) TYPE REF TO if_abap_conv_in
      RAISING
        cx_parameter_invalid_range.

    CLASS-METHODS create_out
      IMPORTING
        codepage        TYPE string DEFAULT 'UTF-8'
      RETURNING
        VALUE(instance) TYPE REF TO if_abap_conv_out
      RAISING
        cx_parameter_invalid_range.

ENDCLASS.

CLASS cl_abap_conv_codepage IMPLEMENTATION.

  METHOD create_in.
    CREATE OBJECT instance TYPE lcl_in EXPORTING codepage = codepage.
  ENDMETHOD.

  METHOD create_out.
    CREATE OBJECT instance TYPE lcl_out EXPORTING codepage = codepage.
  ENDMETHOD.

ENDCLASS.