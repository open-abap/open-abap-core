CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS raise_and_catch FOR TESTING.
    METHODS default_textid FOR TESTING.
    METHODS locked_by_user FOR TESTING.
    METHODS previous FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD raise_and_catch.
    DATA lx_error TYPE REF TO cx_abap_foreign_lock.

    TRY.
        RAISE EXCEPTION TYPE cx_abap_foreign_lock
          EXPORTING
            user_name = 'OTHER'.
      CATCH cx_abap_foreign_lock INTO lx_error.
        cl_abap_unit_assert=>assert_equals(
          act = lx_error->user_name
          exp = 'OTHER' ).
        cl_abap_unit_assert=>assert_not_initial( lx_error->get_text( ) ).
    ENDTRY.

    cl_abap_unit_assert=>assert_bound( lx_error ).
  ENDMETHOD.

  METHOD default_textid.
    DATA lx_error TYPE REF TO cx_abap_foreign_lock.

    CREATE OBJECT lx_error.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key
      exp = cx_abap_foreign_lock=>cx_abap_foreign_lock ).
    cl_abap_unit_assert=>assert_initial( lx_error->user_name ).
  ENDMETHOD.

  METHOD locked_by_user.
    DATA lx_error TYPE REF TO cx_abap_foreign_lock.

    CREATE OBJECT lx_error
      EXPORTING
        textid    = cx_abap_foreign_lock=>object_locked_by_user
        user_name = 'OTHER'.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key
      exp = cx_abap_foreign_lock=>object_locked_by_user ).
  ENDMETHOD.

  METHOD previous.
    DATA lx_previous TYPE REF TO cx_abap_lock_failure.
    DATA lx_error    TYPE REF TO cx_abap_foreign_lock.

    CREATE OBJECT lx_previous.
    CREATE OBJECT lx_error
      EXPORTING
        previous = lx_previous.

    cl_abap_unit_assert=>assert_equals(
      act = lx_error->previous
      exp = lx_previous ).
  ENDMETHOD.

ENDCLASS.
