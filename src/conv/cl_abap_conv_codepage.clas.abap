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
    DATA lv_codepage TYPE string.
    lv_codepage = to_upper( codepage ).
    CASE lv_codepage.
      WHEN 'UTF-8' OR 'UTF-16' OR 'UTF-16LE' OR 'UTF-16BE' OR 'ISO-8859-1' OR '4103'.
        CREATE OBJECT instance TYPE lcl_in EXPORTING codepage = lv_codepage.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE cx_parameter_invalid_range.
    ENDCASE.
  ENDMETHOD.

  METHOD create_out.
    DATA lv_codepage TYPE string.
    lv_codepage = to_upper( codepage ).
    CASE lv_codepage.
      WHEN 'UTF-8' OR 'UTF-16LE' OR 'ISO-8859-1' OR '4103'.
        CREATE OBJECT instance TYPE lcl_out EXPORTING codepage = lv_codepage.
      WHEN OTHERS.
        RAISE EXCEPTION TYPE cx_parameter_invalid_range.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.