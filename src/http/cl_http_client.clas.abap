CLASS cl_http_client DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_http_client.

    CLASS-METHODS create_by_url
      IMPORTING
        url           TYPE string
        ssl_id        TYPE string OPTIONAL
        proxy_host    TYPE string OPTIONAL
        proxy_service TYPE string OPTIONAL
      EXPORTING
        VALUE(client) TYPE REF TO if_http_client.

    METHODS constructor
      IMPORTING
        url TYPE string.

  PRIVATE SECTION.
    DATA url TYPE string.
    DATA authorization TYPE string.

ENDCLASS.

CLASS cl_http_client IMPLEMENTATION.

  METHOD constructor.
* SSL_ID and proxies are currently ignored
    me->url = url.
    CREATE OBJECT if_http_client~response TYPE lcl_response.
  ENDMETHOD.

  METHOD create_by_url.
    CREATE OBJECT client TYPE cl_http_client
      EXPORTING
        url = url.
  ENDMETHOD.

  METHOD if_http_client~authenticate.

    DATA lv_base64 TYPE string.
    lv_base64 = cl_http_utility=>encode_base64( |{ username }:{ password }| ).
    authorization = |Basic { lv_base64 }|.

  ENDMETHOD.

  METHOD if_http_client~close.
* https://www.chromestatus.com/feature/5760375567941632
* https://github.com/node-fetch/node-fetch/issues/599
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_http_client~send.
* note that fetch() also works in browsers,
* https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
* https://caniuse.com/fetch

    WRITE '@KERNEL let response = await globalThis.fetch(this.url.get(), {headers: {"Authorization": this.authorization.get()}});'.
*    WRITE '@KERNEL console.dir(await response.text());'.

    WRITE '@KERNEL this.if_http_client$response.get().status.set(response.status);'.
    WRITE '@KERNEL this.if_http_client$response.get().cdata.set(await response.text());'.

  ENDMETHOD.

  METHOD if_http_client~receive.
* handled in send()
    RETURN.
  ENDMETHOD.

  METHOD if_http_client~get_last_error.
    if_http_client~response->get_status( IMPORTING code = code ).
    message = 'todo_open_abap'.
  ENDMETHOD.

ENDCLASS.