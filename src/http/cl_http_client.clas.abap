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
        destination   TYPE clike
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.
* todo, add classic exceptions

    CLASS-METHODS create_internal
      EXPORTING
        client TYPE REF TO if_http_client
      EXCEPTIONS
        plugin_not_active
        internal_error.

    METHODS constructor
      IMPORTING
        url TYPE string.

  PRIVATE SECTION.
    DATA mv_host TYPE string.
    DATA mv_sent TYPE abap_bool.
* the error of the last SEND, reported by RECEIVE and GET_LAST_ERROR
    DATA mv_error TYPE string.

ENDCLASS.

CLASS cl_http_client IMPLEMENTATION.

  METHOD constructor.
* SSL_ID and proxies are currently ignored

    DATA lv_url TYPE string.
    DATA lv_uri TYPE string.
    DATA lv_query TYPE string.

    CREATE OBJECT if_http_client~response TYPE cl_http_entity.

* the query string is not part of the host, split it off first
    SPLIT url AT '?' INTO lv_url lv_query.

    FIND REGEX '\w(\/[\w\d\.\-\/]+)' IN lv_url SUBMATCHES lv_uri.
    mv_host = lv_url.
*    WRITE '@KERNEL console.dir(this.mv_host.get());'.
*    WRITE '@KERNEL console.dir(lv_uri.get());'.
    REPLACE FIRST OCCURRENCE OF lv_uri IN mv_host WITH ''.

    CREATE OBJECT if_http_client~request TYPE cl_http_entity.
    if_http_client~request->set_header_field(
      name  = '~request_uri'
      value = lv_uri ).

    IF lv_query IS NOT INITIAL.
      cl_http_utility=>set_query(
        request = if_http_client~request
        query   = lv_query ).
    ENDIF.

  ENDMETHOD.

  METHOD if_http_client~escape_url.
    ASSERT 1 = 'todo'.
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
      name  = 'authorization'
      value = |Basic { lv_base64 }| ).
  ENDMETHOD.

  METHOD if_http_client~close.
* todo
    RETURN.
  ENDMETHOD.

  METHOD create_by_destination.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD create_internal.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~create_abs_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~send.
    DATA lv_method        TYPE string.
    DATA lv_url           TYPE string.
    DATA lv_xbody         TYPE xstring.
    DATA lv_name          TYPE string.
    DATA lv_value         TYPE string.
    DATA lv_content_type  TYPE string.
    DATA lv_xstr          TYPE xstring.
    DATA lt_form_fields   TYPE tihttpnvp.
    DATA lt_header_fields TYPE tihttpnvp.
    DATA ls_field         LIKE LINE OF lt_header_fields.
    DATA lo_entity        TYPE REF TO cl_http_entity.
    DATA lv_error         TYPE string.
    DATA lv_before_send   TYPE abap_bool.

    CLEAR mv_error.
    mv_sent = abap_true.

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
* as on a system: a POST without a body sends the fields as its body, urlencoded;
* a POST that has a body keeps it, and the fields go into the URL as for a GET
      CASE lv_method.
        WHEN 'GET'.
          lv_url = lv_url && '?' && cl_http_utility=>fields_to_string( lt_form_fields ).
        WHEN 'POST'.
          IF xstrlen( if_http_client~request->get_data( ) ) = 0.
            if_http_client~request->set_cdata( cl_http_utility=>fields_to_string( lt_form_fields ) ).
            IF if_http_client~request->get_content_type( ) IS INITIAL.
              if_http_client~request->set_content_type( 'application/x-www-form-urlencoded' ).
            ENDIF.
          ELSE.
            lv_url = lv_url && '?' && cl_http_utility=>fields_to_string( lt_form_fields ).
          ENDIF.
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
    WRITE '@KERNEL headers["accept-encoding"] = "gzip";'.

*    WRITE '@KERNEL console.dir(headers);'.

