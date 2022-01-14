INTERFACE if_http_response PUBLIC.

  METHODS get_header_field
    IMPORTING
      field TYPE string
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

ENDINTERFACE.