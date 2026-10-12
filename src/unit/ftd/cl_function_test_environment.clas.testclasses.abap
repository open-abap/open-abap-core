CLASS ltcl_test DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_answer.
  PRIVATE SECTION.
    CONSTANTS gc_hello_world TYPE string VALUE 'Hello World'.

    METHODS test FOR TESTING RAISING cx_static_check.

    METHODS test_throws.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA lt_deps    TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_env     TYPE REF TO if_function_test_environment.
    DATA lv_message TYPE string.

    test_throws( ).

    INSERT 'ABC' INTO TABLE lt_deps.
    li_env = cl_function_test_environment=>create( lt_deps ).

    li_env->get_double( 'ABC' )->configure_call( )->ignore_all_parameters( )->then_answer( me ).

    CALL FUNCTION 'ABC'
      EXPORTING
        integer = 2
      IMPORTING
        message = lv_message.

    cl_abap_unit_assert=>assert_equals(
      act = lv_message
      exp = gc_hello_world ).

    li_env->clear_doubles( ).

    " the double stays, without a configuration it does nothing
    CLEAR lv_message.
    CALL FUNCTION 'ABC'
      EXPORTING
        integer = 2
      IMPORTING
        message = lv_message.

    cl_abap_unit_assert=>assert_initial( lv_message ).

  ENDMETHOD.

  METHOD test_throws.

    TRY.
        CALL FUNCTION 'ABC'.
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_dyn_call_illegal_func.
    ENDTRY.

  ENDMETHOD.

  METHOD if_ftd_invocation_answer~answer.

    DATA ref TYPE REF TO data.

    FIELD-SYMBOLS <fs> TYPE any.

    ref = arguments->get_importing_parameter( 'INTEGER' ).
    ASSIGN ref->* TO <fs>.

    cl_abap_unit_assert=>assert_equals(
      act = <fs>
      exp = 2 ).

    result->get_output_configuration( )->set_exporting_parameter(
      name  = 'MESSAGE'
      value = gc_hello_world ).

  ENDMETHOD.

ENDCLASS.

*****************************************

CLASS ltcl_changing DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_answer.
  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_changing IMPLEMENTATION.

  METHOD test.

    DATA lt_deps  TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_env   TYPE REF TO if_function_test_environment.
    DATA lv_value TYPE string VALUE 'initial'.

    INSERT 'CHANGING_FM' INTO TABLE lt_deps.
    li_env = cl_function_test_environment=>create( lt_deps ).
    li_env->get_double( 'CHANGING_FM' )->configure_call( )->ignore_all_parameters( )->then_answer( me ).

    CALL FUNCTION 'CHANGING_FM'
      CHANGING
        value = lv_value.

    li_env->clear_doubles( ).

  ENDMETHOD.

  METHOD if_ftd_invocation_answer~answer.

    DATA ref TYPE REF TO data.
    FIELD-SYMBOLS <fs> TYPE any.

    ref = arguments->get_changing_parameter( 'VALUE' ).
    ASSIGN ref->* TO <fs>.

    cl_abap_unit_assert=>assert_equals(
      act = <fs>
      exp = 'initial' ).

  ENDMETHOD.

ENDCLASS.

*****************************************

CLASS ltcl_no_parameters DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_answer.
  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_no_parameters IMPLEMENTATION.

  METHOD test.

    DATA lt_deps    TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_env     TYPE REF TO if_function_test_environment.
    DATA lv_message TYPE string.


    INSERT 'NOTHING' INTO TABLE lt_deps.
    li_env = cl_function_test_environment=>create( lt_deps ).
    li_env->get_double( 'NOTHING' )->configure_call( )->ignore_all_parameters( )->then_answer( me ).

    CALL FUNCTION 'NOTHING'.

  ENDMETHOD.

  METHOD if_ftd_invocation_answer~answer.
    RETURN.
  ENDMETHOD.

ENDCLASS.

*****************************************

