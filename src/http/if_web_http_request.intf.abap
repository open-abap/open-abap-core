INTERFACE if_web_http_request PUBLIC.

  TYPES:
    BEGIN OF name_value_pair,
      name  TYPE string,
      value TYPE string,
    END OF name_value_pair.

  TYPES:
    BEGIN OF cookie,
      name    TYPE string,
      value   TYPE string,
      domain  TYPE string,
      path    TYPE string,
      secure  TYPE int4,
      expires TYPE string,
    END OF cookie.

  TYPES
    name_value_pairs TYPE STANDARD TABLE OF name_value_pair WITH NON-UNIQUE KEY name.

  TYPES
    cookies TYPE STANDARD TABLE OF cookie WITH NON-UNIQUE KEY name path.

  CONSTANTS co_protocol_version_1_0       TYPE i VALUE 1000.
  CONSTANTS co_protocol_version_1_1       TYPE i VALUE 1001.
  CONSTANTS co_formfield_encoding_raw     TYPE i VALUE 1.
  CONSTANTS co_formfield_encoding_encoded TYPE i VALUE 2.

  METHODS get_method
    RETURNING
      VALUE(r_value) TYPE string
    RAISING
      cx_web_message_error.

  METHODS get_header_field
    IMPORTING
      i_name         TYPE string
    RETURNING
      VALUE(r_value) TYPE string
    RAISING
      cx_web_message_error.

  METHODS get_header_fields
    RETURNING
      VALUE(r_value) TYPE name_value_pairs
    RAISING
      cx_web_message_error.

  METHODS set_header_field
    IMPORTING
      i_name         TYPE string
      i_value        TYPE string
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS set_header_fields
    IMPORTING
      i_fields       TYPE name_value_pairs
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS get_text
    RETURNING
      VALUE(r_value) TYPE string
    RAISING
      cx_web_message_error.

  METHODS set_text
    IMPORTING
      i_text         TYPE string
      i_offset       TYPE i DEFAULT 0
      i_length       TYPE i DEFAULT -1
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
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

  METHODS set_binary
    IMPORTING
      i_data         TYPE xstring
      i_offset       TYPE i DEFAULT 0
      i_length       TYPE i DEFAULT -1
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS get_form_field
    IMPORTING
      i_name               TYPE string
      i_formfield_encoding TYPE i DEFAULT 0
    RETURNING
      VALUE(r_value)       TYPE string
    RAISING
      cx_web_message_error.

  METHODS get_form_fields
    IMPORTING
      i_formfield_encoding TYPE i DEFAULT 0
    RETURNING
      VALUE(r_value)       TYPE name_value_pairs
    RAISING
      cx_web_message_error.

  METHODS set_form_field
    IMPORTING
      i_name         TYPE string
      i_value        TYPE string
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS set_form_fields
    IMPORTING
      i_fields       TYPE name_value_pairs
      i_multivalue   TYPE int4 DEFAULT 0
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS set_uri_path
    IMPORTING
      i_uri_path     TYPE string
      multivalue     TYPE int4 DEFAULT 0
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS add_multipart
    IMPORTING
      suppress_content_length TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(r_value)          TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS get_multipart
    IMPORTING
      index          TYPE i
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS num_multiparts
    RETURNING
      VALUE(num) TYPE i
    RAISING
      cx_web_message_error.

  METHODS get_cookie
    IMPORTING
      i_name         TYPE string
      i_path         TYPE string DEFAULT ``
    RETURNING
      VALUE(r_value) TYPE cookie
    RAISING
      cx_web_message_error.

  METHODS get_cookies
    RETURNING
      VALUE(r_value) TYPE cookies
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
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS set_authorization_basic
    IMPORTING
      i_username     TYPE string
      i_password     TYPE string
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS set_authorization_bearer
    IMPORTING
      i_bearer       TYPE string
    RETURNING
      VALUE(r_value) TYPE REF TO if_web_http_request
    RAISING
      cx_web_message_error.

  METHODS append_text
    IMPORTING
      data   TYPE string
      offset TYPE i DEFAULT 0
      length TYPE i DEFAULT -1.

  METHODS append_binary
    IMPORTING
      data   TYPE xstring
      offset TYPE i DEFAULT 0
      length TYPE i DEFAULT -1.

  METHODS set_query
    IMPORTING
      query TYPE string.

  METHODS set_version
    IMPORTING
      version TYPE i DEFAULT co_protocol_version_1_0.

  METHODS set_content_type
    IMPORTING
      content_type TYPE string.

  METHODS get_content_type
    RETURNING
      VALUE(content_type) TYPE string.

  METHODS delete_header_field
    IMPORTING
      name TYPE string.

  METHODS get_last_error
    RETURNING
      VALUE(rc) TYPE i.

  METHODS get_data_length
    EXPORTING
      data_length TYPE i.

  METHODS set_formfield_encoding
    IMPORTING
      formfield_encoding TYPE i.

  METHODS to_xstring
    RETURNING
      VALUE(data) TYPE xstring.

  METHODS from_xstring
    IMPORTING
      data TYPE xstring.

ENDINTERFACE.
