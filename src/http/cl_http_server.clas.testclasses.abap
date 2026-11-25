CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_location FOR TESTING RAISING cx_static_check.
    METHODS escape_url FOR TESTING RAISING cx_static_check.
    METHODS unescape_url FOR TESTING RAISING cx_static_check.
    METHODS escape_html FOR TESTING RAISING cx_static_check.
    METHODS base64 FOR TESTING RAISING cx_static_check.
    METHODS append_field_url FOR TESTING RAISING cx_static_check.
    METHODS keeps_utility_error FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_location.

    DATA lv_host TYPE string.

    cl_http_server=>get_location( IMPORTING host = lv_host ).

    cl_abap_unit_assert=>assert_not_initial( lv_host ).

  ENDMETHOD.

  METHOD escape_url.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_server=>if_http_server~escape_url( `a b/~(x)` )
      exp = `a%20b%2f%7e(x)` ).
  ENDMETHOD.

  METHOD unescape_url.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_server=>if_http_server~unescape_url( `%41+%42%20%C3%A4` )
      exp = |A B { cl_abap_conv_in_ce=>uccp( '00E4' ) }| ).
* a failure gives an empty result
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_server=>if_http_server~unescape_url( `x%g1` )
      exp = `` ).
  ENDMETHOD.

  METHOD escape_html.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_server=>if_http_server~escape_html( `<a href="x">'Q&A'</a>` )
      exp = `&lt;a href=&quot;x&quot;&gt;&#39;Q&amp;A&#39;&lt;/a&gt;` ).
  ENDMETHOD.

  METHOD base64.
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_server=>if_http_server~encode_base64( |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }b| )
      exp = `5GI=` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_server=>if_http_server~decode_base64( `5GI=` )
      exp = |{ cl_abap_conv_in_ce=>uccp( '00E4' ) }b| ).
  ENDMETHOD.

  METHOD append_field_url.
    DATA lv_url TYPE string.

    cl_http_server=>append_field_url(
      EXPORTING
        name  = `a`
        value = `1`
      CHANGING
        url   = lv_url ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_url
      exp = `?a=1` ).

    lv_url = `/p`.
    cl_http_server=>append_field_url(
      EXPORTING
        name  = `a b`
        value = |x&y={ cl_abap_conv_in_ce=>uccp( '00E9' ) } /|
      CHANGING
        url   = lv_url ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_url
      exp = `/p?a%20b=x%26y%3d%c3%a9%20%2f` ).

    lv_url = `/p?a=1`.
    cl_http_server=>append_field_url(
      EXPORTING
        name  = `b`
        value = `2`
      CHANGING
        url   = lv_url ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_url
      exp = `/p?a=1&b=2` ).

    lv_url = `/p?`.
    cl_http_server=>append_field_url(
      EXPORTING
        name  = `b`
        value = `2`
      CHANGING
        url   = lv_url ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_url
      exp = `/p?&b=2` ).

* a fragment is not taken into account
    lv_url = `/p#f`.
    cl_http_server=>append_field_url(
      EXPORTING
        name  = `b`
        value = ``
      CHANGING
        url   = lv_url ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_url
      exp = `/p#f?b=` ).
  ENDMETHOD.

  METHOD keeps_utility_error.
    DATA lv_result TYPE string.

    lv_result = cl_http_utility=>unescape_url( `%zz` ).
    lv_result = cl_http_server=>if_http_server~escape_url( `a` ).
    lv_result = cl_http_server=>if_http_server~unescape_url( `a` ).
    lv_result = cl_http_server=>if_http_server~escape_html( `a` ).
    lv_result = cl_http_server=>if_http_server~encode_base64( `a` ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_http_utility=>get_last_error( )
      exp = 3 ).
  ENDMETHOD.

ENDCLASS.
