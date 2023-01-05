CLASS cl_http_server DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS get_location
      IMPORTING
        application TYPE csequence OPTIONAL
      EXPORTING
        port         TYPE string
        out_protocol TYPE string
        host         TYPE string.
ENDCLASS.

CLASS cl_http_server IMPLEMENTATION.
  METHOD get_location.
    host = 'open-abap.org'.
  ENDMETHOD.
ENDCLASS.