CLASS ltcl_test DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_answer.
  PRIVATE SECTION.
    CONSTANTS gc_hello_world TYPE string VALUE 'Hello World'.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA lt_deps    TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_env     TYPE REF TO if_function_test_environment.
    DATA lv_message TYPE string.

    li_env = cl_function_test_environment=>create( lt_deps ).

    INSERT 'ABC' INTO TABLE lt_deps.
    li_env->get_double( 'ABC' )->configure_call( )->ignore_all_parameters( )->then_answer( me ).

    CALL FUNCTION 'ABC'
      IMPORTING
        message = lv_message.

    cl_abap_unit_assert=>assert_equals(
      act = lv_message
      exp = gc_hello_world ).

    li_env->clear_doubles( ).

  ENDMETHOD.

  METHOD if_ftd_invocation_answer~answer.

    result->get_output_configuration( )->set_exporting_parameter(
      name  = 'MESSAGE'
      value = gc_hello_world ).

  ENDMETHOD.

ENDCLASS.