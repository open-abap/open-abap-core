CLASS ltcl_conv_in DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING.

ENDCLASS.

CLASS ltcl_conv_in IMPLEMENTATION.

  METHOD test1.
    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_in_ce=>create( 'UTF-8' ).
    conv->convert(
      EXPORTING input = '616263'
      IMPORTING data = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = 'abc' ).
  ENDMETHOD.

ENDCLASS.