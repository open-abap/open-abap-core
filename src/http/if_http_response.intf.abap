INTERFACE if_http_response PUBLIC.

  INTERFACES if_http_entity.

  ALIASES add_cookie_field FOR if_http_entity~add_cookie_field.
  ALIASES add_multipart FOR if_http_entity~add_multipart.
  ALIASES append_cdata FOR if_http_entity~append_cdata.
  ALIASES append_cdata2 FOR if_http_entity~append_cdata2.
  ALIASES append_data FOR if_http_entity~append_data.
  ALIASES co_compress_based_on_mime_type FOR if_http_entity~co_compress_based_on_mime_type.
  ALIASES co_protocol_version_1_0 FOR if_http_entity~co_protocol_version_1_0.
  ALIASES co_protocol_version_1_1 FOR if_http_entity~co_protocol_version_1_1.
  ALIASES co_request_method_get FOR if_http_entity~co_request_method_get.
  ALIASES co_request_method_post FOR if_http_entity~co_request_method_post.
  ALIASES delete_cookie FOR if_http_entity~delete_cookie.
  ALIASES delete_cookie_secure FOR if_http_entity~delete_cookie_secure.
  ALIASES delete_form_field FOR if_http_entity~delete_form_field.
  ALIASES delete_form_field_secure FOR if_http_entity~delete_form_field_secure.
  ALIASES delete_header_field FOR if_http_entity~delete_header_field.
  ALIASES delete_header_field_secure FOR if_http_entity~delete_header_field_secure.
  ALIASES from_xstring FOR if_http_entity~from_xstring.
  ALIASES get_cdata FOR if_http_entity~get_cdata.
  ALIASES get_content_type FOR if_http_entity~get_content_type.
  ALIASES get_cookie FOR if_http_entity~get_cookie.
  ALIASES get_cookie_field FOR if_http_entity~get_cookie_field.
  ALIASES get_cookies FOR if_http_entity~get_cookies.
  ALIASES get_data FOR if_http_entity~get_data.
  ALIASES get_form_field FOR if_http_entity~get_form_field.
  ALIASES get_form_field_cs FOR if_http_entity~get_form_field_cs.
  ALIASES get_form_fields FOR if_http_entity~get_form_fields.
  ALIASES get_form_fields_cs FOR if_http_entity~get_form_fields_cs.
  ALIASES get_header_field FOR if_http_entity~get_header_field.
  ALIASES get_header_fields FOR if_http_entity~get_header_fields.
  ALIASES get_last_error FOR if_http_entity~get_last_error.
  ALIASES get_multipart FOR if_http_entity~get_multipart.
  ALIASES get_serialized_message_length FOR if_http_entity~get_serialized_message_length.
  ALIASES get_version FOR if_http_entity~get_version.
  ALIASES num_multiparts FOR if_http_entity~num_multiparts.
  ALIASES set_cdata FOR if_http_entity~set_cdata.
  ALIASES set_compression FOR if_http_entity~set_compression.
  ALIASES set_content_type FOR if_http_entity~set_content_type.
  ALIASES set_cookie FOR if_http_entity~set_cookie.
  ALIASES set_data FOR if_http_entity~set_data.
  ALIASES set_formfield_encoding FOR if_http_entity~set_formfield_encoding.
  ALIASES set_form_field FOR if_http_entity~set_form_field.
  ALIASES set_form_fields FOR if_http_entity~set_form_fields.
  ALIASES set_header_field FOR if_http_entity~set_header_field.
  ALIASES set_header_fields FOR if_http_entity~set_header_fields.
  ALIASES suppress_content_type FOR if_http_entity~suppress_content_type.
  ALIASES to_xstring FOR if_http_entity~to_xstring.

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
      explanation        TYPE string OPTIONAL
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