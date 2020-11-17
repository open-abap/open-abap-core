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
ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.
  METHOD decode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(encoded.get(), "base64");'.
    WRITE '@KERNEL decoded.set(buffer.toString("hex"));'.
  ENDMETHOD.

  METHOD unescape_url.
    WRITE '@KERNEL unescaped.set(decodeURI(escaped.get()));'.
  ENDMETHOD.
ENDCLASS.