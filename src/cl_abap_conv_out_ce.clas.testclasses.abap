CLASS ltcl_conv_out DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.
    METHODS upper FOR TESTING.

ENDCLASS.

CLASS ltcl_conv_out IMPLEMENTATION.

  METHOD test1.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_out_ce=>create( 'UTF-8' ).
    conv->convert( EXPORTING data   = 'abc'
                   IMPORTING buffer = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = '616263' ).
  ENDMETHOD.

  METHOD upper.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_out_ce=>create( 'UTF-8' ).
    conv->convert( EXPORTING data   = 'hello world'
                   IMPORTING buffer = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = '68656C6C6F20776F726C64' ).
  ENDMETHOD.

ENDCLASS.