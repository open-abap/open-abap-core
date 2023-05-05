CLASS ltcl_test_datfm DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS acc_convert_external_to_internal FOR TESTING RAISING cx_static_check.
    METHODS fails_not_gregorian_dot_sep FOR TESTING RAISING cx_static_check.
    METHODS fails_initial_date_provided FOR TESTING RAISING cx_static_check.
    METHODS fails_date_too_long FOR TESTING RAISING cx_static_check.
    METHODS fails_gregorian_but_no_dots FOR TESTING RAISING cx_static_check.

    CONSTANTS christmas_external TYPE string VALUE '24.12.2023'.
    CONSTANTS christmas TYPE d VALUE '20231224'.
    CONSTANTS gregorian_dot_seperated TYPE c VALUE '1'.
    CONSTANTS gregorian_slash_seperated TYPE c VALUE '2'.

    DATA exception TYPE REF TO cx_abap_datfm.

ENDCLASS.

CLASS ltcl_test_datfm IMPLEMENTATION.

  METHOD acc_convert_external_to_internal.
    DATA date_internal_actual TYPE d.
    DATA format_used_actual TYPE c.

    cl_abap_datfm=>conv_date_ext_to_int( EXPORTING im_datext = christmas_external im_datfmdes = gregorian_dot_seperated
                                         IMPORTING ex_datint = date_internal_actual
                                                   ex_datfmused = format_used_actual ).

    cl_abap_unit_assert=>assert_equals( exp = christmas act = date_internal_actual ).
    cl_abap_unit_assert=>assert_equals( exp = gregorian_dot_seperated act = format_used_actual ).
  ENDMETHOD.

  METHOD fails_not_gregorian_dot_sep.
    DATA date_internal TYPE d.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int( im_datext = christmas_external im_datfmdes = gregorian_slash_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD fails_initial_date_provided.
    DATA initial TYPE string.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int( im_datext = initial im_datfmdes = gregorian_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD fails_date_too_long.
    DATA this_is_too_long TYPE string VALUE '  01.01.20222  '.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int( im_datext = this_is_too_long im_datfmdes = gregorian_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

  METHOD fails_gregorian_but_no_dots.
    DATA date_seperated_by_slashes TYPE string VALUE '01/01/2022'.

    TRY.
        cl_abap_datfm=>conv_date_ext_to_int( im_datext = date_seperated_by_slashes im_datfmdes = gregorian_dot_seperated ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_abap_datfm INTO exception.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.