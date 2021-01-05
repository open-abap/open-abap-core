CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_get FOR TESTING.
    METHODS basic_auth FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic_get.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://httpbin.org/get'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->send( ).
    li_client->receive( ).

    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

    lv_cdata = li_client->response->get_cdata( ).
    cl_abap_unit_assert=>assert_not_initial( lv_cdata ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '*headers*' ).

  ENDMETHOD.

  METHOD basic_auth.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://httpbin.org/basic-auth/sdf/sdf'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).

    li_client->authenticate( username = 'sdf' password = 'sdf' ).
    li_client->send( ).
    li_client->receive( ).

    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

  ENDMETHOD.

ENDCLASS.