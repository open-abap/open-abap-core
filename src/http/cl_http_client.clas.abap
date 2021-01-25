CLASS cl_http_client DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_client.

    CLASS-METHODS create_by_url
      IMPORTING
        url           TYPE string
        ssl_id        TYPE string OPTIONAL
        proxy_host    TYPE string OPTIONAL
        proxy_service TYPE string OPTIONAL
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.

    METHODS constructor
      IMPORTING
        url TYPE string.

  PRIVATE SECTION.
    DATA mv_host TYPE string.

ENDCLASS.

CLASS cl_http_client IMPLEMENTATION.

  METHOD constructor.
* SSL_ID and proxies are currently ignored

    DATA lv_uri TYPE string.
    DATA lv_query TYPE string.

    CREATE OBJECT if_http_client~response TYPE lcl_response.

    FIND REGEX '\w(\/[\w\d\.\-\/]+)' IN url SUBMATCHES lv_uri.
    mv_host = url.
    REPLACE FIRST OCCURRENCE OF lv_uri IN mv_host WITH ''.
*    WRITE '@KERNEL console.dir(this.mv_host.get());'.

    CREATE OBJECT if_http_client~request TYPE lcl_request
      EXPORTING
        uri = lv_uri.

    FIND REGEX '\?(.*)' IN url SUBMATCHES lv_query.
    IF sy-subrc = 0.
      cl_http_utility=>set_query(
        request = if_http_client~request
        query   = lv_query ).
    ENDIF.

  ENDMETHOD.

  METHOD create_by_url.
    CREATE OBJECT client TYPE cl_http_client
      EXPORTING
        url = url.
  ENDMETHOD.

  METHOD if_http_client~authenticate.
    DATA lv_base64 TYPE string.
    lv_base64 = cl_http_utility=>encode_base64( |{ username }:{ password }| ).
    if_http_client~request->set_header_field(
      name = 'authorization'
      value = |Basic { lv_base64 }| ).
  ENDMETHOD.

  METHOD if_http_client~close.
* https://www.chromestatus.com/feature/5760375567941632
* https://github.com/node-fetch/node-fetch/issues/599
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~send.
* note that fetch() also works in browsers,
* https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
* https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
* https://caniuse.com/fetch

    DATA lv_method TYPE string.
    DATA lv_url TYPE string.
    DATA lt_form_fields TYPE tihttpnvp.
    DATA lt_header_fields TYPE tihttpnvp.
    DATA ls_field LIKE LINE OF lt_header_fields.

    lv_method = if_http_client~request->get_method( ).
    IF lv_method IS INITIAL.
      lv_method = 'GET'.
    ENDIF.

* building URL
    lv_url = mv_host && if_http_client~request->get_header_field( '~request_uri' ).
    if_http_client~request->get_form_fields( CHANGING fields = lt_form_fields ).
    IF lines( lt_form_fields ) > 0.
      lv_url = lv_url && '?' && cl_http_utility=>fields_to_string( lt_form_fields ).
    ENDIF.
*    WRITE '@KERNEL console.dir(lv_url.get());'.

* building headers
    if_http_client~request->get_header_fields( CHANGING fields = lt_header_fields ).
    WRITE '@KERNEL let headers = {};'.
    LOOP AT lt_header_fields INTO ls_field WHERE name <> '~request_uri'.
      WRITE '@KERNEL headers[ls_field.get().name.get()] = ls_field.get().value.get();'.
    ENDLOOP.
*    WRITE '@KERNEL console.dir(headers);'.

    WRITE '@KERNEL let response = await globalThis.fetch(lv_url.get(), {method: lv_method.get(), headers: headers});'.
*    WRITE '@KERNEL console.dir(await response.text());'.

    WRITE '@KERNEL this.if_http_client$response.get().status.set(response.status);'.
    WRITE '@KERNEL this.if_http_client$response.get().cdata.set(await response.text());'.

  ENDMETHOD.

  METHOD if_http_client~receive.
* handled in send()
    RETURN.
  ENDMETHOD.

  METHOD if_http_client~get_last_error.
    if_http_client~response->get_status( IMPORTING code = code ).
    message = 'todo_open_abap'. " get from one of the response headers?
  ENDMETHOD.

ENDCLASS.