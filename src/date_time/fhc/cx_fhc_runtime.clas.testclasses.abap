CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS textid_default FOR TESTING RAISING cx_static_check.
    METHODS textid_given FOR TESTING RAISING cx_static_check.
    METHODS attributes FOR TESTING RAISING cx_static_check.
    METHODS previous FOR TESTING RAISING cx_static_check.
    METHODS catch_static_check FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD textid_default.
    DATA lx_error TYPE REF TO cx_fhc_runtime.
    CREATE OBJECT lx_error.
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key
      exp = if_t100_message=>default_textid ).
  ENDMETHOD.

  METHOD textid_given.
    DATA lx_error TYPE REF TO cx_fhc_runtime.
    CREATE OBJECT lx_error
      EXPORTING
        textid = cx_fhc_runtime=>date_out_of_validity.
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key-msgid
      exp = 'FHC_RUNTIME' ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key-msgno
      exp = '109' ).
  ENDMETHOD.

  METHOD attributes.
    DATA lx_error TYPE REF TO cx_fhc_runtime.
    CREATE OBJECT lx_error
      EXPORTING
        textid     = cx_fhc_runtime=>easter_year_out_of_range
        attribute1 = `1582`
        attribute4 = `four`.
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->attribute1
      exp = `1582` ).
    cl_abap_unit_assert=>assert_initial( lx_error->attribute2 ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->attribute4
      exp = `four` ).
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->if_t100_message~t100key-attr1
      exp = 'ATTRIBUTE1' ).
  ENDMETHOD.

  METHOD previous.
    DATA lx_previous TYPE REF TO cx_fhc_runtime.
    DATA lx_error    TYPE REF TO cx_fhc_runtime.
    CREATE OBJECT lx_previous.
    CREATE OBJECT lx_error
      EXPORTING
        previous = lx_previous.
    cl_abap_unit_assert=>assert_equals(
      act = lx_error->previous
      exp = lx_previous ).
  ENDMETHOD.

  METHOD catch_static_check.
    DATA lx_error TYPE REF TO cx_static_check.
    TRY.
        RAISE EXCEPTION TYPE cx_fhc_runtime
          EXPORTING
            textid = cx_fhc_runtime=>factorycalendar_not_found.
      CATCH cx_static_check INTO lx_error.
    ENDTRY.
    cl_abap_unit_assert=>assert_bound( lx_error ).
    cl_abap_unit_assert=>assert_not_initial( lx_error->get_text( ) ).
  ENDMETHOD.

ENDCLASS.
