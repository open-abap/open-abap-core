INTERFACE if_http_service_extension PUBLIC.

  METHODS handle_request
    IMPORTING
      request  TYPE REF TO if_web_http_request
      response TYPE REF TO if_web_http_response.

ENDINTERFACE.
