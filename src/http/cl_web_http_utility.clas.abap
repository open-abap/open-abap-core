CLASS cl_web_http_utility DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS unescape_url
      IMPORTING
        escaped          TYPE string
        options          TYPE i OPTIONAL
      RETURNING
        VALUE(unescaped) TYPE string.

    CLASS-METHODS decode_x_base64
      IMPORTING
        encoded        TYPE string
      RETURNING
        VALUE(decoded) TYPE xstring.

    CLASS-METHODS encode_x_base64
      IMPORTING
        unencoded      TYPE xstring
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS decode_base64
      IMPORTING
        encoded        TYPE string
      RETURNING
        VALUE(decoded) TYPE string.

    CLASS-METHODS encode_base64
      IMPORTING
        unencoded      TYPE string
      RETURNING
        VALUE(encoded) TYPE string.

    CLASS-METHODS decode_utf8
      IMPORTING
        encoded          TYPE xstring
      RETURNING
        VALUE(unencoded) TYPE string.
      " RAISING
      "   cx_web_http_conversion_failed.

ENDCLASS.

CLASS cl_web_http_utility IMPLEMENTATION.
  METHOD decode_utf8.
    unencoded = cl_abap_codepage=>convert_from( encoded ).
  ENDMETHOD.

  METHOD decode_base64.
    decoded = cl_abap_codepage=>convert_from( cl_http_utility=>decode_x_base64( encoded ) ).
  ENDMETHOD.

  METHOD encode_base64.
    encoded = cl_http_utility=>encode_x_base64( cl_abap_codepage=>convert_to( unencoded ) ).
  ENDMETHOD.

  METHOD unescape_url.
    unescaped = cl_http_utility=>unescape_url(
      escaped = escaped
      options = options ).
  ENDMETHOD.

  METHOD decode_x_base64.
    decoded = cl_http_utility=>decode_x_base64( encoded ).
  ENDMETHOD.

  METHOD encode_x_base64.
    encoded = cl_http_utility=>encode_x_base64( unencoded ).
  ENDMETHOD.

ENDCLASS.