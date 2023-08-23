INTERFACE if_http_client PUBLIC.
  DATA request  TYPE REF TO if_http_request.
  DATA response TYPE REF TO if_http_response.

  DATA propertytype_logon_popup   TYPE i.
  DATA propertytype_accept_cookie TYPE i.
  DATA propertytype_redirect      TYPE i.

  CONSTANTS co_disabled TYPE i VALUE 0.
  CONSTANTS co_enabled  TYPE i VALUE 1.

  METHODS authenticate
    IMPORTING
      proxy_authentication TYPE abap_bool OPTIONAL
      username             TYPE string
      password             TYPE string.

  METHODS close.

  METHODS send
    IMPORTING
      timeout TYPE i DEFAULT 0
    EXCEPTIONS
      http_communication_failure
      http_invalid_state
      http_processing_failed
      http_invalid_timeout.

  METHODS receive
    EXCEPTIONS
      http_communication_failure
      http_invalid_state
      http_processing_failed.

  METHODS send_sap_logon_ticket.

  METHODS get_last_error
    EXPORTING
      code    TYPE i
      message TYPE string.

  METHODS refresh_request.

  METHODS create_abs_url
    IMPORTING
      path       TYPE string OPTIONAL
    RETURNING
      VALUE(url) TYPE string.

  CLASS-METHODS escape_url
    IMPORTING
      unescaped      TYPE string
    RETURNING
      VALUE(escaped) TYPE string.
ENDINTERFACE.