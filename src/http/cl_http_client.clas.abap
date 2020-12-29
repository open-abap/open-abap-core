CLASS cl_http_client DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_client.

    CLASS-METHODS create_by_url
      IMPORTING
        url TYPE string
        ssl_id TYPE string OPTIONAL
        proxy_host TYPE string OPTIONAL
        proxy_service TYPE string OPTIONAL
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.

    METHODS constructor
      IMPORTING
        url TYPE string.

  PRIVATE SECTION.
    DATA url TYPE string.

ENDCLASS.

CLASS cl_http_client IMPLEMENTATION.

  METHOD constructor.
    me->url = url.
  ENDMETHOD.

  METHOD create_by_url.
    CREATE OBJECT client TYPE cl_http_client
      EXPORTING
        url = url.
  ENDMETHOD.

  METHOD if_http_client~authenticate.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~close.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~send.
* note that fetch() also works in browsers, https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API

    WRITE '@KERNEL const response = globalThis.fetch(this.url.get());'.
    WRITE '@KERNEL console.dir(response);'.

    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~receive.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~get_last_error.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.