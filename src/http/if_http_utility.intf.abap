INTERFACE if_http_utility PUBLIC.

  CLASS-METHODS string_to_fields
    IMPORTING
      string             TYPE string
      ignore_parenthesis TYPE i DEFAULT 0
    RETURNING
      VALUE(fields)      TYPE tihttpnvp.

  CLASS-METHODS get_last_error
    RETURNING
      VALUE(rc) TYPE i.

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

  CLASS-METHODS encode_base64
    IMPORTING
      unencoded TYPE string
    RETURNING
      VALUE(encoded) TYPE string.

  CLASS-METHODS fields_to_string
    IMPORTING
      fields TYPE tihttpnvp
    RETURNING
      VALUE(string) TYPE string.

  CLASS-METHODS decode_base64
    IMPORTING
      encoded        TYPE string
    RETURNING
      VALUE(decoded) TYPE string.

  CLASS-METHODS normalize_url
    IMPORTING
      unnormalized      TYPE string
    RETURNING
      VALUE(normalized) TYPE string.

ENDINTERFACE.