CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_get FOR TESTING RAISING cx_static_check.
    METHODS basic_post FOR TESTING RAISING cx_static_check.
    METHODS basic_auth FOR TESTING RAISING cx_static_check.
    METHODS call_set_method FOR TESTING RAISING cx_static_check.
    METHODS request_header_fields FOR TESTING RAISING cx_static_check.
    METHODS default_uri FOR TESTING RAISING cx_static_check.
    METHODS query_field FOR TESTING RAISING cx_static_check.

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

  METHOD basic_post.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://httpbin.org/post'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_method( 'POST' ).
    li_client->send( ).
    li_client->receive( ).

    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

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

  METHOD call_set_method.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://sdfdsfds'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).

    li_client->request->set_method( 'GET' ).

  ENDMETHOD.

  METHOD request_header_fields.

    DATA li_client TYPE REF TO if_http_client.
    DATA fields TYPE tihttpnvp.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://dummy'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).

    ASSERT li_client->request->get_method( ) = ''.
    ASSERT li_client->request->get_header_field( 'sdfds' ) = ''.

    li_client->authenticate( username = 'sdf' password = 'sdf' ).
    ASSERT li_client->request->get_header_field( 'Authorization' ) = 'Basic c2RmOnNkZg=='.
    ASSERT li_client->request->get_header_field( 'authorizaTION' ) = 'Basic c2RmOnNkZg=='.

    li_client->request->set_header_field( name = 'FOObar' value = '42' ).

    li_client->request->get_header_fields( CHANGING fields = fields ).
    ASSERT lines( fields ) = 3.
    READ TABLE fields WITH KEY name = '~request_uri' TRANSPORTING NO FIELDS.
    ASSERT sy-subrc = 0.
    READ TABLE fields WITH KEY name = 'authorization' TRANSPORTING NO FIELDS.
    ASSERT sy-subrc = 0.
    READ TABLE fields WITH KEY name = 'foobar' TRANSPORTING NO FIELDS.
    ASSERT sy-subrc = 0.

  ENDMETHOD.

  METHOD default_uri.

    DATA li_client TYPE REF TO if_http_client.
    DATA fields TYPE tihttpnvp.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://dummy/foo.html?moo=42'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).

    ASSERT li_client->request->get_header_field( '~request_uri' ) = '/foo.html'.

    li_client->request->get_form_fields( CHANGING fields = fields ).
    ASSERT lines( fields ) = 1.

  ENDMETHOD.

  METHOD query_field.
    DATA li_client TYPE REF TO if_http_client.
    DATA lv_cdata TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://httpbin.org/get'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_form_field( name = 'foo' value = 'bar' ).
    li_client->send( ).
    li_client->receive( ).

    lv_cdata = li_client->response->get_cdata( ).
*    WRITE '@KERNEL console.dir(lv_cdata);'.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '*"foo": "bar"*' ).
  ENDMETHOD.

ENDCLASS.