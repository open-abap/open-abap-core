INTERFACE if_http_response PUBLIC.

  METHODS get_header_field
    IMPORTING
      name TYPE string
    RETURNING
      VALUE(value) TYPE string.

  METHODS get_status
    EXPORTING
      code   TYPE i
      reason TYPE string.

  METHODS get_cdata
    RETURNING
      VALUE(data) TYPE string.

  METHODS get_content_type
    RETURNING
      VALUE(val) TYPE string.

  METHODS set_content_type
    IMPORTING
      val TYPE string.

  METHODS get_data
    RETURNING VALUE(val) TYPE xstring.

  METHODS set_data
    IMPORTING val TYPE xstring.

  METHODS get_header_fields
    CHANGING
      fields TYPE tihttpnvp.

  METHODS
    set_header_field
      IMPORTING
        name TYPE string
        value TYPE string.

  METHODS
    set_status
      IMPORTING
        code   TYPE i
        reason TYPE string.

  METHODS set_cdata IMPORTING data TYPE string.

  METHODS set_cookie
    IMPORTING
      name    TYPE string
      value   TYPE string
      path    TYPE string OPTIONAL
      domain  TYPE string OPTIONAL
      expires TYPE string OPTIONAL
      secure  TYPE i OPTIONAL.

  METHODS delete_cookie_at_client
    IMPORTING
      name   TYPE string
      path   TYPE string OPTIONAL
      domain TYPE string OPTIONAL.

  METHODS delete_header_field
    IMPORTING
      name TYPE string.

  METHODS redirect
    IMPORTING
      url                TYPE string
      permanently        TYPE i OPTIONAL
      protocol_dependent TYPE i OPTIONAL.

ENDINTERFACE.