INTERFACE if_http_request PUBLIC.

  CONSTANTS:
    co_protocol_version_1_1 TYPE string VALUE 'VER11',
    co_protocol_version_1_0 TYPE string VALUE 'VER10',
    co_request_method_get TYPE string VALUE 'GET',
    co_request_method_post TYPE string VALUE 'POST'.

  METHODS
    set_header_field
      IMPORTING
        name TYPE string
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

ENDINTERFACE.