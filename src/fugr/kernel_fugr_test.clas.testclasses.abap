CLASS ltcl_fugr DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS system_installed_languages FOR TESTING RAISING cx_static_check.
    METHODS cexit_isola_output FOR TESTING RAISING cx_static_check.
    METHODS cexit_isola_output_empty FOR TESTING RAISING cx_static_check.
    METHODS cexit_isola_input FOR TESTING RAISING cx_static_check.
    METHODS cexit_isola_input_fr FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_output_string FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_output_char FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_input FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_input_st FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_input_dats FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_input_empty FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_input_str FOR TESTING RAISING cx_static_check.
    METHODS cexit_alpha_input_str_in FOR TESTING RAISING cx_static_check.
    METHODS generate_sec_random FOR TESTING RAISING cx_static_check.
    METHODS text_split1 FOR TESTING RAISING cx_static_check.
    METHODS text_split2 FOR TESTING RAISING cx_static_check.
    METHODS function_exists_yes FOR TESTING RAISING cx_static_check.
    METHODS function_exists_no FOR TESTING RAISING cx_static_check.
    METHODS unit_kg_to_kg FOR TESTING RAISING cx_static_check.
    METHODS unit_lb_to_kg FOR TESTING RAISING cx_static_check.
    METHODS unit_g_to_kg FOR TESTING RAISING cx_static_check.
    METHODS unit_m3_to_cdm FOR TESTING RAISING cx_static_check.
    METHODS unit_ft3_to_cdm FOR TESTING RAISING cx_static_check.
    METHODS unit_ccm_to_cdm FOR TESTING RAISING cx_static_check.
    METHODS seo_implem_global FOR TESTING RAISING cx_static_check.
    METHODS seo_implem_caller_types FOR TESTING RAISING cx_static_check.
    METHODS seo_implem_none FOR TESTING RAISING cx_static_check.
    METHODS seo_implem_not_existing FOR TESTING RAISING cx_static_check.
    METHODS seo_implem_is_class FOR TESTING RAISING cx_static_check.

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

  METHOD cexit_alpha_input.

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

  METHOD cexit_alpha_output_char.

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

  METHOD cexit_alpha_output_string.

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

  METHOD cexit_isola_input.
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

  METHOD cexit_isola_input_fr.
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

  METHOD cexit_isola_output.
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

  METHOD cexit_alpha_input_st.
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

  METHOD cexit_alpha_input_dats.
    DATA lv_dats TYPE d.
    DATA lv_str  TYPE string.
    lv_str = '20230529'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_str
      IMPORTING
        output = lv_dats.

    cl_abap_unit_assert=>assert_equals(
      act = lv_dats
      exp = '20230529' ).
  ENDMETHOD.

  METHOD unit_kg_to_kg.

    DATA lv_result TYPE menge_d.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input    = 1
        unit_in  = 'KG'
        unit_out = 'KG'
      IMPORTING
        output   = lv_result
      EXCEPTIONS
        OTHERS   = 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = 1 ).

  ENDMETHOD.

  METHOD unit_lb_to_kg.

    DATA lv_result TYPE menge_d.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input    = 10
        unit_in  = 'LB'
        unit_out = 'KG'
      IMPORTING
        output   = lv_result
      EXCEPTIONS
        OTHERS   = 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '4.536' ).

  ENDMETHOD.

  METHOD unit_g_to_kg.

    DATA lv_result TYPE menge_d.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input    = 1000
        unit_in  = 'G'
        unit_out = 'KG'
      IMPORTING
        output   = lv_result
      EXCEPTIONS
        OTHERS   = 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = 1 ).

  ENDMETHOD.

  METHOD unit_m3_to_cdm.

    DATA lv_result TYPE menge_d.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input    = 1
        unit_in  = 'M3'
        unit_out = 'CDM'
      IMPORTING
        output   = lv_result
      EXCEPTIONS
        OTHERS   = 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = 1000 ).

  ENDMETHOD.

  METHOD unit_ft3_to_cdm.

    DATA lv_result TYPE menge_d.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input    = 10
        unit_in  = 'FT3'
        unit_out = 'CDM'
      IMPORTING
        output   = lv_result
      EXCEPTIONS
        OTHERS   = 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '283.168' ).

  ENDMETHOD.

  METHOD unit_ccm_to_cdm.

    DATA lv_result TYPE menge_d.

    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input    = 1000
        unit_in  = 'CCM'
        unit_out = 'CDM'
      IMPORTING
        output   = lv_result
      EXCEPTIONS
        OTHERS   = 1.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = '1' ).

  ENDMETHOD.

  METHOD cexit_alpha_input_empty.

    DATA val TYPE c LENGTH 30.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = val
      IMPORTING
        output = val.

    cl_abap_unit_assert=>assert_equals(
      act = val
      exp = '' ).

  ENDMETHOD.

  METHOD cexit_alpha_input_str.

    DATA val TYPE c LENGTH 10.
    DATA str TYPE string.

    val = '10'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = val
      IMPORTING
        output = str.

    cl_abap_unit_assert=>assert_equals(
      act = str
      exp = '0000000010' ).

  ENDMETHOD.

  METHOD cexit_alpha_input_str_in.

    DATA lv_str TYPE string.
    DATA lv_ret TYPE c LENGTH 10.

    lv_str = '2'.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_str
      IMPORTING
        output = lv_ret.

    cl_abap_unit_assert=>assert_equals(
      act = lv_ret
      exp = '0000000002' ).

  ENDMETHOD.

  METHOD cexit_isola_output_empty.

    DATA lv_lang TYPE laiso.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = space
      IMPORTING
        output = lv_lang.

    cl_abap_unit_assert=>assert_equals(
      exp = ''
      act = lv_lang ).

  ENDMETHOD.

  METHOD seo_implem_global.