"! The doubles as SAP documents them: the environment is created once, setup( ) clears the
"! doubles, every test configures the double it needs
CLASS ltcl_configurations DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    CONSTANTS gc_name TYPE sxco_fm_name VALUE 'FTD_DEMO'.
    CONSTANTS gc_other TYPE sxco_fm_name VALUE 'FTD_DEMO_OTHER'.

    CLASS-DATA gi_env TYPE REF TO if_function_test_environment.

    CLASS-METHODS class_setup.
    METHODS setup.

    METHODS output_is_written FOR TESTING RAISING cx_static_check.
    METHODS output_not_passed_is_skipped FOR TESTING RAISING cx_static_check.
    METHODS output_is_copied FOR TESTING RAISING cx_static_check.
    METHODS input_selects_configuration FOR TESTING RAISING cx_static_check.
    METHODS input_left_out_is_initial FOR TESTING RAISING cx_static_check.
    METHODS input_not_set_is_not_compared FOR TESTING RAISING cx_static_check.
    METHODS latest_configuration_answers FOR TESTING RAISING cx_static_check.
    METHODS for_times_limits_calls FOR TESTING RAISING cx_static_check.
    METHODS for_times_no_fallback FOR TESTING RAISING cx_static_check.
    METHODS not_configured_clears_output FOR TESTING RAISING cx_static_check.
    METHODS classic_exception FOR TESTING RAISING cx_static_check.
    METHODS classic_exception_others FOR TESTING RAISING cx_static_check.
    METHODS class_based_exception FOR TESTING RAISING cx_static_check.
    METHODS verify_counts_every_call FOR TESTING RAISING cx_static_check.
    METHODS verify_with_input FOR TESTING RAISING cx_static_check.
    METHODS verify_with_table_input FOR TESTING RAISING cx_static_check.
    METHODS verify_fails FOR TESTING RAISING cx_static_check.
    METHODS verify_at_least_at_most FOR TESTING RAISING cx_static_check.
    METHODS clear_keeps_double FOR TESTING RAISING cx_static_check.
    METHODS clear_of_one_double FOR TESTING RAISING cx_static_check.

    METHODS double
      RETURNING
        VALUE(ri_double) TYPE REF TO if_function_testdouble.

    METHODS configure_text
      IMPORTING
        iv_key  TYPE i
        iv_text TYPE string.

    METHODS text_output
      IMPORTING
        iv_text          TYPE string
      RETURNING
        VALUE(ri_output) TYPE REF TO if_ftd_output_configuration.

    METHODS call_for_text
      RETURNING
        VALUE(rv_text) TYPE string.
ENDCLASS.

