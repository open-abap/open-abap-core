INTERFACE if_http_server PUBLIC.

  DATA response TYPE REF TO if_http_response.
  DATA request TYPE REF TO if_http_request.

  METHODS:
    logoff IMPORTING redirect_url TYPE string OPTIONAL,
    set_session_stateful.

ENDINTERFACE.