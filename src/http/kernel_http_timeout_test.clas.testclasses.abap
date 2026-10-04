CLASS ltcl_timeout DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION MEDIUM FINAL.
  PRIVATE SECTION.
    DATA mi_client TYPE REF TO if_http_client.
    METHODS setup.
    METHODS teardown.
    METHODS stalled_response FOR TESTING.
    METHODS stalled_body FOR TESTING.
    METHODS stalled_tls FOR TESTING.
    METHODS invalid_timeout FOR TESTING.
    METHODS timeout_modes FOR TESTING.
    METHODS check_timeout IMPORTING iv_path TYPE string.
ENDCLASS.

CLASS ltcl_timeout IMPLEMENTATION.
  METHOD setup.
    DATA lv_url TYPE string.
    WRITE '@KERNEL const http = await import("node:http");'.
    WRITE '@KERNEL this.sockets = new Set(); this.timers = new Set(); this.requests = 0;'.
    WRITE '@KERNEL this.server = http.createServer((req, res) => {'.
    WRITE '@KERNEL   this.requests++;'.
    WRITE '@KERNEL   if (req.url === "/ok") { res.end("ok"); return; }'.
    WRITE '@KERNEL   if (req.url === "/body") { res.writeHead(200); res.write("partial"); }'.
    WRITE '@KERNEL   const timer = setTimeout(() => { this.timers.delete(timer); res.end("done"); }, 2200);'.
    WRITE '@KERNEL   this.timers.add(timer);'.
    WRITE '@KERNEL });'.
    WRITE '@KERNEL this.server.on("connection", socket => { this.sockets.add(socket); socket.on("close", () => this.sockets.delete(socket)); });'.
    WRITE '@KERNEL await new Promise(resolve => this.server.listen(0, "127.0.0.1", resolve));'.
    WRITE '@KERNEL lv_url.set("http://127.0.0.1:" + this.server.address().port);'.
    cl_http_client=>create_by_url( EXPORTING url = lv_url IMPORTING client = mi_client ).
  ENDMETHOD.

  METHOD teardown.
    DATA li_client TYPE REF TO if_http_client.
    li_client = mi_client.
    WRITE '@KERNEL for (const timer of this.timers) clearTimeout(timer);'.
    WRITE '@KERNEL for (const socket of this.sockets) socket.destroy();'.
    WRITE '@KERNEL if (li_client.get().agent) li_client.get().agent.destroy();'.
    WRITE '@KERNEL await new Promise(resolve => this.server.close(resolve));'.
    WRITE '@KERNEL if (this.rawServer) await new Promise(resolve => this.rawServer.close(resolve));'.
  ENDMETHOD.

  METHOD check_timeout.
    DATA lv_code TYPE i.
    DATA lv_message TYPE string.
    mi_client->request->set_header_field( name  = '~request_uri'
                                          value = iv_path ).
    mi_client->send( EXPORTING timeout = 1 EXCEPTIONS OTHERS = 9 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    mi_client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 9 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    mi_client->get_last_error( IMPORTING code = lv_code message = lv_message ).
    cl_abap_unit_assert=>assert_equals( act = lv_code
                                        exp = 402 ).
    cl_abap_unit_assert=>assert_equals( act = lv_message
                                        exp = 'Connection to partner timed out after 1s.' ).
    cl_abap_unit_assert=>assert_initial( mi_client->response->get_data( ) ).
    mi_client->request->set_header_field( name  = '~request_uri'
                                          value = '/ok' ).
    mi_client->send( ).
    mi_client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = mi_client->response->get_cdata( )
                                        exp = 'ok' ).
  ENDMETHOD.

  METHOD stalled_response.
    check_timeout( '/slow' ).
  ENDMETHOD.

  METHOD stalled_body.
    check_timeout( '/body' ).
  ENDMETHOD.

  METHOD stalled_tls.
    DATA lv_url TYPE string.
    DATA lv_code TYPE i.
    WRITE '@KERNEL const net = await import("node:net");'.
    WRITE '@KERNEL this.rawServer = net.createServer(socket => {'.
    WRITE '@KERNEL   this.sockets.add(socket); socket.on("close", () => this.sockets.delete(socket));'.
    WRITE '@KERNEL   const timer = setTimeout(() => socket.destroy(), 2200); this.timers.add(timer);'.
    WRITE '@KERNEL });'.
    WRITE '@KERNEL await new Promise(resolve => this.rawServer.listen(0, "127.0.0.1", resolve));'.
    WRITE '@KERNEL lv_url.set("https://127.0.0.1:" + this.rawServer.address().port);'.
    cl_http_client=>create_by_url( EXPORTING url = lv_url IMPORTING client = mi_client ).
    mi_client->send( EXPORTING timeout = 1 EXCEPTIONS OTHERS = 9 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    mi_client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 9 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    mi_client->get_last_error( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals( act = lv_code
                                        exp = 402 ).
  ENDMETHOD.

  METHOD invalid_timeout.
    DATA lv_requests TYPE i.
    DATA lv_code TYPE i.
    mi_client->send( EXPORTING timeout = -5 EXCEPTIONS http_invalid_timeout = 4 OTHERS = 9 ).
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
    mi_client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 9 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    mi_client->get_last_error( IMPORTING code = lv_code ).
    cl_abap_unit_assert=>assert_equals( act = lv_code
                                        exp = 17 ).
    WRITE '@KERNEL lv_requests.set(this.requests);'.
    cl_abap_unit_assert=>assert_equals( act = lv_requests
                                        exp = 0 ).
  ENDMETHOD.

  METHOD timeout_modes.
    mi_client->request->set_header_field( name  = '~request_uri'
                                          value = '/ok' ).
    mi_client->send( timeout = 1 ).
    mi_client->receive( ).
    mi_client->request->set_header_field( name  = '~request_uri'
                                          value = '/slow' ).
    mi_client->send( timeout = 0 ).
    mi_client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = mi_client->response->get_cdata( )
                                        exp = 'done' ).
    mi_client->send( timeout = -1 ).
    mi_client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = mi_client->response->get_cdata( )
                                        exp = 'done' ).
    mi_client->send( timeout = 5 ).
    mi_client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = mi_client->response->get_cdata( )
                                        exp = 'done' ).
  ENDMETHOD.
ENDCLASS.
