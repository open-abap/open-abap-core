CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION MEDIUM FINAL.

  PRIVATE SECTION.
    METHODS get_http_bin_host RETURNING VALUE(rv_host) TYPE string.

    METHODS basic_get_https FOR TESTING RAISING cx_static_check.
    METHODS basic_get_http FOR TESTING RAISING cx_static_check.
    METHODS basic_post FOR TESTING RAISING cx_static_check.
    METHODS basic_auth FOR TESTING RAISING cx_static_check.
    METHODS call_set_method FOR TESTING RAISING cx_static_check.
    METHODS request_header_fields FOR TESTING RAISING cx_static_check.
    METHODS default_uri FOR TESTING RAISING cx_static_check.
    METHODS query_field FOR TESTING RAISING cx_static_check.
    METHODS git FOR TESTING RAISING cx_static_check.
    METHODS get_set_request_data FOR TESTING RAISING cx_static_check.
    METHODS co_disabled FOR TESTING RAISING cx_static_check.
    METHODS request_uri_with_host FOR TESTING RAISING cx_static_check.
    METHODS default_user_agent FOR TESTING RAISING cx_static_check.
    METHODS post_content_type FOR TESTING RAISING cx_static_check.
    METHODS status_500 FOR TESTING RAISING cx_static_check.
    METHODS decode_gzip FOR TESTING RAISING cx_static_check.
    METHODS accepts_gzip FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_http_bin_host.
    WRITE '@KERNEL rv_host.set(process.env.HTTP_BIN_HOST || "");'.
    IF rv_host IS INITIAL.
      rv_host = |https://httpbin.org|.
    ENDIF.
  ENDMETHOD.

  METHOD basic_get_https.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.
    DATA lv_xdata TYPE xstring.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/get|
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).

    li_client->propertytype_logon_popup = if_http_client=>co_disabled.

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

    lv_xdata = li_client->response->get_data( ).
    cl_abap_unit_assert=>assert_not_initial( lv_xdata ).

    cl_abap_unit_assert=>assert_not_initial( li_client->response->get_content_type( ) ).

    cl_abap_unit_assert=>assert_char_cp(
      act = li_client->response->get_header_field( 'server' )
      exp = '*gunicorn*' ).

  ENDMETHOD.

  METHOD basic_get_http.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'http://httpbin.org/get'
      IMPORTING
        client = li_client ).
    li_client->send( ).
    li_client->receive( ).

    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

  ENDMETHOD.

  METHOD basic_post.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/post|
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_method( 'POST' ).

    li_client->request->set_cdata( 'HELLO_WORLD' ).

    li_client->send( ).
    li_client->receive( ).

    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

    lv_cdata = li_client->response->get_cdata( ).
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '*HELLO_WORLD*' ).

  ENDMETHOD.

  METHOD basic_auth.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/basic-auth/sdf/sdf|
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
        url    = |{ get_http_bin_host( ) }/get|
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

  METHOD git.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.
    DATA lv_cdata TYPE string.
    DATA lv_str TYPE string.
    DATA lv_hex TYPE xstring.
    DATA lv_resp TYPE xstring.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://github.com'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_header_field(
        name  = '~request_uri'
        value = '/larshp/Empty/info/refs?service=git-upload-pack' ).
    li_client->send( ).
    li_client->receive( ).
    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).
    lv_cdata = li_client->response->get_cdata( ).
    ASSERT lv_cdata(4) = '001e'.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '001e*' ).

