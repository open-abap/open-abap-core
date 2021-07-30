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
*    WRITE '@KERNEL console.dir(this.mv_host.get());'.
*    WRITE '@KERNEL console.dir(lv_uri.get());'.
    REPLACE FIRST OCCURRENCE OF lv_uri IN mv_host WITH ''.

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
* todo    
    RETURN.
  ENDMETHOD.

  METHOD if_http_client~send.
    DATA lv_method        TYPE string.
    DATA lv_url           TYPE string.
    DATA lv_body          TYPE string.
    DATA lt_form_fields   TYPE tihttpnvp.
    DATA lt_header_fields TYPE tihttpnvp.
    DATA ls_field         LIKE LINE OF lt_header_fields.

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
    " WRITE '@KERNEL console.dir(lv_url.get());'.

* building headers
    if_http_client~request->get_header_fields( CHANGING fields = lt_header_fields ).
    WRITE '@KERNEL let headers = {};'.
    LOOP AT lt_header_fields INTO ls_field WHERE name <> '~request_uri'.
      WRITE '@KERNEL headers[ls_field.get().name.get()] = ls_field.get().value.get();'.
    ENDLOOP.
*    WRITE '@KERNEL console.dir(headers);'.

    lv_body = if_http_client~request->get_cdata( ).

    WRITE '@KERNEL const https = await import("https");'.
    WRITE '@KERNEL function postData(url, options, body) {'.
    WRITE '@KERNEL   return new Promise((resolve, reject) => {'.
    WRITE '@KERNEL     const req = https.request(url, options,'.
    WRITE '@KERNEL       (res) => {'.
    WRITE '@KERNEL         let body = "";'.
    WRITE '@KERNEL         res.on("data", (chunk) => {body += chunk.toString()});'.
    WRITE '@KERNEL         res.on("error", reject);'.
    WRITE '@KERNEL         res.on("end", () => {'.
*    WRITE '@KERNEL           console.dir(res.statusCode + " " + res.headers["content-type"]);'.
    WRITE '@KERNEL           if (res.statusCode >= 200 && res.statusCode <= 299) {'.
    WRITE '@KERNEL             resolve({statusCode: res.statusCode, headers: res.headers, body: body});'.
    WRITE '@KERNEL           } else {'.
    WRITE '@KERNEL             reject("Request failed. status: " + res.statusCode + ", body: " + body);'.
    WRITE '@KERNEL           }'.
    WRITE '@KERNEL         });'.
    WRITE '@KERNEL       });'.
    WRITE '@KERNEL     req.on("error", reject);'.
    WRITE '@KERNEL     req.write(body, "binary");'.
    WRITE '@KERNEL     req.end();'.
    WRITE '@KERNEL   });'.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL if (this.agent === undefined) {this.agent = new https.Agent({keepAlive: true, maxSockets: 1});}'.
    WRITE '@KERNEL let response = await postData(lv_url.get(), {method: lv_method.get(), headers: headers, agent: this.agent}, lv_body.get());'.

    " WRITE '@KERNEL console.dir(response);'.
    " WRITE '@KERNEL console.dir(response.statusCode);'.

    WRITE '@KERNEL this.if_http_client$response.get().status.set(response.statusCode);'.
    WRITE '@KERNEL this.if_http_client$response.get().cdata.set(response.body);'.

  ENDMETHOD.

  METHOD if_http_client~receive.
* handled in send()
    RETURN.
  ENDMETHOD.

  METHOD if_http_client~get_last_error.
    if_http_client~response->get_status( IMPORTING code = code ).
    message = 'todo_open_abap'. " get from one of the response headers?
  ENDMETHOD.

  METHOD if_http_client~send_sap_logon_ticket.
    ASSERT 2 = 'not supported'.
  ENDMETHOD.

ENDCLASS.