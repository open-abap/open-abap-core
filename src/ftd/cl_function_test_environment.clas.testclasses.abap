CLASS ltcl_test DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_answer.

  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA lt_deps    TYPE if_function_test_environment=>tt_function_dependencies.
    DATA li_double  TYPE REF TO if_function_testdouble.
    DATA lv_message TYPE string.

    INSERT 'ABC' INTO TABLE lt_deps.
    li_double = cl_function_test_environment=>create( lt_deps )->get_double( 'ABC' ).
    li_double->configure_call( )->ignore_all_parameters( )->then_answer( me ).

    CALL FUNCTION 'ABC'
      IMPORTING
        message = lv_message.

  ENDMETHOD.

  METHOD if_ftd_invocation_answer~answer.

    result->get_output_configuration( )->set_exporting_parameter(
      name  = 'MESSAGE'
      value = 'Hello World' ).

  ENDMETHOD.

ENDCLASS.