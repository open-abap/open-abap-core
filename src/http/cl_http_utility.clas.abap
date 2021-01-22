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

    CLASS-METHODS string_to_fields
      IMPORTING
        string TYPE string
      RETURNING
        VALUE(fields) TYPE tihttpnvp.

    CLASS-METHODS set_query
      IMPORTING
        request TYPE REF TO if_http_request
        query   TYPE string.

ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.

  METHOD string_to_fields.
    RETURN.
  ENDMETHOD.

  METHOD set_query.
    request->set_form_fields( cl_http_utility=>string_to_fields( query ) ).
  ENDMETHOD.

  METHOD fields_to_string.
    RETURN.
  ENDMETHOD.

  METHOD decode_x_base64.
    WRITE '@KERNEL let buffer = Buffer.from(encoded.get(), "base64");'.
    WRITE '@KERNEL decoded.set(buffer.toString("hex"));'.
  ENDMETHOD.

  METHOD unescape_url.
    " todo, this can probably be done in ABAP with a few regex'es
    WRITE '@KERNEL unescaped.set(decodeURI(escaped.get()));'.
  ENDMETHOD.

  METHOD encode_base64.
    WRITE '@KERNEL let buffer = Buffer.from(data.get());'.
    WRITE '@KERNEL encoded.set(buffer.toString("base64"));'.
  ENDMETHOD.
ENDCLASS.