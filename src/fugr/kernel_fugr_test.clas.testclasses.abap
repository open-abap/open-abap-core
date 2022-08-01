CLASS ltcl_fugr DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS system_installed_languages FOR TESTING RAISING cx_root.
    METHODS conversion_exit_isola_input FOR TESTING RAISING cx_root.
    METHODS conversion_exit_alpha_output_string FOR TESTING RAISING cx_root.
    METHODS conversion_exit_alpha_output_char FOR TESTING RAISING cx_root.

ENDCLASS.

CLASS ltcl_fugr IMPLEMENTATION.

  METHOD conversion_exit_alpha_output_char.

    DATA lv_input TYPE c LENGTH 10.
    DATA lv_output TYPE c LENGTH 10.
    lv_input = '0000000010'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_input
      IMPORTING
        output = lv_output.

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = '10' ).

  ENDMETHOD.

  METHOD conversion_exit_alpha_output_string.

    DATA lv_input TYPE c LENGTH 10.
    DATA lv_output TYPE string.
    lv_input = '0000000010'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_input
      IMPORTING
        output = lv_output.

    " cl_abap_unit_assert=>assert_equals(
    "   act = lv_output
    "   exp = |10        | ).

  ENDMETHOD.

  METHOD system_installed_languages.

    DATA lv_installed_languages TYPE string.

    CALL FUNCTION 'SYSTEM_INSTALLED_LANGUAGES'
      IMPORTING
        languages       = lv_installed_languages
      EXCEPTIONS
        sapgparam_error = 1
        OTHERS          = 2.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_not_initial( lv_installed_languages ).

  ENDMETHOD.

  METHOD conversion_exit_isola_input.
    DATA lv_lang TYPE spras.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
      EXPORTING
        input            = '1Q'
      IMPORTING
        output           = lv_lang
      EXCEPTIONS
        unknown_language = 1
        OTHERS           = 2.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_initial( lv_lang ).
  ENDMETHOD.

ENDCLASS.