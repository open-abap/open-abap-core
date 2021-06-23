CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS decode_x_base64 FOR TESTING RAISING cx_static_check.
    METHODS encode_x_base64 FOR TESTING RAISING cx_static_check.
    METHODS unescape_url FOR TESTING RAISING cx_static_check.
    METHODS encode_base64 FOR TESTING RAISING cx_static_check.
    METHODS fields_identity01 FOR TESTING RAISING cx_static_check.
    METHODS fields_identity02 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD fields_identity01.

    DATA lv_input TYPE string.
    DATA lv_output TYPE string.

    lv_input = 'moo=42'.

    lv_output = cl_http_utility=>fields_to_string( cl_http_utility=>string_to_fields( lv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = lv_input ).

  ENDMETHOD.

  METHOD fields_identity02.

    DATA lv_input TYPE string.
    DATA lv_output TYPE string.

    lv_input = 'moo=42&bar=a'.

    lv_output = cl_http_utility=>fields_to_string( cl_http_utility=>string_to_fields( lv_input ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = lv_input ).

  ENDMETHOD.

  METHOD decode_x_base64.

    DATA decoded TYPE xstring.

    decoded = cl_http_utility=>decode_x_base64( 'YWJhcA==' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = '61626170' ).

  ENDMETHOD.

  METHOD unescape_url.

    DATA decoded TYPE string.

    decoded = cl_http_utility=>unescape_url( '%27' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = |'| ).

  ENDMETHOD.

  METHOD encode_base64.

    DATA encoded TYPE string.

    encoded = cl_http_utility=>encode_base64( 'opensesame' ).

    cl_abap_unit_assert=>assert_equals(
      act = encoded
      exp = |b3BlbnNlc2FtZQ==| ).

  ENDMETHOD.

  METHOD encode_x_base64.

    DATA encoded TYPE string.

    encoded = cl_http_utility=>encode_x_base64( '61626170' ).

    cl_abap_unit_assert=>assert_equals(
      act = encoded
      exp = 'YWJhcA==' ).    

  ENDMETHOD.

ENDCLASS.