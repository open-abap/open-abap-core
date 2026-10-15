CLASS cl_web_http_client_manager DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS create_by_http_destination
      IMPORTING
        i_destination   TYPE REF TO if_http_destination
      RETURNING
        VALUE(r_client) TYPE REF TO if_web_http_client
      RAISING
        cx_web_http_client_error.

ENDCLASS.

CLASS cl_web_http_client_manager IMPLEMENTATION.

  METHOD create_by_http_destination.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