**************

    li_client->request->set_header_field(
      name  = '~request_method'
      value = 'POST' ).
    li_client->request->set_header_field(
      name  = '~request_uri'
      value = '/larshp/Empty/git-upload-pack' ).
    li_client->request->set_header_field(
      name  = 'Content-Type'
      value = 'application/x-git-upload-pack-request' ).
    li_client->request->set_header_field(
      name  = 'Accept'
      value = 'application/x-git-upload-pack-result' ).

    lv_str = |0056want f9ec23d6d935aa7dc26ee141c7b46feed9d4685e side-band-64k no-progress multi_ack\n000Ddeepen 1\n00000009done\n|.
    cl_abap_conv_out_ce=>create( encoding = 'UTF-8' )->convert(
      EXPORTING data   = lv_str
      IMPORTING buffer = lv_hex ).

    li_client->request->set_data( lv_hex ).
    li_client->send( ).
    li_client->receive( ).
    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).
    lv_resp = li_client->response->get_data( ).
    cl_abap_unit_assert=>assert_equals(
      act = xstrlen( lv_resp )
      exp = 679 ).

  ENDMETHOD.

  METHOD get_set_request_data.

    DATA lv_string TYPE string.
    DATA lv_xstring TYPE xstring.
    DATA li_client TYPE REF TO if_http_client.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://github.com'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_cdata( 'ABC' ).

    lv_string = li_client->request->get_cdata( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_string
      exp = 'ABC' ).

    lv_xstring = li_client->request->get_data( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_xstring
      exp = '414243' ).

    li_client->request->set_data( lv_xstring ).

    lv_xstring = li_client->request->get_data( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_xstring
      exp = '414243' ).

    lv_string = li_client->request->get_cdata( ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_string
      exp = 'ABC' ).

  ENDMETHOD.

  METHOD co_disabled.

    cl_abap_unit_assert=>assert_equals(
      act = if_http_client=>co_disabled
      exp = 0 ).

  ENDMETHOD.

  METHOD request_uri_with_host.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_uri TYPE string VALUE 'https://api.github.com/gists/7178e319d3b699dbc30ee963c1a35219'.
    DATA lv_val TYPE string.
    DATA lv_code TYPE i.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://api.github.com'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_header_field( name = '~request_uri' value = lv_uri ).
    lv_val = li_client->request->get_header_field( name = '~request_uri' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_uri
      exp = lv_val ).
    li_client->send( ).
    li_client->receive( ).
    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

  ENDMETHOD.

  METHOD default_user_agent.

    DATA li_client TYPE REF TO if_http_client.
    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://api.github.com'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    cl_abap_unit_assert=>assert_initial( li_client->request->get_header_field( name = 'user-agent' ) ).
    li_client->send( ).
    li_client->receive( ).
    cl_abap_unit_assert=>assert_not_initial( li_client->request->get_header_field( name = 'user-agent' ) ).

  ENDMETHOD.

  METHOD post_content_type.
    DATA li_client TYPE REF TO if_http_client.
    DATA lv_cdata  TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/post|
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_method( 'POST' ).
    li_client->request->set_form_field( name = 'foo1' value = 'bar1' ).
    li_client->request->set_form_field( name = 'foo2' value = 'bar2' ).
    li_client->request->set_content_type( 'application/x-www-form-urlencoded' ).

    li_client->send( ).
    li_client->receive( ).

    lv_cdata = li_client->response->get_cdata( ).
*    WRITE '@KERNEL console.dir(lv_cdata);'.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '*application/x-www-form-urlencoded*' ).
  ENDMETHOD.

  METHOD status_500.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/status/500|
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_method( 'POST' ).

    li_client->send( ).
    li_client->receive( ).

    li_client->response->get_status( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 500 ).

  ENDMETHOD.

  METHOD decode_gzip.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_cdata  TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/gzip|
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_method( 'GET' ).

    li_client->send( ).
    li_client->receive( ).

    lv_cdata = li_client->response->get_cdata( ).
*    WRITE '@KERNEL console.dir(lv_cdata);'.
    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '*"gzipped": true*' ).

  ENDMETHOD.

  METHOD accepts_gzip.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_cdata  TYPE string.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = |{ get_http_bin_host( ) }/headers|
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->request->set_method( 'GET' ).

    li_client->send( ).
    li_client->receive( ).

    lv_cdata = li_client->response->get_cdata( ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lv_cdata
      exp = '*"Accept-Encoding": "gzip"*' ).

  ENDMETHOD.

ENDCLASS.