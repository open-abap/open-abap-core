INTERFACE if_http_response PUBLIC.

  INTERFACES if_http_entity.

  ALIASES get_header_field FOR if_http_entity~get_header_field.
  ALIASES get_cdata FOR if_http_entity~get_cdata.
  ALIASES get_content_type FOR if_http_entity~get_content_type.
  ALIASES set_content_type FOR if_http_entity~set_content_type.
  ALIASES get_data FOR if_http_entity~get_data.
  ALIASES set_data FOR if_http_entity~set_data.
  ALIASES get_header_fields FOR if_http_entity~get_header_fields.
  ALIASES set_header_field FOR if_http_entity~set_header_field.
  ALIASES set_cdata FOR if_http_entity~set_cdata.
  ALIASES append_cdata FOR if_http_entity~append_cdata.
  ALIASES set_cookie FOR if_http_entity~set_cookie.
  ALIASES delete_header_field FOR if_http_entity~delete_header_field.

  METHODS get_status
    EXPORTING
      code   TYPE i
      reason TYPE string.

  METHODS set_status
    IMPORTING
      code   TYPE i
      reason TYPE string.

  METHODS delete_cookie_at_client
    IMPORTING
      name   TYPE string
      path   TYPE string OPTIONAL
      domain TYPE string OPTIONAL.

  METHODS redirect
    IMPORTING
      url                TYPE string
      permanently        TYPE i OPTIONAL
      protocol_dependent TYPE i OPTIONAL.

ENDINTERFACE.