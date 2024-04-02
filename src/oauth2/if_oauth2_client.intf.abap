INTERFACE if_oauth2_client PUBLIC.

  CONSTANTS c_param_kind_header_field TYPE string VALUE 'H'.
  CONSTANTS c_param_kind_form_field   TYPE string VALUE 'F'.

  METHODS execute_cc_flow
    RAISING
      cx_oa2c.

  METHODS set_token
    IMPORTING
      io_http_client TYPE REF TO if_http_client
      i_param_kind   TYPE string OPTIONAL
    RAISING
      cx_oa2c.

ENDINTERFACE.