CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS decode_x_base64 FOR TESTING.
    METHODS unescape_url FOR TESTING.
    METHODS encode_base64 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD decode_x_base64.

    DATA decoded TYPE xstring.

    decoded = cl_http_utility=>decode_x_base64( 'YWJhcA==' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = '61626170' ).

  ENDMETHOD.

  METHOD unescape_url.

    DATA decoded TYPE xstring.

    decoded = cl_http_utility=>unescape_url( '%27' ).

    cl_abap_unit_assert=>assert_equals(
      act = decoded
      exp = |'| ).

  ENDMETHOD.

  METHOD encode_base64.

    DATA encoded TYPE xstring.

    encoded = cl_http_utility=>encode_base64( 'opensesame' ).

    cl_abap_unit_assert=>assert_equals(
      act = encoded
      exp = |b3BlbnNlc2FtZQ==| ).

  ENDMETHOD.

ENDCLASS.