INTERFACE if_http_client PUBLIC.
  DATA request TYPE REF TO if_http_request.
  DATA response TYPE REF TO if_http_response.
  DATA propertytype_logon_popup TYPE i.

  CONSTANTS co_disabled TYPE i VALUE 0.

  METHODS authenticate
    IMPORTING
      proxy_authentication TYPE abap_bool OPTIONAL
      username             TYPE string
      password             TYPE string.

  METHODS close.
  METHODS send
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
ENDINTERFACE.