CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic_get FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic_get.

    DATA li_client TYPE REF TO if_http_client.
    DATA lv_code TYPE i.

    cl_http_client=>create_by_url(
      EXPORTING
        url    = 'https://httpbin.org/get'
        ssl_id = 'ANONYM'
      IMPORTING
        client = li_client ).
    li_client->send( ).
    li_client->receive( ).
    li_client->response->get_status( IMPORTING code = lv_code ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_code
      exp = 200 ).

  ENDMETHOD.

ENDCLASS.