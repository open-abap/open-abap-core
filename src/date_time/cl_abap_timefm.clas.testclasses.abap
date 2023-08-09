CLASS ltcl_test_timefm DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS valid FOR TESTING RAISING cx_static_check.
    METHODS invalid FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test_timefm IMPLEMENTATION.
  METHOD valid.
    DATA lv_time TYPE t.

    cl_abap_timefm=>conv_time_ext_to_int(
      EXPORTING
        time_ext      = '08:30:00'
        is_24_allowed = abap_true
      IMPORTING
        time_int      = lv_time ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_time
      exp = '083000' ).
  ENDMETHOD.

  METHOD invalid.
    TRY.
        cl_abap_timefm=>conv_time_ext_to_int(
          time_ext      = '88:30:00'
          is_24_allowed = abap_true ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_timefm_invalid.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.