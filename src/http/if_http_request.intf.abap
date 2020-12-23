INTERFACE if_http_request PUBLIC.

  METHODS:
    set_header_field
      IMPORTING
        name TYPE string
        value TYPE string.

  METHODS:
    get_header_field
      IMPORTING
        field TYPE string.

ENDINTERFACE.