CLASS cl_abap_codepage DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS convert_to
      IMPORTING input TYPE string
      RETURNING VALUE(output) TYPE xstring.
    CLASS-METHODS convert_from
      IMPORTING input TYPE xstring
      RETURNING VALUE(output) TYPE string.
ENDCLASS.

CLASS cl_abap_codepage IMPLEMENTATION.
  METHOD convert_to.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    conv = cl_abap_conv_out_ce=>create( 'UTF-8' ).
    conv->convert( EXPORTING data   = input
                   IMPORTING buffer = output ).
  ENDMETHOD.

  METHOD convert_from.
    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_in_ce=>create( 'UTF-8' ).
    conv->convert(
      EXPORTING input = input
      IMPORTING data = output ).
  ENDMETHOD.
ENDCLASS.