CLASS ltcl_configurations IMPLEMENTATION.

  METHOD class_setup.
    DATA lt_deps TYPE if_function_test_environment=>tt_function_dependencies.

    INSERT gc_name INTO TABLE lt_deps.
    INSERT gc_other INTO TABLE lt_deps.
    gi_env = cl_function_test_environment=>create( lt_deps ).
  ENDMETHOD.

  METHOD setup.
    gi_env->clear_doubles( ).
  ENDMETHOD.

  METHOD double.
    ri_double = gi_env->get_double( gc_name ).
  ENDMETHOD.

  METHOD configure_text.
    DATA li_input  TYPE REF TO if_ftd_input_configuration.
    DATA li_output TYPE REF TO if_ftd_output_configuration.

    li_input = double( )->create_input_configuration( ).
    li_input->set_importing_parameter( name  = 'KEY'
                                       value = iv_key ).
    li_output = double( )->create_output_configuration( ).
    li_output->set_exporting_parameter( name  = 'TEXT'
                                        value = iv_text ).
    double( )->configure_call( )->when( li_input )->then_set_output( li_output ).
  ENDMETHOD.

  METHOD text_output.
    ri_output = double( )->create_output_configuration( ).
    ri_output->set_exporting_parameter( name  = 'TEXT'
                                        value = iv_text ).
  ENDMETHOD.

  METHOD call_for_text.
    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = rv_text.
  ENDMETHOD.

  METHOD output_is_written.
    DATA li_output   TYPE REF TO if_ftd_output_configuration.
    DATA lt_expected TYPE string_table.
    DATA lv_text     TYPE string.
    DATA lt_rows     TYPE string_table.
    DATA lv_count    TYPE i VALUE 1.

    INSERT `row` INTO TABLE lt_expected.
    li_output = double( )->create_output_configuration( ).
    li_output->set_exporting_parameter( name  = 'TEXT'
                                        value = `hello` ).
    li_output->set_table_parameter( name  = 'ROWS'
                                    value = lt_expected ).
    li_output->set_changing_parameter( name  = 'COUNT'
                                       value = 5 ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( li_output ).

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text  = lv_text
      TABLES
        rows  = lt_rows
      CHANGING
        count = lv_count.

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `hello` ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_rows
      exp = lt_expected ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_count
      exp = 5 ).
  ENDMETHOD.

  METHOD output_not_passed_is_skipped.
    DATA li_output   TYPE REF TO if_ftd_output_configuration.
    DATA lt_expected TYPE string_table.
    DATA lv_text     TYPE string.

    INSERT `row` INTO TABLE lt_expected.
    li_output = double( )->create_output_configuration( ).
    li_output->set_exporting_parameter( name  = 'TEXT'
                                        value = `hello` ).
    li_output->set_table_parameter( name  = 'ROWS'
                                    value = lt_expected ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( li_output ).

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = lv_text.

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `hello` ).
  ENDMETHOD.

  METHOD output_is_copied.
    DATA li_output TYPE REF TO if_ftd_output_configuration.
    DATA lv_value  TYPE string.
    DATA lv_text   TYPE string.

    lv_value = `configured`.
    li_output = double( )->create_output_configuration( ).
    li_output->set_exporting_parameter( name  = 'TEXT'
                                        value = lv_value ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( li_output ).
    lv_value = `changed later`.

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = lv_text.

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `configured` ).
  ENDMETHOD.

  METHOD input_selects_configuration.
    DATA lv_text TYPE string.

    configure_text( iv_key  = 1
                    iv_text = `one` ).
    configure_text( iv_key  = 2
                    iv_text = `two` ).

    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key  = 2
      IMPORTING
        text = lv_text.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `two` ).

    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key  = 1
      IMPORTING
        text = lv_text.
    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `one` ).

    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key  = 3
      IMPORTING
        text = lv_text.
    cl_abap_unit_assert=>assert_initial( lv_text ).
  ENDMETHOD.

  METHOD input_left_out_is_initial.
    DATA lv_text TYPE string.

    configure_text( iv_key  = 0
                    iv_text = `zero` ).

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = lv_text.

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `zero` ).
  ENDMETHOD.

  METHOD input_not_set_is_not_compared.
    DATA lv_text TYPE string.

    configure_text( iv_key  = 1
                    iv_text = `one` ).

    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key  = 1
        flag = abap_true
      IMPORTING
        text = lv_text.

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `one` ).
  ENDMETHOD.

  METHOD latest_configuration_answers.
    DATA li_first  TYPE REF TO if_ftd_output_configuration.
    DATA li_second TYPE REF TO if_ftd_output_configuration.
    DATA lv_text   TYPE string.

    li_first = double( )->create_output_configuration( ).
    li_first->set_exporting_parameter( name  = 'TEXT'
                                       value = `first` ).
    li_second = double( )->create_output_configuration( ).
    li_second->set_exporting_parameter( name  = 'TEXT'
                                        value = `second` ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( li_first ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( li_second ).

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = lv_text.

    cl_abap_unit_assert=>assert_equals(
      act = lv_text
      exp = `second` ).
  ENDMETHOD.

  METHOD for_times_limits_calls.
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( text_output( `first` ) )->for_times( 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = call_for_text( )
      exp = `first` ).
    cl_abap_unit_assert=>assert_initial( call_for_text( ) ).
  ENDMETHOD.

  METHOD for_times_no_fallback.
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( text_output( `first` ) ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( text_output( `second` ) )->for_times( 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = call_for_text( )
      exp = `second` ).
    " the used up configuration still is the latest that applies, the earlier one does not answer
    cl_abap_unit_assert=>assert_initial( call_for_text( ) ).
  ENDMETHOD.

  METHOD not_configured_clears_output.
    DATA lv_text  TYPE string.
    DATA lv_count TYPE i VALUE 7.
    DATA lt_rows  TYPE string_table.

    INSERT `row` INTO TABLE lt_rows.
    lv_text = `before the call`.

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text      = lv_text
      TABLES
        rows      = lt_rows
      CHANGING
        count     = lv_count
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    " exporting parameters are initial, changing and tables parameters keep their values
    cl_abap_unit_assert=>assert_subrc( exp = 0 ).
    cl_abap_unit_assert=>assert_initial( lv_text ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_count
      exp = 7 ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_rows )
      exp = 1 ).
  ENDMETHOD.

  METHOD classic_exception.
    DATA lv_text TYPE string.

    double( )->configure_call( )->ignore_all_parameters( )->then_raise_classic_exception( 'not_found' ).

    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text      = lv_text
      EXCEPTIONS
        locked    = 1
        not_found = 2
        OTHERS    = 3.

    cl_abap_unit_assert=>assert_subrc( exp = 2 ).
  ENDMETHOD.

  METHOD classic_exception_others.
    double( )->configure_call( )->ignore_all_parameters( )->then_raise_classic_exception( 'SYSTEM_FAILURE' ).

    CALL FUNCTION 'FTD_DEMO'
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    cl_abap_unit_assert=>assert_subrc( exp = 2 ).
  ENDMETHOD.

  METHOD class_based_exception.
    DATA lx_raised TYPE REF TO cx_sy_zerodivide.
    DATA lx_caught TYPE REF TO cx_sy_zerodivide.

    CREATE OBJECT lx_raised.
    double( )->configure_call( )->ignore_all_parameters( )->then_raise_exception( lx_raised ).

    TRY.
        CALL FUNCTION 'FTD_DEMO'.
        cl_abap_unit_assert=>fail( 'The double must raise the exception' ).
      CATCH cx_sy_zerodivide INTO lx_caught.
        cl_abap_unit_assert=>assert_equals(
          act = lx_caught
          exp = lx_raised ).
    ENDTRY.
  ENDMETHOD.

  METHOD verify_counts_every_call.
    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key = 1.
    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key = 2.

    double( )->verify( )->is_called_times( 2 ).
  ENDMETHOD.

  METHOD verify_with_input.
    DATA li_two   TYPE REF TO if_ftd_input_configuration.
    DATA li_three TYPE REF TO if_ftd_input_configuration.

    li_two = double( )->create_input_configuration( ).
    li_two->set_importing_parameter( name  = 'KEY'
                                     value = 2 ).
    li_three = double( )->create_input_configuration( ).
    li_three->set_importing_parameter( name  = 'KEY'
                                       value = 3 ).

    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key = 1.
    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key = 2.
    CALL FUNCTION 'FTD_DEMO'
      EXPORTING
        key = 2.

    double( )->verify( li_two )->is_called_times( 2 ).
    double( )->verify( li_three )->is_never_called( ).
  ENDMETHOD.

  METHOD verify_with_table_input.
    DATA li_input TYPE REF TO if_ftd_input_configuration.
    DATA lt_rows  TYPE string_table.

    INSERT `passed` INTO TABLE lt_rows.
    li_input = double( )->create_input_configuration( ).
    li_input->set_table_parameter( name  = 'ROWS'
                                   value = lt_rows ).

    CALL FUNCTION 'FTD_DEMO'
      TABLES
        rows = lt_rows.
    " the double keeps the table as it was passed
    INSERT `changed later` INTO TABLE lt_rows.

    double( )->verify( li_input )->is_called_once( ).
  ENDMETHOD.

  METHOD verify_fails.
    DATA lv_failed TYPE abap_bool.

    CALL FUNCTION 'FTD_DEMO'.

    TRY.
        double( )->verify( )->is_never_called( ).
      CATCH kernel_cx_assert.
        lv_failed = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = lv_failed
      exp = abap_true
      msg = 'verify( ) must fail the test' ).
  ENDMETHOD.

  METHOD verify_at_least_at_most.
    DATA lv_failed TYPE abap_bool.

    CALL FUNCTION 'FTD_DEMO'.
    CALL FUNCTION 'FTD_DEMO'.

    double( )->verify( )->is_called_at_least( 2 ).
    double( )->verify( )->is_called_at_least_once( ).
    double( )->verify( )->is_called_at_most( 2 ).
    TRY.
        double( )->verify( )->is_called_at_most_once( ).
      CATCH kernel_cx_assert.
        lv_failed = abap_true.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals(
      act = lv_failed
      exp = abap_true
      msg = 'is_called_at_most_once( ) must fail after two calls' ).
  ENDMETHOD.

  METHOD clear_of_one_double.
    DATA li_other TYPE REF TO if_function_testdouble.
    DATA lv_text  TYPE string.

    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( text_output( `demo` ) ).
    li_other = gi_env->get_double( gc_other ).
    li_other->configure_call( )->ignore_all_parameters( )->then_raise_classic_exception( 'NOT_FOUND' ).

    double( )->clear( ).

    cl_abap_unit_assert=>assert_initial( call_for_text( ) ).
    CALL FUNCTION 'FTD_DEMO_OTHER'
      IMPORTING
        text      = lv_text
      EXCEPTIONS
        not_found = 1.
    cl_abap_unit_assert=>assert_subrc( exp = 1 ).
  ENDMETHOD.

  METHOD clear_keeps_double.
    DATA li_output TYPE REF TO if_ftd_output_configuration.
    DATA lv_text   TYPE string.

    li_output = double( )->create_output_configuration( ).
    li_output->set_exporting_parameter( name  = 'TEXT'
                                        value = `configured` ).
    double( )->configure_call( )->ignore_all_parameters( )->then_set_output( li_output ).
    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = lv_text.

    gi_env->clear_doubles( ).

    CLEAR lv_text.
    CALL FUNCTION 'FTD_DEMO'
      IMPORTING
        text = lv_text.
    cl_abap_unit_assert=>assert_initial( lv_text ).
    double( )->verify( )->is_called_once( ).
  ENDMETHOD.

ENDCLASS.

*****************************************

CLASS ltcl_restore DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS next_environment_ends_doubles FOR TESTING RAISING cx_static_check.
    METHODS function_module_comes_back FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_restore IMPLEMENTATION.

  METHOD next_environment_ends_doubles.
    DATA lt_deps TYPE if_function_test_environment=>tt_function_dependencies.

    INSERT 'FTD_FIRST' INTO TABLE lt_deps.
    cl_function_test_environment=>create( lt_deps ).
    CLEAR lt_deps.
    INSERT 'FTD_SECOND' INTO TABLE lt_deps.
    cl_function_test_environment=>create( lt_deps ).

    TRY.
        CALL FUNCTION 'FTD_FIRST'.
        cl_abap_unit_assert=>fail( 'FTD_FIRST must not be doubled any more' ).
      CATCH cx_sy_dyn_call_illegal_func.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD function_module_comes_back.
    DATA lt_deps   TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_env    TYPE REF TO if_function_test_environment.
    DATA li_output TYPE REF TO if_ftd_output_configuration.
    DATA lv_real   TYPE c LENGTH 10.
    DATA lv_output TYPE c LENGTH 10.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = '42'
      IMPORTING
        output = lv_real.

    INSERT 'CONVERSION_EXIT_ALPHA_INPUT' INTO TABLE lt_deps.
    li_env = cl_function_test_environment=>create( lt_deps ).
    li_output = li_env->get_double( 'CONVERSION_EXIT_ALPHA_INPUT' )->create_output_configuration( ).
    li_output->set_exporting_parameter( name  = 'OUTPUT'
                                        value = 'DOUBLE' ).
    li_env->get_double( 'CONVERSION_EXIT_ALPHA_INPUT' )->configure_call( )->ignore_all_parameters( )->then_set_output( li_output ).

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = '42'
      IMPORTING
        output = lv_output.
    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = 'DOUBLE' ).

    CLEAR lt_deps.
    INSERT 'FTD_OTHER' INTO TABLE lt_deps.
    cl_function_test_environment=>create( lt_deps ).

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = '42'
      IMPORTING
        output = lv_output.
    cl_abap_unit_assert=>assert_equals(
      act = lv_output
      exp = lv_real ).
  ENDMETHOD.

