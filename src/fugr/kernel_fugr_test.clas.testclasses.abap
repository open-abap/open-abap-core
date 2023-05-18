CLASS ltcl_fugr DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS system_installed_languages FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_isola_output FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_isola_input FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_isola_input_fr FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_alpha_output_string FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_alpha_output_char FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_alpha_input FOR TESTING RAISING cx_static_check.
    METHODS conversion_exit_alpha_input_st FOR TESTING RAISING cx_static_check.
    METHODS generate_sec_random FOR TESTING RAISING cx_static_check.
    METHODS text_split1 FOR TESTING RAISING cx_static_check.
    METHODS text_split2 FOR TESTING RAISING cx_static_check.
    METHODS function_exists_yes FOR TESTING RAISING cx_static_check.
    METHODS function_exists_no FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_fugr IMPLEMENTATION.

  METHOD text_split1.
    CONSTANTS lc_text TYPE c LENGTH 200 VALUE '01234567890123456789012345678901234567890123456789 123456789'.
    DATA lv_line TYPE string.
    DATA lv_rest TYPE string.

    CALL FUNCTION 'TEXT_SPLIT'
      EXPORTING
        length = 50
        text   = lc_text
      IMPORTING
        line   = lv_line
        rest   = lv_rest.

    cl_abap_unit_assert=>assert_equals(
      act = lv_rest
      exp = |123456789| ).
  ENDMETHOD.

  METHOD text_split2.
    DATA lv_text TYPE c LENGTH 200.
    DATA lv_line TYPE string.
    DATA lv_rest TYPE string.

    lv_text = |Here is a very long text more than 200 characters and we have to invent a nice story about abapGit to fill this long message|.

    CALL FUNCTION 'TEXT_SPLIT'
      EXPORTING
        length = 50
        text   = lv_text
      IMPORTING
        line   = lv_line
        rest   = lv_rest.
    cl_abap_unit_assert=>assert_equals(
      act = lv_rest
      exp = |and we have to invent a nice story about abapGit to fill this long message| ).
  ENDMETHOD.

  METHOD generate_sec_random.

    DATA lv_xstring TYPE xstring.

    CALL FUNCTION 'GENERATE_SEC_RANDOM'
      EXPORTING
        length         = 8
      IMPORTING
        random         = lv_xstring
      EXCEPTIONS
        invalid_length = 1
        no_memory      = 2
        internal_error = 3
        OTHERS         = 4.
    ASSERT sy-subrc = 0.

    cl_abap_unit_assert=>assert_not_initial( lv_xstring ).

  ENDMETHOD.

  METHOD conversion_exit_alpha_input.

    DATA lv_input TYPE c LENGTH 10.
    DATA lv_output TYPE c LENGTH 10.
    lv_input = '10'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_input
      IMPORTING
        output = lv_output.

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = '0000000010' ).

  ENDMETHOD.

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

    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = |10        | ).

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

  METHOD conversion_exit_isola_input_fr.
    DATA lv_lang TYPE spras.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
      EXPORTING
        input            = 'fr'
      IMPORTING
        output           = lv_lang
      EXCEPTIONS
        unknown_language = 1
        OTHERS           = 2.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'F'
      act = lv_lang ).
  ENDMETHOD.

  METHOD conversion_exit_isola_output.
    DATA lv_lang TYPE laiso.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input            = 'F'
      IMPORTING
        output           = lv_lang
      EXCEPTIONS
        unknown_language = 1
        OTHERS           = 2.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'FR'
      act = lv_lang ).
  ENDMETHOD.

  METHOD function_exists_yes.

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.
    cl_abap_unit_assert=>assert_subrc( ).

  ENDMETHOD.

  METHOD function_exists_no.

    CALL FUNCTION 'FUNCTION_EXISTS'
      EXPORTING
        funcname           = 'SDFSDFSD'
      EXCEPTIONS
        function_not_exist = 1
        OTHERS             = 2.
    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = sy-subrc ).

  ENDMETHOD.

  METHOD conversion_exit_alpha_input_st.
    DATA str TYPE string.
    DATA res TYPE string.
    str = '1'.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = str
      IMPORTING
      output = res.
    cl_abap_unit_assert=>assert_equals(
      act = res
      exp = '1' ).
  ENDMETHOD.

ENDCLASS.