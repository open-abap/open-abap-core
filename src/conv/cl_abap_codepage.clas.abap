CLASS cl_abap_codepage DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS convert_to
      IMPORTING
        codepage      TYPE string OPTIONAL
        source        TYPE string
      RETURNING
        VALUE(output) TYPE xstring.

    CLASS-METHODS convert_from
      IMPORTING
        codepage      TYPE string OPTIONAL
        input TYPE xstring
      RETURNING
        VALUE(output) TYPE string.

    CLASS-METHODS sap_codepage
      IMPORTING
        encoding TYPE string
      RETURNING
        VALUE(codepage) TYPE abap_encoding.
ENDCLASS.

CLASS cl_abap_codepage IMPLEMENTATION.
  METHOD convert_to.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
    conv->convert( EXPORTING data   = source
                   IMPORTING buffer = output ).
  ENDMETHOD.

  METHOD convert_from.
    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' ).
    conv->convert(
      EXPORTING input = input
      IMPORTING data = output ).
  ENDMETHOD.

  METHOD sap_codepage.
    ASSERT encoding = 'UTF-16LE'.
    codepage = '4103'.
  ENDMETHOD.
ENDCLASS.