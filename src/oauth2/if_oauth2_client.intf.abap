INTERFACE if_oauth2_client PUBLIC.

  METHODS execute_cc_flow
    RAISING
      cx_static_check.

  METHODS set_token
    IMPORTING
      ii_http_client TYPE REF TO if_http_client
    RAISING
      cx_static_check.

ENDINTERFACE.