ENDCLASS.

*****************************************

CLASS ltcl_answer_raises DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_answer.
  PRIVATE SECTION.
    DATA mv_classic_exception TYPE abap_excpname.
    DATA mo_exception TYPE REF TO cx_root.

    METHODS setup.
    METHODS classic_exception FOR TESTING RAISING cx_static_check.
    METHODS class_based_exception FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_answer_raises IMPLEMENTATION.

  METHOD setup.
    DATA lt_deps TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_env  TYPE REF TO if_function_test_environment.

    INSERT 'FTD_ANSWER' INTO TABLE lt_deps.
    li_env = cl_function_test_environment=>create( lt_deps ).
    li_env->get_double( 'FTD_ANSWER' )->configure_call( )->ignore_all_parameters( )->then_answer( me ).
  ENDMETHOD.

  METHOD classic_exception.
    DATA lv_text TYPE string.

    mv_classic_exception = 'NOT_FOUND'.

    CALL FUNCTION 'FTD_ANSWER'
      IMPORTING
        text      = lv_text
      EXCEPTIONS
        locked    = 1
        not_found = 2
        OTHERS    = 3.

    cl_abap_unit_assert=>assert_subrc( exp = 2 ).
  ENDMETHOD.

  METHOD class_based_exception.
    DATA lx_raised TYPE REF TO cx_sy_zerodivide.

    CREATE OBJECT lx_raised.
    mo_exception = lx_raised.

    TRY.
        CALL FUNCTION 'FTD_ANSWER'.
        cl_abap_unit_assert=>fail( 'The answer must raise the exception' ).
      CATCH cx_sy_zerodivide.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD if_ftd_invocation_answer~answer.
    result->get_output_configuration( )->set_exporting_parameter(
      name  = 'TEXT'
      value = `answered` ).
    IF mv_classic_exception IS NOT INITIAL.
      result->raise_classic_exception( mv_classic_exception ).
    ELSEIF mo_exception IS BOUND.
      result->raise_exception( mo_exception ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.