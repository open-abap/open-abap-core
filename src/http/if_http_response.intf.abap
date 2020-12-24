INTERFACE if_http_response PUBLIC.

  METHODS:
    get_header_field
      IMPORTING
        field TYPE string
      RETURNING
        VALUE(value) TYPE string.

ENDINTERFACE.