INTERFACE if_web_http_client PUBLIC.

  TYPES:
    BEGIN OF ENUM method,
      get,
      post,
      put,
      delete,
      head,
      options,
      patch,
      trace,
      connect,
    END OF ENUM method.

  DATA path_prefix TYPE string READ-ONLY.

  METHODS execute
    IMPORTING
      i_method          TYPE method
      i_timeout         TYPE i DEFAULT 0
    RETURNING
      VALUE(r_response) TYPE REF TO if_web_http_response
    RAISING
      cx_web_http_client_error.

  METHODS get_http_request
    RETURNING
      VALUE(r_http_request) TYPE REF TO if_web_http_request.

  METHODS close
    RAISING
      cx_web_http_client_error.

  METHODS set_csrf_token
    RAISING
      cx_web_http_client_error.

  METHODS accept_cookies
    IMPORTING
      i_allow TYPE abap_bool
    RAISING
      cx_web_http_client_error.

  METHODS set_authn_mode
    IMPORTING
      i_authn_mode TYPE if_a4c_cp_service=>authn_mode.

ENDINTERFACE.
