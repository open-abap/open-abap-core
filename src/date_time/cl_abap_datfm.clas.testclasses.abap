CLASS ltcl_test_datfm DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS acc_convert_external_to_int FOR TESTING RAISING cx_static_check.
    METHODS acc_conv_ext_to_int_infinity FOR TESTING RAISING cx_static_check.
    METHODS acc_conv_ext_to_int_initial FOR TESTING RAISING cx_static_check.
    METHODS fails_not_gregorian_dot_sep FOR TESTING RAISING cx_static_check.
    METHODS fails_initial_date_provided FOR TESTING RAISING cx_static_check.
    METHODS fails_date_too_long FOR TESTING RAISING cx_static_check.
    METHODS fails_gregorian_but_no_dots FOR TESTING RAISING cx_static_check.

    METHODS yyyymmdd_dot_ok FOR TESTING RAISING cx_static_check.
    METHODS yyyymmdd_no_dot FOR TESTING RAISING cx_static_check.
    METHODS yyyymmdd_dot_fail FOR TESTING RAISING cx_static_check.

    CONSTANTS christmas_external TYPE string VALUE '24.12.2023'.
    CONSTANTS christmas TYPE d VALUE '20231224'.
    CONSTANTS gregorian_dot_seperated TYPE c VALUE '1'.
    CONSTANTS gregorian_slash_seperated TYPE c VALUE '2'.
    CONSTANTS yyyymmdd_dot_seperated TYPE c VALUE '4'.

    DATA exception TYPE REF TO cx_abap_datfm.

ENDCLASS.

CLASS ltcl_test_datfm IMPLEMENTATION.

  METHOD acc_convert_external_to_int.
    DATA date_internal_actual TYPE d.
    DATA format_used_actual   TYPE c.

    cl_abap_datfm=>conv_date_ext_to_int(
      EXPORTING
        im_datext    = christmas_external
        im_datfmdes  = gregorian_dot_seperated
      IMPORTING
        ex_datint    = date_internal_actual
        ex_datfmused = format_used_actual ).

    cl_abap_unit_assert=>assert_equals(
      exp = christmas
      act = date_internal_actual ).
    cl_abap_unit_assert=>assert_equals(
      exp = gregorian_dot_seperated
      act = format_used_actual ).
  ENDMETHOD.

  METHOD acc_conv_ext_to_int_infinity.
    DATA infinity_external TYPE string VALUE '31.12.9999'.
    DATA infinity TYPE d VALUE '99991231'.
    DATA date_internal_actual TYPE d.
    DATA format_used_actual TYPE c.

    cl_abap_datfm=>conv_date_ext_to_int(
      EXPORTING
        im_datext    = infinity_external
        im_datfmdes  = gregorian_dot_seperated
      IMPORTING
        ex_datint    = date_internal_actual
        ex_datfmused = format_used_actual ).

    cl_abap_unit_assert=>assert_equals( exp = infinity
                                        act = date_internal_actual ).
    cl_abap_unit_assert=>assert_equals( exp = gregorian_dot_seperated
                                        act = format_used_actual ).
  ENDMETHOD.

  METHOD acc_conv_ext_to_int_initial.
    DATA initial_external TYPE string VALUE '00.00.0000'.
    DATA initial TYPE d VALUE '00000000'.
    DATA date_internal_actual TYPE d.
    DATA format_used_actual TYPE c.

    cl_abap_datfm=>conv_date_ext_to_int(
      EXPORTING
        im_datext    = initial_external
        im_datfmdes  = gregorian_dot_seperated
      IMPORTING
        ex_datint    = date_internal_actual
        ex_datfmused = format_used_actual ).

    cl_abap_unit_assert=>assert_equals( exp = initial
                                        act = date_internal_actual ).
    cl_abap_unit_assert=>assert_equals( exp = gregorian_dot_seperated
                                        act = format_used_actual ).
  ENDMETHOD.


  METHOD fails_not_gregorian_dot_sep.
    DATA date_internal TYPE d.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int(
          im_datext   = christmas_external
          im_datfmdes = gregorian_slash_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD fails_initial_date_provided.
    DATA initial TYPE string.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int(
          im_datext   = initial
          im_datfmdes = gregorian_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD fails_date_too_long.
    DATA this_is_too_long TYPE string VALUE '  01.01.20222  '.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int(
          im_datext   = this_is_too_long
          im_datfmdes = gregorian_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD fails_gregorian_but_no_dots.
    DATA date_seperated_by_slashes TYPE string VALUE '01/01/2022'.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int(
          im_datext   = date_seperated_by_slashes
          im_datfmdes = gregorian_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD yyyymmdd_dot_ok.

    DATA lv_date TYPE d.

    cl_abap_datfm=>conv_date_ext_to_int(
      EXPORTING
        im_datext   = '2015.02.01'
        im_datfmdes = yyyymmdd_dot_seperated
      IMPORTING
        ex_datint   = lv_date ).

    cl_abap_unit_assert=>assert_equals(
      exp = '20150201'
      act = lv_date ).

  ENDMETHOD.

  METHOD yyyymmdd_no_dot.

    DATA lv_date TYPE d.

    cl_abap_datfm=>conv_date_ext_to_int(
      EXPORTING
        im_datext   = '20150201'
        im_datfmdes = yyyymmdd_dot_seperated
      IMPORTING
        ex_datint   = lv_date ).

    cl_abap_unit_assert=>assert_equals(
      exp = '20150201'
      act = lv_date ).

  ENDMETHOD.

  METHOD yyyymmdd_dot_fail.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int(
          im_datext   = '1.2.2015'
          im_datfmdes = yyyymmdd_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.