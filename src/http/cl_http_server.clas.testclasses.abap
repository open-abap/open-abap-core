CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_location FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD get_location.

    DATA lv_host TYPE string.

    cl_http_server=>get_location( IMPORTING host = lv_host ).

    cl_abap_unit_assert=>assert_not_initial( lv_host ).

  ENDMETHOD.

ENDCLASS.