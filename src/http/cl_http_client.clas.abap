CLASS cl_http_client DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create_by_url
      IMPORTING
        url TYPE string
        ssl_id TYPE string OPTIONAL
        proxy_host TYPE string OPTIONAL
        proxy_service TYPE string OPTIONAL
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.
ENDCLASS.

CLASS cl_http_client IMPLEMENTATION.
  METHOD create_by_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.