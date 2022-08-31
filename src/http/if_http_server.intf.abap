INTERFACE if_http_server PUBLIC.

  DATA response TYPE REF TO if_http_response.
  DATA request TYPE REF TO if_http_request.

  CONSTANTS co_disabled TYPE i VALUE 0.
  CONSTANTS co_enabled TYPE i VALUE 1.

  CLASS-DATA session_id TYPE string READ-ONLY.

  METHODS:
    logoff IMPORTING redirect_url TYPE string OPTIONAL,
    set_session_stateful.

ENDINTERFACE.