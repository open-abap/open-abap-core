CLASS lcl_in DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING codepage TYPE abap_encoding.
    INTERFACES if_abap_conv_in.
  PRIVATE SECTION.
    DATA mv_encoding TYPE abap_encoding.
ENDCLASS.

CLASS lcl_in IMPLEMENTATION.
  METHOD constructor.
    mv_encoding = codepage.
  ENDMETHOD.

  METHOD if_abap_conv_in~convert.
    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    conv = cl_abap_conv_in_ce=>create( encoding = mv_encoding ).
    conv->convert(
      EXPORTING
        input = source
      IMPORTING
        data  = result ).
  ENDMETHOD.
ENDCLASS.

***********************************************

CLASS lcl_out DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_conv_out.
ENDCLASS.

CLASS lcl_out IMPLEMENTATION.
  METHOD if_abap_conv_out~convert.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
    conv->convert(
      EXPORTING
        data   = source
      IMPORTING
        buffer = result ).
  ENDMETHOD.
ENDCLASS.