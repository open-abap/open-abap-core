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
  ALIASES set_compression FOR if_http_entity~set_compression.

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

  METHODS copy
    RETURNING
      VALUE(response) TYPE REF TO if_http_response.

  METHODS get_raw_message
    RETURNING
      VALUE(data) TYPE xstring.

  METHODS server_cache_browser_dependent
    IMPORTING
      dependent TYPE boolean DEFAULT abap_true.

  METHODS server_cache_expire_abs
    IMPORTING
      expires_abs_date  TYPE d OPTIONAL
      expires_abs_time  TYPE t OPTIONAL
      etag              TYPE char32 OPTIONAL
      browser_dependent TYPE boolean DEFAULT abap_false
      no_ufo_cache      TYPE boolean DEFAULT abap_false.

  METHODS server_cache_expire_default
    IMPORTING
      etag              TYPE char32 OPTIONAL
      browser_dependent TYPE boolean DEFAULT abap_false
      no_ufo_cache      TYPE boolean DEFAULT abap_false.

  METHODS server_cache_expire_rel
    IMPORTING
      expires_rel       TYPE i
      etag              TYPE char32 OPTIONAL
      browser_dependent TYPE boolean DEFAULT abap_false
      no_ufo_cache      TYPE boolean DEFAULT abap_false.
ENDINTERFACE.