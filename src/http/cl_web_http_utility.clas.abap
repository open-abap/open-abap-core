CLASS cl_web_http_utility DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS unescape_url
      IMPORTING
        escaped TYPE string
        options TYPE i OPTIONAL
      RETURNING
        VALUE(unescaped) TYPE string.
ENDCLASS.

CLASS cl_web_http_utility IMPLEMENTATION.
  METHOD unescape_url.
    unescaped = cl_http_utility=>unescape_url(
      escaped = escaped
      options = options ).
  ENDMETHOD.
ENDCLASS.