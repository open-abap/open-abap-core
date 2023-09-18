CLASS ltcl_test_timefm DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS conv_time_ext_to_int_valid FOR TESTING RAISING cx_static_check.
    METHODS conv_time_ext_to_int_invalid FOR TESTING RAISING cx_static_check.
    METHODS conv_time_int_to_ext FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test_timefm IMPLEMENTATION.
  METHOD conv_time_ext_to_int_valid.
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

  METHOD conv_time_ext_to_int_invalid.
    TRY.
        cl_abap_timefm=>conv_time_ext_to_int(
          time_ext      = '88:30:00'
          is_24_allowed = abap_true ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_timefm_invalid.
    ENDTRY.
  ENDMETHOD.

  METHOD conv_time_int_to_ext.
    DATA time TYPE t.
    DATA str TYPE string.

    time = '112233'.
    cl_abap_timefm=>conv_time_int_to_ext(
      EXPORTING
        time_int = time
      IMPORTING
        time_ext = str ).
    cl_abap_unit_assert=>assert_equals(
      act = str
      exp = '11:22:33' ).
  ENDMETHOD.
ENDCLASS.