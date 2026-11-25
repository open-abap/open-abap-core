CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS base64_latin1 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD base64_latin1.
    cl_abap_unit_assert=>assert_equals(
      act = cl_web_http_utility=>encode_base64( |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }b| )
      exp = `5GI=` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_web_http_utility=>decode_base64( `5GI=` )
      exp = |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }b| ).
  ENDMETHOD.

  METHOD unescape_url.
    cl_abap_unit_assert=>assert_equals(
      act = cl_web_http_utility=>unescape_url( `a+b%2Bc%20` )
      exp = `a b+c ` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_web_http_utility=>unescape_url( `x%g1` )
      exp = `` ).
  ENDMETHOD.

ENDCLASS.
