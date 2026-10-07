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
* the error of the last exchange, reported by GET_LAST_ERROR
    DATA mv_error TYPE string.
    DATA mv_error_code TYPE i.

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
    WRITE '@KERNEL if (this.agent) {this.agent.destroy(); delete this.agent;}'.
    WRITE '@KERNEL delete this.pendingRequest;'.
    mv_sent = abap_false.
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
    DATA lv_content_type  TYPE string.
    DATA lv_xstr          TYPE xstring.
    DATA lt_form_fields   TYPE tihttpnvp.
    DATA lt_header_fields TYPE tihttpnvp.
    DATA ls_field         LIKE LINE OF lt_header_fields.
    DATA lo_entity        TYPE REF TO cl_http_entity.
    DATA lv_error         TYPE string.
    DATA lv_pending       TYPE abap_bool.

    WRITE '@KERNEL lv_pending.set(this.pendingRequest ? "X" : "");'.
    IF lv_pending = abap_true.
      RAISE http_invalid_state.
    ENDIF.

    CLEAR mv_error.
    CLEAR mv_error_code.
    mv_sent = abap_false.

    IF timeout < -1.
* retain the timeout diagnostic for RECEIVE; a later SEND can retry
      mv_sent = abap_true.
      mv_error_code = 17.
      mv_error = 'Internal error. Handle for this http session was not found or is NULL.'.
      lo_entity ?= if_http_client~response.
      WRITE '@KERNEL lo_entity.get().mt_headers.clear();'.
      WRITE '@KERNEL lo_entity.get().mv_content_type.clear();'.
      if_http_client~response->set_data( lv_xstr ).
      if_http_client~response->set_status( code   = 0
                                           reason = '' ).
      RAISE http_invalid_timeout.
    ENDIF.

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
* construct outside the promise executor so synchronous errors belong to SEND
    WRITE '@KERNEL function postData(url, options, requestBody, timeoutSeconds) {'.
    WRITE '@KERNEL   let finish;'.
* network errors fulfill the promise: an omitted RECEIVE cannot cause an unhandled rejection
    WRITE '@KERNEL   const pending = new Promise(resolve => {finish = resolve;});'.
    WRITE '@KERNEL   const fail = error => finish({error});'.
    WRITE '@KERNEL   const prot = url.startsWith("http://") ? http : https;'.
    WRITE '@KERNEL   const req = prot.request(url, options, res => {'.
    WRITE '@KERNEL     const chunks = [];'.
    WRITE '@KERNEL     res.on("data", chunk => chunks.push(chunk));'.
    WRITE '@KERNEL     res.on("error", fail);'.
    WRITE '@KERNEL     res.on("end", () => finish({statusCode: res.statusCode, statusMessage: res.statusMessage, httpVersion: res.httpVersion, headers: res.headers, body: Buffer.concat(chunks)}));'.
    WRITE '@KERNEL   });'.
    WRITE '@KERNEL   req.on("error", fail);'.
* retain upstream's idle timeout, including zero to clear a reused socket's timeout
    WRITE '@KERNEL   try {'.
    WRITE '@KERNEL     req.setTimeout(Math.max(0, timeoutSeconds) * 1000, () => {'.
    WRITE '@KERNEL       const error = new Error("Connection to partner timed out after " + timeoutSeconds + "s.");'.
    WRITE '@KERNEL       error.code = "ETIMEDOUT"; req.destroy(error);'.
    WRITE '@KERNEL     });'.
    WRITE '@KERNEL     req.write(requestBody);'.
    WRITE '@KERNEL     req.end();'.
    WRITE '@KERNEL   } catch (error) {req.destroy(); throw error;}'.
    WRITE '@KERNEL   return pending;'.
    WRITE '@KERNEL }'.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   const prot = lv_url.get().startsWith("http://") ? http : https;'.
    WRITE '@KERNEL   if (this.agent === undefined) {this.agent = new prot.Agent({keepAlive: true, maxSockets: 1});}'.
    WRITE '@KERNEL   this.pendingRequest = postData(lv_url.get(), {method: lv_method.get(), headers, agent: this.agent}, Buffer.from(lv_xbody.get(), "hex"), timeout.get());'.
    WRITE '@KERNEL } catch (e) {'.
    WRITE '@KERNEL   lv_error.set(String(e.message || (e.errors || []).map(x => x.message).join("; ") || e.code || e));'.
    WRITE '@KERNEL }'.
    IF lv_error IS NOT INITIAL.
      mv_error = lv_error.
      lo_entity ?= if_http_client~response.
      WRITE '@KERNEL lo_entity.get().mt_headers.clear();'.
      WRITE '@KERNEL lo_entity.get().mv_content_type.clear();'.
      if_http_client~response->set_data( lv_xstr ).
      if_http_client~response->set_status( code   = 0
                                           reason = '' ).
      RAISE http_communication_failure.
    ENDIF.

    mv_sent = abap_true.
    sy-subrc = 0.
  ENDMETHOD.

  METHOD if_http_client~receive.
    DATA lv_name       TYPE string.
    DATA lv_value      TYPE string.
    DATA lv_xstr       TYPE xstring.
    DATA lo_entity     TYPE REF TO cl_http_entity.
    DATA lv_error      TYPE string.
    DATA lv_error_code TYPE i.
    DATA lv_pending    TYPE abap_bool.

    IF mv_sent = abap_false.
      RAISE http_invalid_state.
    ENDIF.

