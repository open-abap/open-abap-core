CLASS cl_http_utility DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS decode_x_base64
      IMPORTING
        encoded TYPE string
      RETURNING
        VALUE(decoded) TYPE xstring.

    CLASS-METHODS unescape_url
      IMPORTING
        escaped TYPE string
      RETURNING
        VALUE(unescaped) TYPE string.

    CLASS-METHODS encode_base64
      IMPORTING
        data TYPE string
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS fields_to_string
      IMPORTING
        fields TYPE tihttpnvp
      RETURNING
        VALUE(string) TYPE string.
ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.

  METHOD fields_to_string.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD decode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(encoded.get(), "base64");'.
    WRITE '@KERNEL decoded.set(buffer.toString("hex"));'.
  ENDMETHOD.

  METHOD unescape_url.
    WRITE '@KERNEL unescaped.set(decodeURI(escaped.get()));'.
  ENDMETHOD.

  METHOD encode_base64.
    WRITE '@KERNEL let buffer = Buffer.from(data.get());'.
    WRITE '@KERNEL encoded.set(buffer.toString("base64"));'.
  ENDMETHOD.
ENDCLASS.