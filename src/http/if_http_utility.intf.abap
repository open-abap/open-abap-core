INTERFACE if_http_utility PUBLIC.

  CLASS-METHODS string_to_fields
    IMPORTING
      string        TYPE string
    RETURNING
      VALUE(fields) TYPE tihttpnvp.

  CLASS-METHODS unescape_url
    IMPORTING
      escaped          TYPE string
      options          TYPE i OPTIONAL
    RETURNING
      VALUE(unescaped) TYPE string.

  CLASS-METHODS escape_url
    IMPORTING
      unescaped      TYPE string
    RETURNING
      VALUE(escaped) TYPE string.

ENDINTERFACE.