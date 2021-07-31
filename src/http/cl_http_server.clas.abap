CLASS cl_http_server DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS get_location
      EXPORTING
        host TYPE string.
ENDCLASS.

CLASS cl_http_server IMPLEMENTATION.
  METHOD get_location.
    host = 'open-abap.org'.
  ENDMETHOD.
ENDCLASS.