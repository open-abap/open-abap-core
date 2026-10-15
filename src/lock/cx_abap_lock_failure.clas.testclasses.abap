CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS raise_and_catch FOR TESTING.
    METHODS default_textid FOR TESTING.
    METHODS attributes FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD raise_and_catch.
    DATA lx_error TYPE REF TO cx_abap_lock_failure.

    TRY.
        RAISE EXCEPTION TYPE cx_abap_lock_failure.
      CATCH cx_abap_lock_failure INTO lx_error.
        cl_abap_unit_assert=>assert_not_initial( lx_error->get_text( ) ).
    ENDTRY.

    cl_abap_unit_assert=>assert_bound( lx_error ).
  ENDMETHOD.

  METHOD default_textid.
    DATA lx_error TYPE REF TO cx_abap_lock_failure.

    CREATE OBJECT lx_error.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key
      exp = cx_abap_lock_failure=>cx_abap_lock_failure ).
  ENDMETHOD.

  METHOD attributes.
    DATA lx_error TYPE REF TO cx_abap_lock_failure.

    CREATE OBJECT lx_error
      EXPORTING
        textid           = cx_abap_lock_failure=>param_value_not_allowed
        field_name       = 'CARRID'
        field_value      = `LH`
        object_name      = 'EZLOCK'
        object_type_text = 'Lock Object'.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key
      exp = cx_abap_lock_failure=>param_value_not_allowed ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->field_name
      exp = 'CARRID' ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->field_value
      exp = `LH` ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->object_name
      exp = 'EZLOCK' ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->object_type_text
      exp = 'Lock Object' ).
  ENDMETHOD.

ENDCLASS.
