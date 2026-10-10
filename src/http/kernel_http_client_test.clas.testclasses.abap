CLASS ltcl_async_client DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    DATA mv_url TYPE string.
    DATA mt_clients TYPE STANDARD TABLE OF REF TO if_http_client WITH DEFAULT KEY.
    METHODS setup.
    METHODS fixture.
    METHODS cleanup.
    METHODS make_client IMPORTING path TYPE string RETURNING VALUE(client) TYPE REF TO if_http_client.
    METHODS overlap FOR TESTING RAISING cx_static_check.
    METHODS refused_at_receive FOR TESTING RAISING cx_static_check.
    METHODS timeout_at_receive FOR TESTING RAISING cx_static_check.
    METHODS construction_at_send FOR TESTING RAISING cx_static_check.
    METHODS never_received FOR TESTING RAISING cx_static_check.
    METHODS receive_without_send FOR TESTING RAISING cx_static_check.
    METHODS reuse FOR TESTING RAISING cx_static_check.
    METHODS close_pending FOR TESTING RAISING cx_static_check.
    METHODS retry_invalid_timeout FOR TESTING RAISING cx_static_check.
    METHODS response_until_receive FOR TESTING RAISING cx_static_check.
    METHODS repeated_receive FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_async_client IMPLEMENTATION.
  METHOD setup.
    " The generated runner skips teardown on failure: each test owns its finally.
    " Race the entire fixture and exchange, including SEND, against one deadline.
    WRITE '@KERNEL for (const name of ["overlap", "refused_at_receive", "timeout_at_receive", "construction_at_send", "never_received",'.
    WRITE '@KERNEL   "receive_without_send", "reuse", "close_pending", "retry_invalid_timeout", "response_until_receive", "repeated_receive"]) {'.
    WRITE '@KERNEL   const run = this.FRIENDS_ACCESS_INSTANCE[name];'.
    WRITE '@KERNEL   this.FRIENDS_ACCESS_INSTANCE[name] = async () => {'.
    WRITE '@KERNEL     let timer;'.
    WRITE '@KERNEL     try {'.
    WRITE '@KERNEL       await Promise.race([(async () => {await this.FRIENDS_ACCESS_INSTANCE.fixture(); await run();})(),'.
    WRITE '@KERNEL         new Promise((_, reject) => {timer = setTimeout(() => reject(new Error("Deadline: " + name)), 2500);})]);'.
    WRITE '@KERNEL     } finally {clearTimeout(timer); await this.FRIENDS_ACCESS_INSTANCE.cleanup();}'.
    WRITE '@KERNEL   };'.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD fixture.
    DATA url TYPE string.
    WRITE '@KERNEL const http = await import("node:http");'.
    WRITE '@KERNEL const zlib = await import("node:zlib");'.
    WRITE '@KERNEL this.unhandled = []; this.onUnhandled = error => this.unhandled.push(error);'.
    WRITE '@KERNEL process.on("unhandledRejection", this.onUnhandled);'.
    WRITE '@KERNEL const transport = http.default;'.
    WRITE '@KERNEL this.originalRequest = transport.request; this.pending = new Set();'.
    WRITE '@KERNEL this.failed = new Promise(resolve => {this.signalFailed = resolve;});'.
    WRITE '@KERNEL transport.request = (...args) => {'.
    WRITE '@KERNEL     if (this.finished) throw new Error("Exchange finished");'.
    WRITE '@KERNEL     const req = this.originalRequest(...args); this.pending.add(req);'.
    WRITE '@KERNEL     req.once("close", () => this.pending.delete(req));'.
    WRITE '@KERNEL     req.once("error", error => queueMicrotask(() => this.signalFailed(error)));'.
    " Destroy before a socket can connect; no unreserved port is used.
    WRITE '@KERNEL     if (this.refuseNext) {'.
    WRITE '@KERNEL       this.refuseNext = false; this.sockets = 0; req.once("socket", () => this.sockets++);'.
    WRITE '@KERNEL       const error = new Error("connect ECONNREFUSED (injected)"); error.code = "ECONNREFUSED"; req.destroy(error);'.
    WRITE '@KERNEL     }'.
    WRITE '@KERNEL     return req;'.
    WRITE '@KERNEL };'.
    WRITE '@KERNEL (await import("node:module")).syncBuiltinESMExports();'.
    WRITE '@KERNEL this.waiting = []; this.peak = 0; this.requests = 0;'.
    WRITE '@KERNEL this.arrived = new Promise(resolve => {this.signalArrived = resolve;});'.
    WRITE '@KERNEL this.release = () => {for (const [req, res] of this.waiting.splice(0)) {res.writeHead(200, {"x-request": req.url}); res.end(req.url);}};'.
    WRITE '@KERNEL this.server = http.createServer((req, res) => {this.requests++;'.
    WRITE '@KERNEL   if (req.url.startsWith("/delay")) {'.
    WRITE '@KERNEL     this.waiting.push([req, res]); this.peak = Math.max(this.peak, this.waiting.length);'.
    WRITE '@KERNEL     if (this.waiting.length === 3) this.signalArrived();'.
    WRITE '@KERNEL     return;'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL   if (req.url === "/stall") {this.signalArrived(); return;}'.
    WRITE '@KERNEL   if (req.url === "/reset") {req.socket.destroy(); return;}'.
    WRITE '@KERNEL   if (req.url === "/gzip") {'.
    WRITE '@KERNEL     res.writeHead(201, "Created", {"content-encoding": "gzip", "content-type": "text/plain"});'.
    WRITE '@KERNEL     res.end(zlib.gzipSync(Buffer.from("compressed"))); return;'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL   const chunks = []; req.on("data", chunk => chunks.push(chunk));'.
    WRITE '@KERNEL   req.on("end", () => {res.writeHead(200, {"x-seen": req.headers["x-snapshot"] || ""}); res.end(Buffer.concat(chunks));});'.
    WRITE '@KERNEL });'.
    WRITE '@KERNEL await new Promise((resolve, reject) => {this.server.once("error", reject); this.server.listen(0, "127.0.0.1", resolve);});'.
    WRITE '@KERNEL url.set("http://127.0.0.1:" + this.server.address().port);'.
    mv_url = url.
  ENDMETHOD.

  METHOD cleanup.
    DATA client TYPE REF TO if_http_client.
    WRITE '@KERNEL this.finished = true;'.
    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   await Promise.all([...this.pending || []].map(req => new Promise(resolve => {'.
    WRITE '@KERNEL     if (req.closed) {resolve(); return;} req.once("close", resolve); req.destroy();'.
    WRITE '@KERNEL   })));'.
    LOOP AT mt_clients INTO client.
      client->close( ).
    ENDLOOP.
    WRITE '@KERNEL } finally {'.
    WRITE '@KERNEL   try {'.
    WRITE '@KERNEL     if (this.server) {'.
    WRITE '@KERNEL       this.server.closeAllConnections();'.
    WRITE '@KERNEL       await new Promise(resolve => this.server.close(resolve));'.
    WRITE '@KERNEL     }'.
    " Drain aborted SEND continuations while the request hook still rejects new work.
    WRITE '@KERNEL     await new Promise(resolve => setImmediate(resolve));'.
    WRITE '@KERNEL   } finally {'.
    WRITE '@KERNEL     if (this.originalRequest) {'.
    WRITE '@KERNEL       (await import("node:http")).default.request = this.originalRequest;'.
    WRITE '@KERNEL       (await import("node:module")).syncBuiltinESMExports();'.
    WRITE '@KERNEL     }'.
    WRITE '@KERNEL     if (this.onUnhandled) process.removeListener("unhandledRejection", this.onUnhandled);'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.
  ENDMETHOD.

  METHOD make_client.
    cl_http_client=>create_by_url( EXPORTING url = mv_url && path IMPORTING client = client ).
    APPEND client TO mt_clients.
  ENDMETHOD.

  METHOD overlap.
    DATA first TYPE REF TO if_http_client.
    DATA second TYPE REF TO if_http_client.
    DATA third TYPE REF TO if_http_client.
    DATA peak TYPE i.
    first = make_client( '/delay1' ).
    second = make_client( '/delay2' ).
    third = make_client( '/delay3' ).
    first->send( ).
    second->send( ).
    third->send( ).
    WRITE '@KERNEL await this.arrived; peak.set(this.peak);'.
    cl_abap_unit_assert=>assert_initial( first->response->get_data( ) ).
    WRITE '@KERNEL this.release();'.
    first->receive( ).
    second->receive( ).
    third->receive( ).
    cl_abap_unit_assert=>assert_equals( act = peak
                                        exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = first->response->get_cdata( )
                                        exp = '/delay1' ).
    cl_abap_unit_assert=>assert_equals( act = second->response->get_cdata( )
                                        exp = '/delay2' ).
    cl_abap_unit_assert=>assert_equals( act = third->response->get_cdata( )
                                        exp = '/delay3' ).
    cl_abap_unit_assert=>assert_equals( act = third->response->get_header_field( 'x-request' )
                                        exp = '/delay3' ).
  ENDMETHOD.

  METHOD refused_at_receive.
    DATA client TYPE REF TO if_http_client.
    DATA code TYPE i.
    DATA message TYPE string.
    DATA sockets TYPE i.
    client = make_client( '/echo' ).
    WRITE '@KERNEL this.refuseNext = true;'.
    client->send( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    client->get_last_error( IMPORTING message = message ).
    cl_abap_unit_assert=>assert_equals( act = message
                                        exp = 'todo_open_abap' ).
    WRITE '@KERNEL await this.failed;'.
    client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->get_last_error( IMPORTING code = code message = message ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 0 ).
    cl_abap_unit_assert=>assert_true( xsdbool( message CS 'ECONNREFUSED' ) ).
    WRITE '@KERNEL sockets.set(this.sockets);'.
    cl_abap_unit_assert=>assert_equals( act = sockets
                                        exp = 0 ).
  ENDMETHOD.

  METHOD timeout_at_receive.
    DATA client TYPE REF TO if_http_client.
    DATA code TYPE i.
    DATA message TYPE string.
    client = make_client( '/stall' ).
    client->send( EXPORTING timeout = 1 EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    client->get_last_error( IMPORTING message = message ).
    cl_abap_unit_assert=>assert_equals( act = message
                                        exp = 'todo_open_abap' ).
    WRITE '@KERNEL await this.arrived; await this.failed;'.
    client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->get_last_error( IMPORTING code = code message = message ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 402 ).
    cl_abap_unit_assert=>assert_true( xsdbool( message CS 'timed out after 1s' ) ).
  ENDMETHOD.

  METHOD construction_at_send.
    DATA client TYPE REF TO if_http_client.
    DATA code TYPE i.
    DATA message TYPE string.
    client = make_client( '/gzip' ).
    client->send( ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    client->receive( ).
    client->request->set_header_field( name  = 'x-bad'
                                       value = |a{ cl_abap_char_utilities=>newline }b| ).
    client->send( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->get_last_error( IMPORTING code = code message = message ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 0 ).
    cl_abap_unit_assert=>assert_true( xsdbool( message CS 'Invalid character' ) ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    cl_abap_unit_assert=>assert_initial( client->response->get_header_field( 'content-encoding' ) ).
    client->receive( EXCEPTIONS http_invalid_state = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
  ENDMETHOD.

  METHOD never_received.
    DATA client TYPE REF TO if_http_client.
    DATA message TYPE string.
    DATA count TYPE i.
    client = make_client( '/reset' ).
    client->send( ).
    client->get_last_error( IMPORTING message = message ).
    cl_abap_unit_assert=>assert_equals( act = message
                                        exp = 'todo_open_abap' ).
    WRITE '@KERNEL await this.failed;'.
    " Two event-loop turns allow Node to report any unhandled rejection.
    WRITE '@KERNEL for (let i = 0; i < 2; i++) await new Promise(resolve => setImmediate(resolve));'.
    WRITE '@KERNEL count.set(this.unhandled.length);'.
    client->close( ).
    cl_abap_unit_assert=>assert_equals( act = count
                                        exp = 0 ).
  ENDMETHOD.

  METHOD receive_without_send.
    DATA client TYPE REF TO if_http_client.
    client = make_client( '/echo' ).
    client->receive( EXCEPTIONS http_invalid_state = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->send( ).
    cl_abap_unit_assert=>assert_initial( client->response->get_header_field( '~status_code' ) ).
    client->receive( ).
  ENDMETHOD.

  METHOD reuse.
    DATA client TYPE REF TO if_http_client.
    DATA code TYPE i.
    DATA message TYPE string.
    client = make_client( '/gzip' ).
    client->send( ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_cdata( )
                                        exp = 'compressed' ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_header_field( '~status_code' )
                                        exp = '201' ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_header_field( '~status_reason' )
                                        exp = 'Created' ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_header_field( '~server_protocol' )
                                        exp = 'HTTP/1.1' ).
    client->request->set_header_field( name  = '~request_uri'
                                       value = '/reset' ).
    client->send( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->get_last_error( IMPORTING code = code message = message ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 0 ).
    cl_abap_unit_assert=>assert_true( xsdbool( message CS 'socket hang up' ) ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    " A zero stored error code preserves the response-status fallback.
    client->response->set_status( code   = 299
                                  reason = 'Fallback' ).
    client->get_last_error( IMPORTING code = code message = message ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 299 ).
    cl_abap_unit_assert=>assert_true( xsdbool( message CS 'socket hang up' ) ).
    client->request->set_header_field( name  = '~request_uri'
                                       value = '/echo' ).
    client->request->set_method( 'POST' ).
    client->request->set_data( 'C3A9FF00' ).
    client->request->set_header_field( name  = 'x-snapshot'
                                       value = 'sent' ).
    client->send( ).
    client->request->set_header_field( name  = 'x-snapshot'
                                       value = 'later' ).
    client->send( EXCEPTIONS http_invalid_state = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_data( )
                                        exp = 'C3A9FF00' ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_header_field( 'x-seen' )
                                        exp = 'sent' ).
    cl_abap_unit_assert=>assert_initial( client->response->get_header_field( 'content-encoding' ) ).
  ENDMETHOD.

  METHOD close_pending.
    DATA client TYPE REF TO if_http_client.
    client = make_client( '/stall' ).
    client->send( ).
    WRITE '@KERNEL await this.arrived;'.
    client->close( ).
    WRITE '@KERNEL await this.failed;'.
    client->receive( EXCEPTIONS http_invalid_state = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
  ENDMETHOD.

  METHOD retry_invalid_timeout.
    DATA client TYPE REF TO if_http_client.
    DATA code TYPE i.
    DATA message TYPE string.
    DATA requests TYPE i.
    client = make_client( '/echo' ).
    client->request->set_method( 'POST' ).
    client->request->set_cdata( 'retry' ).
    client->send( EXPORTING timeout = -5 EXCEPTIONS http_invalid_timeout = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->receive( EXCEPTIONS http_communication_failure = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    client->get_last_error( IMPORTING code = code message = message ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 17 ).
    cl_abap_unit_assert=>assert_equals(
      act = message
      exp = 'Internal error. Handle for this http session was not found or is NULL.' ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    client->response->get_status( IMPORTING code = code ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 0 ).
    WRITE '@KERNEL requests.set(this.requests);'.
    cl_abap_unit_assert=>assert_equals( act = requests
                                        exp = 0 ).
    client->send( EXCEPTIONS OTHERS = 1 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_cdata( )
                                        exp = 'retry' ).
    client->get_last_error( IMPORTING code = code ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 200 ).
    client->send( EXPORTING timeout = -5 EXCEPTIONS http_invalid_timeout = 1 OTHERS = 2 ).
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    cl_abap_unit_assert=>assert_initial( client->response->get_header_field( '~status_code' ) ).
  ENDMETHOD.

  METHOD response_until_receive.
    DATA client TYPE REF TO if_http_client.
    DATA code TYPE i.
    client = make_client( '/gzip' ).
    client->send( ).
    client->receive( ).
    client->request->set_header_field( name  = '~request_uri'
                                       value = '/echo' ).
    client->request->set_method( 'POST' ).
    client->request->set_cdata( 'next' ).
    client->send( ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_cdata( )
                                        exp = 'compressed' ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_header_field( 'content-encoding' )
                                        exp = 'gzip' ).
    client->response->get_status( IMPORTING code = code ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 201 ).
    client->receive( ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_cdata( )
                                        exp = 'next' ).
    cl_abap_unit_assert=>assert_initial( client->response->get_header_field( 'content-encoding' ) ).
    client->response->get_status( IMPORTING code = code ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 200 ).
  ENDMETHOD.

  METHOD repeated_receive.
    DATA client TYPE REF TO if_http_client.
    DATA response TYPE REF TO if_http_response.
    DATA code TYPE i.
    client = make_client( '/gzip' ).
    client->send( ).
    cl_abap_unit_assert=>assert_initial( client->response->get_data( ) ).
    client->receive( ).
    response = client->response.
    client->receive( EXCEPTIONS OTHERS = 1 ).
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    cl_abap_unit_assert=>assert_equals( act = client->response
                                        exp = response ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_cdata( )
                                        exp = 'compressed' ).
    cl_abap_unit_assert=>assert_equals( act = client->response->get_header_field( 'content-encoding' )
                                        exp = 'gzip' ).
    client->response->get_status( IMPORTING code = code ).
    cl_abap_unit_assert=>assert_equals( act = code
                                        exp = 201 ).
  ENDMETHOD.
ENDCLASS.