* IF_MESSAGE is implemented by CX_ROOT, so every exception class is an
* implementer, the interfaces of a superclass counting as on a system
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.
    DATA ls_impl LIKE LINE OF lt_impl.

    ls_key-clsname = 'IF_MESSAGE'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE lt_impl INTO ls_impl WITH KEY clsname = 'CX_ROOT'.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_impl-refclsname
      exp = 'IF_MESSAGE' ).

    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'CX_SY_ZERODIVIDE'.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'KERNEL_FUGR_TEST'.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).

* the interface itself is not an implementer
    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'IF_MESSAGE'.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.

  METHOD seo_implem_caller_types.
* a caller without the SEO types passes its own one-field key and its own
* row type, type-compatible with the formal parameters on a system
    TYPES BEGIN OF ty_s_key.
    TYPES intkey TYPE c LENGTH 30.
    TYPES END OF ty_s_key.
    TYPES BEGIN OF ty_s_impl.
    TYPES clsname TYPE c LENGTH 30.
    TYPES END OF ty_s_impl.
    DATA ls_key  TYPE ty_s_key.
    DATA lt_impl TYPE STANDARD TABLE OF ty_s_impl WITH DEFAULT KEY.

    ls_key-intkey = 'if_message'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).

    READ TABLE lt_impl TRANSPORTING NO FIELDS WITH KEY clsname = 'CX_ROOT'.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD seo_implem_none.
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.

    ls_key-clsname = 'IF_AMDP_MARKER_HDB'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        OTHERS       = 2.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_initial( lt_impl ).
  ENDMETHOD.

  METHOD seo_implem_not_existing.
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.

    ls_key-clsname = 'SDFSDFSD'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        is_class     = 2
        OTHERS       = 3.
    cl_abap_unit_assert=>assert_equals(
      exp = 1
      act = sy-subrc ).
  ENDMETHOD.

  METHOD seo_implem_is_class.
    DATA ls_key  TYPE seoclskey.
    DATA lt_impl TYPE seor_implementing_keys.

    ls_key-clsname = 'CL_ABAP_UNIT_ASSERT'.
    CALL FUNCTION 'SEO_INTERFACE_IMPLEM_GET_ALL'
      EXPORTING
        intkey       = ls_key
      IMPORTING
        impkeys      = lt_impl
      EXCEPTIONS
        not_existing = 1
        is_class     = 2
        OTHERS       = 3.
    cl_abap_unit_assert=>assert_equals(
      exp = 2
      act = sy-subrc ).
  ENDMETHOD.

ENDCLASS.