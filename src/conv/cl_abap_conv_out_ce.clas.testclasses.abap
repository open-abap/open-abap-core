CLASS ltcl_conv_out DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS convert1 FOR TESTING RAISING cx_static_check.
    METHODS convert_space FOR TESTING RAISING cx_static_check.
    METHODS convert_empty FOR TESTING RAISING cx_static_check.
    METHODS upper FOR TESTING RAISING cx_static_check.
    METHODS empty FOR TESTING RAISING cx_static_check.
    METHODS utf16le FOR TESTING RAISING cx_static_check.
    METHODS uccpi_2 FOR TESTING RAISING cx_static_check.
    METHODS buffer FOR TESTING RAISING cx_static_check.
    METHODS uccp1 FOR TESTING RAISING cx_static_check.
    METHODS uccp2 FOR TESTING RAISING cx_static_check.
    METHODS uccp3 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_conv_out IMPLEMENTATION.

  METHOD uccpi_2.
    DATA lv_int TYPE i.
    lv_int = cl_abap_conv_out_ce=>uccpi( '2' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_int
      exp = 50 ).
  ENDMETHOD.

  METHOD convert1.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
    conv->convert( EXPORTING data   = 'abc'
                   IMPORTING buffer = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = '616263' ).
  ENDMETHOD.

  METHOD convert_space.
    DATA lv_char TYPE c LENGTH 1.
    DATA xstr    TYPE xstring.
    DATA lo_obj  TYPE REF TO cl_abap_conv_out_ce.
    lo_obj = cl_abap_conv_out_ce=>create( encoding = '4103' ).

    lo_obj->convert( EXPORTING data = lv_char
                     IMPORTING buffer = xstr ).

    cl_abap_unit_assert=>assert_equals(
      act = xstr
      exp = '2000' ).
  ENDMETHOD.

  METHOD convert_empty.
    DATA lv_empty TYPE string.
    DATA xstr     TYPE xstring.
    DATA lo_obj   TYPE REF TO cl_abap_conv_out_ce.
    lo_obj = cl_abap_conv_out_ce=>create( encoding = '4103' ).

    lo_obj->convert( EXPORTING data = lv_empty
                     IMPORTING buffer = xstr ).

    cl_abap_unit_assert=>assert_equals(
      act = xstr
      exp = '' ).
  ENDMETHOD.

  METHOD upper.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
    conv->convert( EXPORTING data   = 'hello world'
                   IMPORTING buffer = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = '68656C6C6F20776F726C64' ).
  ENDMETHOD.

  METHOD empty.
    DATA conv   TYPE REF TO cl_abap_conv_out_ce.
    DATA data   TYPE string.
    DATA buffer TYPE xstring.
    conv = cl_abap_conv_out_ce=>create( encoding = 'UTF-8' ).
    conv->convert( EXPORTING data   = data
                   IMPORTING buffer = buffer ).
    cl_abap_unit_assert=>assert_initial( buffer ).
  ENDMETHOD.

  METHOD utf16le.
    DATA lo_obj    TYPE REF TO cl_abap_conv_out_ce.
    DATA lv_string TYPE string.
    DATA lv_xstr   TYPE xstring.
    lv_string = 'hello world'.
    lo_obj = cl_abap_conv_out_ce=>create( encoding = '4103' ).
    lo_obj->convert( EXPORTING data = lv_string
                     IMPORTING buffer = lv_xstr ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_xstr
      exp = '680065006C006C006F00200077006F0072006C006400' ).
  ENDMETHOD.

  METHOD buffer.
    DATA conv TYPE REF TO cl_abap_conv_out_ce.
    DATA buffer TYPE xstring.
    conv = cl_abap_conv_out_ce=>create( ).
    conv->write( 'hi' ).
    conv->write( 'hi' ).
    buffer = conv->get_buffer( ).
    cl_abap_unit_assert=>assert_equals(
      act = buffer
      exp = '68696869' ).
    conv->reset( ).
    buffer = conv->get_buffer( ).
    cl_abap_unit_assert=>assert_equals(
      act = buffer
      exp = '' ).
  ENDMETHOD.

  METHOD uccp1.
    DATA lv_hex TYPE x LENGTH 2.
    lv_hex = cl_abap_conv_out_ce=>uccp( 'a' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0061' ).
  ENDMETHOD.

  METHOD uccp2.
    DATA lv_hex TYPE x LENGTH 2.
    lv_hex = cl_abap_conv_out_ce=>uccp( 'ab' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0061' ).
  ENDMETHOD.

  METHOD uccp3.
    DATA lv_hex TYPE x LENGTH 2.
    lv_hex = cl_abap_conv_out_ce=>uccp( '' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_hex
      exp = '0020' ).
  ENDMETHOD.

ENDCLASS.