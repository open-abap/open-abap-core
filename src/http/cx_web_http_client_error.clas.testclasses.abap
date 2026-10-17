CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS default_textid FOR TESTING RAISING cx_static_check.
    METHODS given_textid FOR TESTING RAISING cx_static_check.
    METHODS previous FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD default_textid.

    DATA lx_error TYPE REF TO cx_web_http_client_error.

    TRY.
        RAISE EXCEPTION TYPE cx_web_http_client_error.
      CATCH cx_web_http_client_error INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key
          exp = if_t100_message=>default_textid ).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->get_message_id( )
          exp = if_t100_message=>default_textid-msgno ).
    ENDTRY.

  ENDMETHOD.

  METHOD given_textid.

    DATA lx_error  TYPE REF TO cx_web_http_client_error.
    DATA ls_textid TYPE scx_t100key.

    ls_textid-msgid = 'ZTEST'.
    ls_textid-msgno = '042'.

    TRY.
        RAISE EXCEPTION TYPE cx_web_http_client_error
          EXPORTING
            textid = ls_textid.
      CATCH cx_web_http_client_error INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->if_t100_message~t100key
          exp = ls_textid ).
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->get_message_id( )
          exp = '042' ).
    ENDTRY.

  ENDMETHOD.

  METHOD previous.

    DATA lx_previous TYPE REF TO cx_web_message_error.
    DATA lx_error    TYPE REF TO cx_static_check.

    CREATE OBJECT lx_previous.

    TRY.
        RAISE EXCEPTION TYPE cx_web_http_client_error
          EXPORTING
            previous = lx_previous.
      CATCH cx_static_check INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->previous
          exp = lx_previous ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
