CLASS ltcl_conv_in DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS test2 FOR TESTING RAISING cx_static_check.
    METHODS test3 FOR TESTING RAISING cx_static_check.
    METHODS empty FOR TESTING RAISING cx_static_check.
    METHODS utf16le FOR TESTING RAISING cx_static_check.
    METHODS uccpi_50 FOR TESTING RAISING cx_static_check.
    METHODS uccp_31 FOR TESTING RAISING cx_static_check.
    METHODS uccp_ok FOR TESTING RAISING cx_static_check.
    METHODS uccp_identity FOR TESTING RAISING cx_static_check.
    METHODS invalid_utf8 FOR TESTING RAISING cx_static_check.
    METHODS invalid_utf8_ignore FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_conv_in IMPLEMENTATION.

  METHOD uccp_ok.
    cl_abap_conv_in_ce=>uccp( 'D83E' ).
    cl_abap_conv_in_ce=>uccp( 'DD14' ).
  ENDMETHOD.

  METHOD uccpi_50.
    DATA str TYPE string.
    str = cl_abap_conv_in_ce=>uccpi( 50 ).
    cl_abap_unit_assert=>assert_equals(
      act = str
      exp = '2' ).
  ENDMETHOD.

  METHOD uccp_31.
    DATA str TYPE string.
    str = cl_abap_conv_in_ce=>uccp( '0031' ).
    cl_abap_unit_assert=>assert_equals(
      act = str
      exp = '1' ).
  ENDMETHOD.

  METHOD uccp_identity.
    DATA val1 TYPE c LENGTH 2.
    DATA val2 TYPE c LENGTH 2.
    val1 = cl_abap_conv_in_ce=>uccp( '0000' ).
    val2 = cl_abap_conv_in_ce=>uccpi( 0 ).
    ASSERT val1 = val2.
  ENDMETHOD.

  METHOD invalid_utf8.
    DATA lv_data TYPE xstring.
    DATA rv_string TYPE string.
    lv_data = 'F8FF00'.
    TRY.
        cl_abap_conv_in_ce=>create( encoding = 'UTF-8' )->convert(
          EXPORTING
            input = lv_data
            n     = xstrlen( lv_data )
          IMPORTING
            data  = rv_string ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_conversion_codepage.
    ENDTRY.
  ENDMETHOD.

  METHOD invalid_utf8_ignore.
    DATA lv_data TYPE xstring.
    DATA rv_string TYPE string.
    lv_data = 'F8FF00'.
    cl_abap_conv_in_ce=>create(
      encoding    = 'UTF-8'
      ignore_cerr = abap_true )->convert(
          EXPORTING
            input = lv_data
            n     = xstrlen( lv_data )
          IMPORTING
            data  = rv_string ).
  ENDMETHOD.

  METHOD test1.
    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    DATA data TYPE string.
    conv = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' ).
    conv->convert(
      EXPORTING input = '616263'
      IMPORTING data = data ).
    cl_abap_unit_assert=>assert_equals(
      act = data
      exp = 'abc' ).
  ENDMETHOD.

  METHOD test2.

    DATA lv_xstring TYPE xstring.
    DATA lv_len TYPE i.
    DATA lo_obj TYPE REF TO cl_abap_conv_in_ce.
    DATA lv_string TYPE string.

    lv_xstring = '30303334'.

    lo_obj = cl_abap_conv_in_ce=>create(
        input    = lv_xstring
        encoding = 'UTF-8' ).
    lv_len = xstrlen( lv_xstring ).

    TRY.
        lo_obj->read( EXPORTING n    = lv_len
                      IMPORTING data = lv_string ).
      CATCH cx_sy_conversion_codepage.
        cl_abap_unit_assert=>fail( 'unexpected' ).
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = lv_string
      exp = '0034' ).

  ENDMETHOD.

  METHOD test3.

    DATA lv_hex TYPE xstring.
    DATA lv_str TYPE string.
    DATA lo_conv TYPE REF TO cl_abap_conv_in_ce.

    lv_hex = '6162'.
    lo_conv = cl_abap_conv_in_ce=>create( ).
    lo_conv->convert( EXPORTING input = lv_hex IMPORTING data = lv_str ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_str
      exp = 'ab' ).

  ENDMETHOD.

  METHOD empty.

    DATA conv TYPE REF TO cl_abap_conv_in_ce.
    DATA data TYPE string.
    DATA input TYPE xstring.
    conv = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' ).
    conv->convert(
      EXPORTING input = input
      IMPORTING data = data ).
    cl_abap_unit_assert=>assert_initial( data ).

  ENDMETHOD.

  METHOD utf16le.

    DATA lv_hex TYPE xstring.
    DATA lv_str TYPE string.
    DATA lo_conv TYPE REF TO cl_abap_conv_in_ce.

    lv_hex = '680065006C006C006F00200077006F0072006C006400'.
    lo_conv = cl_abap_conv_in_ce=>create( encoding = '4103' ).
    lo_conv->convert( EXPORTING input = lv_hex IMPORTING data = lv_str ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_str
      exp = 'hello world' ).

  ENDMETHOD.

ENDCLASS.