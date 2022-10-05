INTERFACE if_http_extension PUBLIC.

  DATA flow_rc TYPE i.

  METHODS handle_request IMPORTING server TYPE REF TO if_http_server.

ENDINTERFACE.