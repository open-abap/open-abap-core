INTERFACE if_http_extension PUBLIC.

  METHODS handle_request IMPORTING server TYPE REF TO if_http_server.

ENDINTERFACE.