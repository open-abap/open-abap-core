CLASS lcl_in DEFINITION.
  PUBLIC SECTION.
    METHODS constructor IMPORTING codepage TYPE clike.
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
    METHODS constructor IMPORTING codepage TYPE clike.
    INTERFACES if_abap_conv_out.
  PRIVATE SECTION.
    DATA mv_encoding TYPE abap_encoding.
ENDCLASS.

CLASS lcl_out IMPLEMENTATION.
  METHOD constructor.
    mv_encoding = codepage.
  ENDMETHOD.

  METHOD if_abap_conv_out~convert.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
* ISO-8859-1 has a byte for U+0000 to U+00FF only
    IF mv_encoding = 'ISO-8859-1'.
      FIND PCRE '[^\x00-\xFF]' IN source.
      IF sy-subrc = 0.
        RAISE EXCEPTION TYPE cx_sy_conversion_codepage.
      ENDIF.
    ENDIF.
    conv = cl_abap_conv_out_ce=>create( encoding = mv_encoding ).
    conv->convert(
      EXPORTING
        data   = source
      IMPORTING
        buffer = result ).
  ENDMETHOD.
ENDCLASS.