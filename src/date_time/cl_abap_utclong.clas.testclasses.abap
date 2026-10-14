CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS min FOR TESTING RAISING cx_static_check.
    METHODS max FOR TESTING RAISING cx_static_check.
    METHODS min_before_max FOR TESTING RAISING cx_static_check.
    METHODS timezone_utc FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD min.
    DATA lv_text TYPE string.
    lv_text = cl_abap_utclong=>min.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = '0001-01-01 00:00:00.0000000' ).
  ENDMETHOD.

  METHOD max.
    DATA lv_text TYPE string.
    lv_text = cl_abap_utclong=>max.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = '9999-12-31 23:59:59.9999999' ).
  ENDMETHOD.

  METHOD min_before_max.
    cl_abap_unit_assert=>assert_true( xsdbool( cl_abap_utclong=>min < cl_abap_utclong=>max ) ).
  ENDMETHOD.

  METHOD timezone_utc.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_utclong=>timezone_utc
      exp = 'UTC' ).
  ENDMETHOD.

ENDCLASS.
