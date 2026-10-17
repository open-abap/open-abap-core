CLASS ltcl_context_info DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS user_language_abap_format FOR TESTING RAISING cx_static_check.
    METHODS user_language_with_buser FOR TESTING RAISING cx_static_check.
    METHODS user_language_iso_format FOR TESTING RAISING cx_static_check.
    METHODS user_formatted_name FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_context_info IMPLEMENTATION.
  METHOD user_language_abap_format.
    DATA lv_language TYPE cl_abap_context_info=>ty_language_key.

    lv_language = cl_abap_context_info=>get_user_language_abap_format( ).

    cl_abap_unit_assert=>assert_not_initial( act = lv_language ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_language
      exp = sy-langu ).
  ENDMETHOD.

  METHOD user_language_with_buser.
    DATA lv_language TYPE cl_abap_context_info=>ty_language_key.

    lv_language = cl_abap_context_info=>get_user_language_abap_format( iv_buser = sy-uname ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_language
      exp = sy-langu ).
  ENDMETHOD.

  METHOD user_language_iso_format.
    DATA lv_language TYPE cl_abap_context_info=>ty_language_iso_code.
    DATA lv_expected TYPE string.

    lv_language = cl_abap_context_info=>get_user_language_iso_format( ).
    lv_expected = cl_i18n_languages=>sap1_to_sap2( sy-langu ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_language
      exp = lv_expected ).
    cl_abap_unit_assert=>assert_equals(
      act = strlen( lv_language )
      exp = 2 ).
  ENDMETHOD.

  METHOD user_formatted_name.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_context_info=>get_user_formatted_name( )
      exp = condense( sy-uname ) ).
  ENDMETHOD.
ENDCLASS.
