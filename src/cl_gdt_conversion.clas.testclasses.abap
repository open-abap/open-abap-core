CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS date_time_inbound FOR TESTING RAISING cx_static_check.
    METHODS amount_outbound_dkk FOR TESTING RAISING cx_static_check.
    METHODS amount_outbound_vnd FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD amount_outbound_dkk.
    DATA lv_value TYPE p LENGTH 11 DECIMALS 2.
    lv_value = 100.
    cl_gdt_conversion=>amount_outbound(
      EXPORTING
        im_value         = lv_value
        im_currency_code = 'DKK'
      IMPORTING
        ex_value         = lv_value ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_value
      exp = 100 ).
  ENDMETHOD.

  METHOD amount_outbound_vnd.
    DATA lv_value TYPE p LENGTH 11 DECIMALS 2.
    lv_value = 100.
    cl_gdt_conversion=>amount_outbound(
      EXPORTING
        im_value         = lv_value
        im_currency_code = 'VND'
      IMPORTING
        ex_value         = lv_value ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_value
      exp = 10000 ).
  ENDMETHOD.

  METHOD date_time_inbound.

    DATA lv_string    TYPE string.
    DATA lv_date      TYPE d.
    DATA lv_timestamp TYPE timestamp.

    lv_string = |2021-02-24T07:08:20Z|.

    cl_gdt_conversion=>date_time_inbound(
      EXPORTING
        im_value       = lv_string
      IMPORTING
        ex_value_short = lv_timestamp ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_timestamp
      exp = 20210224070820 ).

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'UTC' INTO DATE lv_date.

    cl_abap_unit_assert=>assert_equals(
      act = lv_date
      exp = '20210224' ).

  ENDMETHOD.

ENDCLASS.