* the body goes out as the entity's bytes: set_cdata stores UTF-8, set_data any bytes
    lv_xbody = if_http_client~request->get_data( ).
    IF xstrlen( lv_xbody ) > 0.
      WRITE '@KERNEL headers["content-length"] = lv_xbody.get().length / 2;'.
    ENDIF.

    WRITE '@KERNEL const https = await import("https");'.
    WRITE '@KERNEL const http = await import("http");'.
    WRITE '@KERNEL function postData(url, options, requestBody) {'.
    WRITE '@KERNEL   return new Promise((resolve) => {'.
    WRITE '@KERNEL     const reject = (error) => resolve({error});'.
    WRITE '@KERNEL     const prot = url.startsWith("http://") ? http : https;'.
    WRITE '@KERNEL     let req;'.
    WRITE '@KERNEL     try {'.
    WRITE '@KERNEL     req = prot.request(url, options,'.
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
* thrown here, nothing was sent yet: an invalid header, method or URL
    WRITE '@KERNEL     } catch (error) { resolve({error, beforeSend: true}); return; }'.
    WRITE '@KERNEL     req.on("error", reject);'.
    WRITE '@KERNEL     req.write(requestBody);'.
    WRITE '@KERNEL     req.end();'.
    WRITE '@KERNEL   });'.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL const prot = lv_url.get().startsWith("http://") ? http : https;'.
    WRITE '@KERNEL if (this.agent === undefined) {this.agent = new prot.Agent({keepAlive: true, maxSockets: 1});}'.
    WRITE '@KERNEL let response = await postData(lv_url.get(), {method: lv_method.get(), headers: headers, agent: this.agent}, Buffer.from(lv_xbody.get(), "hex"));'.

    " WRITE '@KERNEL console.dir(response);'.
    " WRITE '@KERNEL console.dir(response.headers);'.

    WRITE '@KERNEL if (response.error) {'.
* on a dual-stack host a refused "localhost" is an AggregateError with an empty message
    WRITE '@KERNEL   const e = response.error;'.
    WRITE '@KERNEL   lv_error.set(String(e.message || (e.errors || []).map(x => x.message).join("; ") || e.code || e));'.
    WRITE '@KERNEL   if (response.beforeSend === true) lv_before_send.set("X");'.
    WRITE '@KERNEL }'.
    IF lv_error IS NOT INITIAL.
* no response: a reused client must not show the previous one's status, fields or body
      lo_entity ?= if_http_client~response.
      WRITE '@KERNEL lo_entity.get().mt_headers.clear();'.
      WRITE '@KERNEL lo_entity.get().mv_content_type.clear();'.
      if_http_client~response->set_data( lv_xstr ).
      if_http_client~response->set_status(
        code   = 0
        reason = '' ).
      mv_error = lv_error.
* as on a system: a request that cannot be written fails SEND, a connection that fails fails RECEIVE
      IF lv_before_send = abap_true.
        mv_sent = abap_false.
        RAISE http_communication_failure.
      ENDIF.
      RETURN.
    ENDIF.

    WRITE '@KERNEL for (const h in response.headers) {'.
    WRITE '@KERNEL   lv_name.set(h);'.
    WRITE '@KERNEL   if (Array.isArray(response.headers[h])) continue;'.
    WRITE '@KERNEL   lv_value.set(response.headers[h]);'.
    if_http_client~response->set_header_field(
      name  = lv_name
      value = lv_value ).
    WRITE '@KERNEL }'.

    lo_entity ?= if_http_client~response.

    WRITE '@KERNEL lo_entity.get().mv_content_type.set(response.headers["content-type"] || "");'.
    WRITE '@KERNEL lo_entity.get().mv_status.set(response.statusCode);'.
    WRITE '@KERNEL lo_entity.get().mv_data.set(response.body.toString("hex").toUpperCase());'.
*    WRITE '@KERNEL console.dir(this.if_http_client$response.get().mv_data);'.

    lv_value = if_http_client~response->get_header_field( 'content-encoding' ).
    IF lv_value = 'gzip'.
      cl_abap_gzip=>decompress_binary_with_header(
        EXPORTING
          gzip_in = if_http_client~response->get_data( )
        IMPORTING
          raw_out = lv_xstr ).
      if_http_client~response->set_data( lv_xstr ).
    ENDIF.

* workaround for classic exceptions, this should work sometime in the transpiler instead
    sy-subrc = 0.

  ENDMETHOD.

  METHOD if_http_client~receive.
* the request and its response are handled in send()
    IF mv_sent = abap_false.
      RAISE http_invalid_state.
    ENDIF.
    IF mv_error IS NOT INITIAL.
      RAISE http_communication_failure.
    ENDIF.

    sy-subrc = 0.

  ENDMETHOD.

  METHOD if_http_client~get_last_error.
    if_http_client~response->get_status( IMPORTING code = code ).
    IF mv_error IS NOT INITIAL.
* the message is Node's; a system answers the ICM's text and code, e.g. 411 for a refused connection
      message = mv_error.
    ELSE.
      message = 'todo_open_abap'. " get from one of the response headers?
    ENDIF.
  ENDMETHOD.

  METHOD if_http_client~send_sap_logon_ticket.
* do nothing,
    RETURN.
  ENDMETHOD.

  METHOD if_http_client~refresh_request.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.