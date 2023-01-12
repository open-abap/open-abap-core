CLASS cl_http_client DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_client.

    CLASS-METHODS create_by_url
      IMPORTING
        url           TYPE string
        ssl_id        TYPE ssfapplssl OPTIONAL
        proxy_host    TYPE string OPTIONAL
        proxy_service TYPE string OPTIONAL
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.
* todo, add classic exceptions

    CLASS-METHODS create_by_destination
      IMPORTING
        destination   TYPE string
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.
* todo, add classic exceptions

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

    CREATE OBJECT if_http_client~response TYPE cl_http_entity.

    FIND REGEX '\w(\/[\w\d\.\-\/]+)' IN url SUBMATCHES lv_uri.
    mv_host = url.
*    WRITE '@KERNEL console.dir(this.mv_host.get());'.
*    WRITE '@KERNEL console.dir(lv_uri.get());'.
    REPLACE FIRST OCCURRENCE OF lv_uri IN mv_host WITH ''.

    CREATE OBJECT if_http_client~request TYPE cl_http_entity.
    if_http_client~request->set_header_field(
      name = '~request_uri'
      value = lv_uri ).

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
    sy-subrc = 0. " todo
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

  METHOD create_by_destination.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~send.
    DATA lv_method        TYPE string.
    DATA lv_url           TYPE string.
    DATA lv_body          TYPE string.
    DATA lv_name          TYPE string.
    DATA lv_value         TYPE string.
    DATA lv_content_type  TYPE string.
    DATA lt_form_fields   TYPE tihttpnvp.
    DATA lt_header_fields TYPE tihttpnvp.
    DATA ls_field         LIKE LINE OF lt_header_fields.

    lv_method = if_http_client~request->get_method( ).
    IF lv_method IS INITIAL.
      lv_method = 'GET'.
    ENDIF.

* default user-agent if not set
    IF if_http_client~request->get_header_field( 'user-agent' ) IS INITIAL.
      if_http_client~request->set_header_field(
        name  = 'user-agent'
        value = 'open-abap-http' ).
    ENDIF.

* building URL
    lv_url = if_http_client~request->get_header_field( '~request_uri' ).
    REPLACE FIRST OCCURRENCE OF mv_host IN lv_url WITH ''.
    lv_url = mv_host && lv_url.
    if_http_client~request->get_form_fields( CHANGING fields = lt_form_fields ).
    IF lines( lt_form_fields ) > 0.
      CASE lv_method.
        WHEN 'GET'.
          lv_url = lv_url && '?' && cl_http_utility=>fields_to_string( lt_form_fields ).
        WHEN 'POST'.
          if_http_client~request->set_cdata( cl_http_utility=>fields_to_string( lt_form_fields ) ).
      ENDCASE.
    ENDIF.
*    WRITE '@KERNEL console.dir(lv_url.get());'.

* building headers
    if_http_client~request->get_header_fields( CHANGING fields = lt_header_fields ).
    WRITE '@KERNEL let headers = {};'.
    LOOP AT lt_header_fields INTO ls_field WHERE name <> '~request_uri'.
      WRITE '@KERNEL headers[ls_field.get().name.get()] = ls_field.get().value.get();'.
    ENDLOOP.

    lv_content_type = if_http_client~request->get_content_type( ).
    IF lv_content_type IS NOT INITIAL.
      WRITE '@KERNEL headers["content-type"] = lv_content_type.get();'.
    ENDIF.

*    WRITE '@KERNEL console.dir(headers);'.

    lv_body = if_http_client~request->get_cdata( ).
*    WRITE '@KERNEL console.dir(lv_body);'.
    IF strlen( lv_body ) > 0.
      WRITE '@KERNEL headers["content-length"] = lv_body.get().length;'.
    ENDIF.

    WRITE '@KERNEL const https = await import("https");'.
    WRITE '@KERNEL const http = await import("http");'.
    WRITE '@KERNEL function postData(url, options, requestBody) {'.
    WRITE '@KERNEL   return new Promise((resolve, reject) => {'.
    WRITE '@KERNEL     const prot = url.startsWith("http://") ? http : https;'.
    WRITE '@KERNEL     const req = prot.request(url, options,'.
    WRITE '@KERNEL       (res) => {'.
    WRITE '@KERNEL         let chunks = [];'.
    WRITE '@KERNEL         res.on("data", (chunk) => {chunks.push(chunk);});'.
    WRITE '@KERNEL         res.on("error", reject);'.
    WRITE '@KERNEL         res.on("end", () => {'.
*    WRITE '@KERNEL           console.dir(res.statusCode + " " + JSON.stringify(res.headers));'.
*    WRITE '@KERNEL           if (res.statusCode >= 200 && res.statusCode <= 299) {'.
    WRITE '@KERNEL             resolve({statusCode: res.statusCode, headers: res.headers, body: Buffer.concat(chunks)});'.
*    WRITE '@KERNEL           } else {'.
*    WRITE '@KERNEL             reject("Request failed. status: " + res.statusCode + ", body: " + Buffer.concat(chunks).toString());'.
*    WRITE '@KERNEL           }'.
    WRITE '@KERNEL         });'.
    WRITE '@KERNEL       });'.
    WRITE '@KERNEL     req.on("error", reject);'.
    WRITE '@KERNEL     req.write(requestBody, "binary");'.
    WRITE '@KERNEL     req.end();'.
    WRITE '@KERNEL   });'.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL const prot = lv_url.get().startsWith("http://") ? http : https;'.
    WRITE '@KERNEL if (this.agent === undefined) {this.agent = new prot.Agent({keepAlive: true, maxSockets: 1});}'.
    WRITE '@KERNEL let response = await postData(lv_url.get(), {method: lv_method.get(), headers: headers, agent: this.agent}, lv_body.get());'.

    " WRITE '@KERNEL console.dir(response);'.
    " WRITE '@KERNEL console.dir(response.headers);'.

    WRITE '@KERNEL for (const h in response.headers) {'.
    WRITE '@KERNEL   lv_name.set(h);'.
    WRITE '@KERNEL   if (Array.isArray(response.headers[h])) continue;'.
    WRITE '@KERNEL   lv_value.set(response.headers[h]);'.
    if_http_client~response->set_header_field(
      name  = lv_name
      value = lv_value ).
    WRITE '@KERNEL }'.


    WRITE '@KERNEL this.if_http_client$response.get().mv_content_type.set(response.headers["content-type"] || "");'.
    WRITE '@KERNEL this.if_http_client$response.get().mv_status.set(response.statusCode);'.
    WRITE '@KERNEL this.if_http_client$response.get().mv_data.set(response.body.toString("hex").toUpperCase());'.

* workaround for classic exceptions, this should work sometime in the transpiler instead
    sy-subrc = 0.

  ENDMETHOD.

  METHOD if_http_client~receive.
* handled in send()

* workaround for classic exceptions, this should work sometime in the transpiler instead
    sy-subrc = 0.

  ENDMETHOD.

  METHOD if_http_client~get_last_error.
    if_http_client~response->get_status( IMPORTING code = code ).
    message = 'todo_open_abap'. " get from one of the response headers?
  ENDMETHOD.

  METHOD if_http_client~send_sap_logon_ticket.
    ASSERT 2 = 'not supported'.
  ENDMETHOD.

ENDCLASS.