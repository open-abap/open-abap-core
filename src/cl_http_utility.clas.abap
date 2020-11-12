CLASS cl_http_utility DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS decode_x_base64
      IMPORTING
        encoded TYPE string
      RETURNING
        VALUE(decoded) TYPE xstring.
ENDCLASS.

CLASS cl_http_utility IMPLEMENTATION.
  METHOD decode_x_base64.
* todo
    ASSERT 1 = 2.
  ENDMETHOD.
ENDCLASS.