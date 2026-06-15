INTERFACE if_web_http_response PUBLIC.

  TYPES:
    BEGIN OF http_status,
      code   TYPE i,
      reason TYPE string,
    END OF http_status.

  CONSTANTS co_compress_none               TYPE i VALUE 0.
  CONSTANTS co_compress_in_all_cases       TYPE i VALUE 1.
  CONSTANTS co_compress_based_on_mime_type TYPE i VALUE 2.
  CONSTANTS co_formfield_encoding_raw      TYPE i VALUE 1.
  CONSTANTS co_formfield_encoding_encoded  TYPE i VALUE 2.

  METHODS set_status
    IMPORTING
      i_code         TYPE i
      i_reason       TYPE string OPTIONAL
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_status
    RETURNING
      VALUE(r_value) TYPE http_status
    RAISING
      cx_web_message_error.

  METHODS set_header_field
    IMPORTING
      i_name         TYPE string
      i_value        TYPE string
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_header_field
    IMPORTING
      i_name         TYPE string
    RETURNING
      VALUE(r_value) TYPE string
    RAISING
      cx_web_message_error.

  METHODS set_header_fields
    IMPORTING
      i_fields       TYPE if_web_http_request=>name_value_pairs
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_header_fields
    RETURNING
      VALUE(r_value) TYPE if_web_http_request=>name_value_pairs
    RAISING
      cx_web_message_error.

  METHODS set_text
    IMPORTING
      i_text         TYPE string
      i_offset       TYPE i DEFAULT 0
      i_length       TYPE i DEFAULT -1
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_text
    RETURNING
      VALUE(r_value) TYPE string
    RAISING
      cx_web_message_error.

  METHODS set_binary
    IMPORTING
      i_data         TYPE xstring
      i_offset       TYPE i DEFAULT 0
      i_length       TYPE i DEFAULT -1
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_binary
    IMPORTING
      i_offset       TYPE i DEFAULT 0
      i_length       TYPE i DEFAULT -1
    RETURNING
      VALUE(r_value) TYPE xstring
    RAISING
      cx_web_message_error.

  METHODS set_cookie
    IMPORTING
      i_name         TYPE string
      i_path         TYPE string DEFAULT ``
      i_value        TYPE string
      i_domain       TYPE string DEFAULT ``
      i_expires      TYPE string DEFAULT ``
      i_secure       TYPE i DEFAULT 0
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_cookie
    IMPORTING
      i_name         TYPE string
      i_path         TYPE string DEFAULT ``
    RETURNING
      VALUE(r_value) TYPE if_web_http_request=>cookie
    RAISING
      cx_web_message_error.

  METHODS get_cookies
    RETURNING
      VALUE(r_value) TYPE if_web_http_request=>cookies
    RAISING
      cx_web_message_error.

  METHODS delete_cookie_at_client
    IMPORTING
      name   TYPE string
      path   TYPE string DEFAULT ``
      domain TYPE string DEFAULT ``.

  METHODS add_multipart
    IMPORTING
      suppress_content_length TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(r_value)          TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS get_multipart
    IMPORTING
      index          TYPE i
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_response
    RAISING
      cx_web_message_error.

  METHODS num_multiparts
    RETURNING
      VALUE(num) TYPE i
    RAISING
      cx_web_message_error.

  METHODS set_compression
    IMPORTING
      disable_extended_checks TYPE abap_bool DEFAULT abap_false
      options                 TYPE i DEFAULT co_compress_based_on_mime_type.

  METHODS set_content_type
    IMPORTING
      content_type TYPE string.

  METHODS get_content_type
    RETURNING
      VALUE(content_type) TYPE string.

  METHODS suppress_content_type
    IMPORTING
      suppress TYPE abap_bool DEFAULT abap_true.

  METHODS delete_header_field
    IMPORTING
      name TYPE string.

  METHODS to_xstring
    RETURNING
      VALUE(data) TYPE xstring.

  METHODS from_xstring
    IMPORTING
      data TYPE xstring.

  METHODS get_data_length
    EXPORTING
      data_length TYPE i.

  METHODS set_formfield_encoding
    IMPORTING
      formfield_encoding TYPE i.

  METHODS get_last_error
    RETURNING
      VALUE(rc) TYPE i.

  METHODS server_cache_expire_rel
    IMPORTING
      expires_rel       TYPE i
      etag              TYPE char32 OPTIONAL
      browser_dependent TYPE boolean DEFAULT abap_false
      no_ufo_cache      TYPE boolean DEFAULT abap_false.

ENDINTERFACE.
