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

  METHODS get_data
    RETURNING VALUE(val) TYPE xstring.

ENDINTERFACE.