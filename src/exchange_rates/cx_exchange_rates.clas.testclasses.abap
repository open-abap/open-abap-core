CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS default_textid FOR TESTING RAISING cx_static_check.
    METHODS given_textid FOR TESTING RAISING cx_static_check.
    METHODS previous FOR TESTING RAISING cx_static_check.
    METHODS raise_and_catch FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD default_textid.
    DATA lo_error TYPE REF TO cx_exchange_rates.
    CREATE OBJECT lo_error.
    cl_abap_unit_assert=>assert_equals(
      act = lo_error->if_t100_message~t100key
      exp = if_t100_message=>default_textid ).
  ENDMETHOD.

  METHOD given_textid.
    DATA lo_error TYPE REF TO cx_exchange_rates.
    DATA ls_textid TYPE scx_t100key.
    ls_textid-msgid = 'ZZ'.
    ls_textid-msgno = '001'.
    CREATE OBJECT lo_error
      EXPORTING
        textid = ls_textid.
    cl_abap_unit_assert=>assert_equals(
      act = lo_error->if_t100_message~t100key
      exp = ls_textid ).
  ENDMETHOD.

  METHOD previous.
    DATA lo_previous TYPE REF TO cx_sy_conversion_no_number.
    DATA lo_error    TYPE REF TO cx_exchange_rates.
    CREATE OBJECT lo_previous.
    CREATE OBJECT lo_error
      EXPORTING
        previous = lo_previous.
    cl_abap_unit_assert=>assert_equals(
      act = lo_error->previous
      exp = lo_previous ).
  ENDMETHOD.

  METHOD raise_and_catch.
    DATA lo_error TYPE REF TO cx_static_check.
    TRY.
        RAISE EXCEPTION TYPE cx_exchange_rates.
      CATCH cx_static_check INTO lo_error.
        cl_abap_unit_assert=>assert_not_initial( lo_error->get_text( ) ).
        RETURN.
    ENDTRY.
    cl_abap_unit_assert=>fail( 'not raised' ).
  ENDMETHOD.

ENDCLASS.
