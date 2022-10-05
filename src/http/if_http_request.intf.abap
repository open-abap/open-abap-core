INTERFACE if_http_request PUBLIC.

  CONSTANTS:
    co_protocol_version_1_1 TYPE string VALUE 'VER11',
    co_protocol_version_1_0 TYPE string VALUE 'VER10',
    co_request_method_get TYPE string VALUE 'GET',
    co_request_method_post TYPE string VALUE 'POST'.

  ALIASES set_cdata FOR if_http_entity~set_cdata.
  ALIASES set_data FOR if_http_entity~set_data.
  ALIASES get_header_field FOR if_http_entity~get_header_field.
  ALIASES set_header_field FOR if_http_entity~set_header_field.
  ALIASES get_form_fields FOR if_http_entity~get_form_fields.
  ALIASES add_multipart FOR if_http_entity~add_multipart.
  ALIASES get_form_field FOR if_http_entity~get_form_field.
  ALIASES get_cdata FOR if_http_entity~get_cdata.
  ALIASES get_content_type FOR if_http_entity~get_content_type.
  ALIASES set_content_type FOR if_http_entity~set_content_type.
  ALIASES get_data FOR if_http_entity~get_data.
  ALIASES get_header_fields FOR if_http_entity~get_header_fields.
  ALIASES get_cookie_field FOR if_http_entity~get_cookie_field.
  ALIASES get_form_fields_cs FOR if_http_entity~get_form_fields_cs.
  ALIASES get_multipart FOR if_http_entity~get_multipart.
  ALIASES num_multiparts FOR if_http_entity~num_multiparts.
  ALIASES set_form_field FOR if_http_entity~set_form_field.
  ALIASES set_form_fields FOR if_http_entity~set_form_fields.

  METHODS set_method
    IMPORTING
      method TYPE string.

  METHODS get_method
    RETURNING
      VALUE(meth) TYPE string.

  METHODS set_version
    IMPORTING
      version TYPE string.

  METHODS set_authorization
    IMPORTING
      auth_type TYPE i DEFAULT 1
      username  TYPE string
      password  TYPE string.

ENDINTERFACE.