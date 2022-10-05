INTERFACE if_http_request PUBLIC.

  CONSTANTS:
    co_protocol_version_1_1 TYPE string VALUE 'VER11',
    co_protocol_version_1_0 TYPE string VALUE 'VER10',
    co_request_method_get TYPE string VALUE 'GET',
    co_request_method_post TYPE string VALUE 'POST'.

  METHODS
    set_header_field
      IMPORTING
        name  TYPE string
        value TYPE string.

  METHODS
    get_header_field
      IMPORTING
        name TYPE string
      RETURNING
        VALUE(value) TYPE string.

  METHODS get_header_fields CHANGING fields TYPE tihttpnvp.
  METHODS get_form_fields CHANGING fields TYPE tihttpnvp.
  METHODS get_form_field
    IMPORTING name TYPE string
    RETURNING VALUE(value) TYPE string.
  METHODS set_form_fields IMPORTING fields TYPE tihttpnvp.

  METHODS set_method IMPORTING method TYPE string.
  METHODS get_method RETURNING VALUE(meth) TYPE string.

  METHODS set_version
    IMPORTING
      version TYPE string.

  METHODS set_data IMPORTING data TYPE xstring.
  METHODS get_data RETURNING VALUE(data) TYPE xstring.
  METHODS set_cdata IMPORTING data TYPE string.
  METHODS get_cdata RETURNING VALUE(data) TYPE string.

  METHODS set_content_type
    IMPORTING
      val TYPE string.

  METHODS set_form_field
    IMPORTING
      name TYPE string
      value TYPE string.

  METHODS get_content_type
    RETURNING VALUE(type) TYPE string.

  METHODS get_form_fields_cs
    IMPORTING
      formfield_encoding TYPE i OPTIONAL
      search_option TYPE i OPTIONAL
    CHANGING
      fields TYPE any.

  METHODS num_multiparts
      RETURNING VALUE(val) TYPE i.

  METHODS get_multipart
    IMPORTING
      index TYPE i
    RETURNING
      VALUE(entity) TYPE REF TO if_http_entity.

  METHODS set_authorization
    IMPORTING
      auth_type TYPE i DEFAULT 1
      username  TYPE string
      password  TYPE string.

  METHODS add_multipart
    IMPORTING
      suppress_content_length TYPE abap_bool DEFAULT abap_false
    RETURNING
      VALUE(entity) TYPE REF TO if_http_entity.

  METHODS get_cookie_field
    IMPORTING
      cookie_name TYPE string
      cookie_path TYPE string OPTIONAL
      field_name  TYPE string
      base64      TYPE i DEFAULT 1
    RETURNING
      VALUE(field_value) TYPE string.

ENDINTERFACE.