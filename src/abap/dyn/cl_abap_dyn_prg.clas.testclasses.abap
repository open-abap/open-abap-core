CLASS ltcl_dyn_prg DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS escape_quotes1 FOR TESTING RAISING cx_static_check.
    METHODS escape_quotes_str1 FOR TESTING RAISING cx_static_check.
    METHODS escape_xss_url_simple FOR TESTING RAISING cx_static_check.
    METHODS escape_xss_url_special FOR TESTING RAISING cx_static_check.
    METHODS escape_xss_url_script FOR TESTING RAISING cx_static_check.
    METHODS escape_xss_url_empty FOR TESTING RAISING cx_static_check.
    METHODS quote_simple FOR TESTING RAISING cx_static_check.
    METHODS quote_with_quotes FOR TESTING RAISING cx_static_check.
    METHODS quote_empty FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_dyn_prg IMPLEMENTATION.
  METHOD escape_quotes_str1.
    cl_abap_unit_assert=>assert_equals(
      act  = cl_abap_dyn_prg=>escape_quotes_str( 'hello ` world' )
      exp = 'hello `` world' ).
  ENDMETHOD.

  METHOD escape_quotes1.

    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>escape_quotes( `hello ' world` )
      exp = `hello '' world` ).

  ENDMETHOD.

  METHOD escape_xss_url_simple.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>escape_xss_url( 'hello' )
      exp = 'hello' ).
  ENDMETHOD.

  METHOD escape_xss_url_special.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>escape_xss_url( 'a<b>c"d' )
      exp = 'a%3Cb%3Ec%22d' ).
  ENDMETHOD.

  METHOD escape_xss_url_script.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>escape_xss_url( '<script>alert(1)</script>' )
      exp = '%3cscript%3ealert%281%29%3c%2fscript%3e' ).
  ENDMETHOD.

  METHOD escape_xss_url_empty.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>escape_xss_url( '' )
      exp = '' ).
  ENDMETHOD.

  METHOD quote_simple.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>quote( 'hello' )
      exp = `'hello'` ).
  ENDMETHOD.

  METHOD quote_with_quotes.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>quote( `it's a test` )
      exp = `'it''s a test'` ).
  ENDMETHOD.

  METHOD quote_empty.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_dyn_prg=>quote( '' )
      exp = `''` ).
  ENDMETHOD.

ENDCLASS.