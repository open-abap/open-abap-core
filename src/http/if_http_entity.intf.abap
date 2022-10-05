INTERFACE if_http_entity PUBLIC.

  CONSTANTS co_request_method_get TYPE string VALUE 'GET'.
  CONSTANTS co_request_method_post TYPE string VALUE 'POST'.

  METHODS set_cdata
    IMPORTING
      data   TYPE string
      offset TYPE i OPTIONAL
      length TYPE i OPTIONAL.

  METHODS set_data
    IMPORTING
      data TYPE xstring.

  METHODS get_header_field
    IMPORTING
      name TYPE string
    RETURNING
      VALUE(value) TYPE string.

  METHODS set_header_field
    IMPORTING
      name  TYPE string
      value TYPE string.

  METHODS get_form_fields
    CHANGING
      fields TYPE tihttpnvp.

  METHODS set_compression.

  METHODS add_multipart
    IMPORTING
      suppress_content_length TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(entity) TYPE REF TO if_http_entity.

  METHODS append_cdata IMPORTING data TYPE clike.

  METHODS get_form_field IMPORTING name TYPE string RETURNING VALUE(value) TYPE string.

  METHODS get_cdata RETURNING VALUE(data) TYPE string.

  METHODS get_content_type
    RETURNING VALUE(val) TYPE string.

  METHODS get_serialized_message_length
    EXPORTING
      VALUE(body_length) TYPE i
      VALUE(header_length) TYPE i.

  METHODS set_content_type
    IMPORTING
      content_type TYPE string.

  METHODS get_data
    RETURNING
      VALUE(data) TYPE xstring.

  METHODS get_header_fields CHANGING fields TYPE any.

  METHODS to_xstring
    RETURNING
      VALUE(data) TYPE xstring.

  METHODS get_cookies CHANGING cookies TYPE any.

  METHODS add_cookie_field
    IMPORTING
      cookie_name TYPE string
      cookie_path TYPE string OPTIONAL
      field_name  TYPE string
      field_value TYPE string
      base64      TYPE i DEFAULT 1.

  METHODS append_cdata2
    IMPORTING
      data     TYPE string
      encoding TYPE i OPTIONAL
      offset   TYPE i OPTIONAL
      length   TYPE i OPTIONAL.

  METHODS append_data
    IMPORTING
      data   TYPE xstring
      offset TYPE i OPTIONAL
      length TYPE i OPTIONAL.

  METHODS delete_cookie_secure
    IMPORTING
      name TYPE string
      path TYPE string DEFAULT ``.

  METHODS delete_form_field
    IMPORTING
      name TYPE string.

  METHODS delete_form_field_secure
    IMPORTING
      name TYPE string.

  METHODS from_xstring
    IMPORTING
      data TYPE xstring.

  METHODS get_cookie
    IMPORTING
      name TYPE string
      path TYPE string DEFAULT ``
    EXPORTING
      value   TYPE string
      domain  TYPE string
      expires TYPE string
      secure  TYPE i.

  METHODS get_cookie_field
    IMPORTING
      cookie_name TYPE string
      cookie_path TYPE string OPTIONAL
      field_name  TYPE string
      base64       TYPE i DEFAULT 1
    RETURNING
      VALUE(field_value) TYPE string.

  METHODS get_data_length
    EXPORTING
      VALUE(data_length) TYPE i.

  METHODS get_form_fields_cs
    IMPORTING
      formfield_encoding TYPE i DEFAULT 0
      search_option      TYPE i DEFAULT 3
    CHANGING
      fields             TYPE tihttpnvp.

  METHODS get_form_field_cs
    IMPORTING
      name               TYPE string
      formfield_encoding TYPE i DEFAULT 0
      search_option      TYPE i DEFAULT 3
    RETURNING
      VALUE(value)       TYPE string.

  METHODS get_last_error
    RETURNING
      VALUE(rc) TYPE i.

  METHODS get_multipart
    IMPORTING
      index TYPE i
    RETURNING
      VALUE(entity) TYPE REF TO if_http_entity.

  METHODS get_version
    RETURNING
      VALUE(version) TYPE i.

  METHODS num_multiparts
    RETURNING
      VALUE(num) TYPE i.

  METHODS set_cookie
    IMPORTING
      name    TYPE string
      path    TYPE string DEFAULT ``
      value   TYPE string
      domain  TYPE string DEFAULT ``
      expires TYPE string DEFAULT ``
      secure  TYPE i DEFAULT 0.

  METHODS set_formfield_encoding
    IMPORTING
      formfield_encoding TYPE i.

  METHODS set_form_field
    IMPORTING
      name  TYPE string
      value TYPE string.

  METHODS set_form_fields
    IMPORTING
      fields TYPE tihttpnvp
      multivalue TYPE int4 DEFAULT 0.

  METHODS set_header_fields
    IMPORTING
      fields TYPE tihttpnvp.

  METHODS suppress_content_type
    IMPORTING
      suppress TYPE abap_bool DEFAULT abap_true.

  METHODS delete_cookie
    IMPORTING
      name TYPE string
      path TYPE string OPTIONAL.

  METHODS delete_header_field
    IMPORTING
      name TYPE string.

  METHODS delete_header_field_secure
    IMPORTING
      name TYPE string.

ENDINTERFACE.