CLASS ltcl_fcal DEFINITION FOR TESTING FINAL.

  PUBLIC SECTION.
    INTERFACES if_fhc_fcal_runtime PARTIALLY IMPLEMENTED.
    DATA mv_correct_option TYPE if_fhc_fcal_runtime=>te_correct_option.

ENDCLASS.

CLASS ltcl_fcal IMPLEMENTATION.

  METHOD if_fhc_fcal_runtime~convert_date_to_factorydate.
    mv_correct_option = iv_correct_option.
    rv_factorydate = 1.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_holiday DEFINITION FOR TESTING FINAL.

  PUBLIC SECTION.
    INTERFACES if_fhc_holiday_runtime PARTIALLY IMPLEMENTED.

ENDCLASS.

CLASS ltcl_holiday IMPLEMENTATION.

  METHOD if_fhc_holiday_runtime~get_holiday_id.
    rv_id = 'NEW_YEAR'.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_hcal DEFINITION FOR TESTING FINAL.

  PUBLIC SECTION.
    INTERFACES if_fhc_hcal_runtime PARTIALLY IMPLEMENTED.

ENDCLASS.

CLASS ltcl_hcal IMPLEMENTATION.

  METHOD if_fhc_hcal_runtime~calc_holidays_between_dates.
    DATA ls_occurrence LIKE LINE OF et_holidays.
    CLEAR et_holidays.
    ls_occurrence-date = iv_start.
    CREATE OBJECT ls_occurrence-holiday_reference TYPE ltcl_holiday.
    APPEND ls_occurrence TO et_holidays.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS correct_options_differ FOR TESTING RAISING cx_static_check.
    METHODS correct_option_default FOR TESTING RAISING cx_static_check.
    METHODS fcal_id_length FOR TESTING RAISING cx_static_check.
    METHODS holiday_occurrences FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD correct_options_differ.
    cl_abap_unit_assert=>assert_differs(
      act = if_fhc_fcal_runtime=>gc_correct_option_plus
      exp = if_fhc_fcal_runtime=>gc_correct_option_minus ).
  ENDMETHOD.

  METHOD correct_option_default.
    DATA lo_double TYPE REF TO ltcl_fcal.
    DATA li_fcal   TYPE REF TO if_fhc_fcal_runtime.

    CREATE OBJECT lo_double.
    li_fcal = lo_double.
    lo_double->mv_correct_option = if_fhc_fcal_runtime=>gc_correct_option_minus.

    li_fcal->convert_date_to_factorydate( '20260101' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_double->mv_correct_option
      exp = if_fhc_fcal_runtime=>gc_correct_option_plus ).
  ENDMETHOD.

  METHOD fcal_id_length.
    DATA lv_id TYPE cl_fhc_calendar_runtime=>ty_fcal_id.
    lv_id = repeat( val = `X`
                    occ = 40 ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( lv_id )
      exp = 32 ).
  ENDMETHOD.

  METHOD holiday_occurrences.
    DATA li_hcal     TYPE REF TO if_fhc_hcal_runtime.
    DATA lt_holidays TYPE if_fhc_hcal_runtime=>tt_holiday_occurrences.
    DATA ls_holiday  LIKE LINE OF lt_holidays.
    DATA lt_refs     TYPE if_fhc_hcal_runtime=>ty_fhc_t_hol_if.

    CREATE OBJECT li_hcal TYPE ltcl_hcal.
    li_hcal->calc_holidays_between_dates(
      EXPORTING
        iv_start    = '20260101'
        iv_end      = '20261231'
      IMPORTING
        et_holidays = lt_holidays ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_holidays )
      exp = 1 ).
    READ TABLE lt_holidays INDEX 1 INTO ls_holiday.
    cl_abap_unit_assert=>assert_equals(
      act = ls_holiday-date
      exp = '20260101' ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_holiday-holiday_reference->get_holiday_id( )
      exp = 'NEW_YEAR' ).

    APPEND ls_holiday-holiday_reference TO lt_refs.
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_refs )
      exp = 1 ).
  ENDMETHOD.

ENDCLASS.