* a rejected timeout has no pending promise; preserve its code and message
    IF mv_error IS NOT INITIAL.
      RAISE http_communication_failure.
    ENDIF.

* a completed exchange can be received again without decoding its body twice
    WRITE '@KERNEL lv_pending.set(this.pendingRequest ? "X" : "");'.
    IF lv_pending = abap_false.
      sy-subrc = 0.
      RETURN.
    ENDIF.

    WRITE '@KERNEL const response = await this.pendingRequest;'.
    WRITE '@KERNEL delete this.pendingRequest;'.
    WRITE '@KERNEL if (response.error) {'.
* on a dual-stack host a refused localhost can have an empty AggregateError message
    WRITE '@KERNEL   const e = response.error;'.
    WRITE '@KERNEL   if (e.code === "ETIMEDOUT") lv_error_code.set(402);'.
    WRITE '@KERNEL   lv_error.set(String(e.message || (e.errors || []).map(x => x.message).join("; ") || e.code || e));'.
    WRITE '@KERNEL }'.
    IF lv_error IS NOT INITIAL.
      lo_entity ?= if_http_client~response.
      WRITE '@KERNEL lo_entity.get().mt_headers.clear();'.
      WRITE '@KERNEL lo_entity.get().mv_content_type.clear();'.
      if_http_client~response->set_data( lv_xstr ).
      if_http_client~response->set_status( code   = 0
                                           reason = '' ).
      mv_error = lv_error.
      mv_error_code = lv_error_code.
      RAISE http_communication_failure.
    ENDIF.

* clear the old response just before installing the newly received one
    lo_entity ?= if_http_client~response.
    WRITE '@KERNEL lo_entity.get().mt_headers.clear();'.
    WRITE '@KERNEL lo_entity.get().mv_content_type.clear();'.
    if_http_client~response->set_data( lv_xstr ).
    if_http_client~response->set_status( code   = 0
                                         reason = '' ).

    WRITE '@KERNEL for (const h in response.headers) {'.
    WRITE '@KERNEL   lv_name.set(h);'.
    WRITE '@KERNEL   if (Array.isArray(response.headers[h])) continue;'.
    WRITE '@KERNEL   lv_value.set(response.headers[h]);'.
    if_http_client~response->set_header_field(
      name  = lv_name
      value = lv_value ).
    WRITE '@KERNEL }'.

* the pseudo header fields a system sets on every response it received
    WRITE '@KERNEL lv_value.set(String(response.statusCode));'.
    if_http_client~response->set_header_field(
      name  = '~status_code'
      value = lv_value ).
    WRITE '@KERNEL lv_value.set(response.statusMessage || "");'.
    if_http_client~response->set_header_field(
      name  = '~status_reason'
      value = lv_value ).
    WRITE '@KERNEL lv_value.set("HTTP/" + response.httpVersion);'.
    if_http_client~response->set_header_field(
      name  = '~server_protocol'
      value = lv_value ).

    lo_entity ?= if_http_client~response.

    WRITE '@KERNEL lo_entity.get().mv_content_type.set(response.headers["content-type"] || "");'.
    WRITE '@KERNEL lo_entity.get().mv_status.set(response.statusCode);'.
    WRITE '@KERNEL lo_entity.get().mv_reason.set(response.statusMessage || "");'.
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

  METHOD if_http_client~get_last_error.
    if_http_client~response->get_status( IMPORTING code = code ).
    IF mv_error IS NOT INITIAL.
      IF mv_error_code <> 0.
        code = mv_error_code.
      ENDIF.
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
