CLASS lcl_input_arguments DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_input_arguments.
ENDCLASS.

CLASS lcl_input_arguments IMPLEMENTATION.
  METHOD if_ftd_input_arguments~get_importing_parameter.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_output_configuration DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_output_configuration.
ENDCLASS.

CLASS lcl_output_configuration IMPLEMENTATION.
  METHOD if_ftd_output_configuration~set_exporting_parameter.
* todo

    self = me.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_invocation_result DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_invocation_result.
ENDCLASS.

CLASS lcl_invocation_result IMPLEMENTATION.
  METHOD if_ftd_invocation_result~get_output_configuration.
    CREATE OBJECT result TYPE lcl_output_configuration.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_invoker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS invoke
      IMPORTING
        fminput TYPE any
        answer  TYPE REF TO if_ftd_invocation_answer.
ENDCLASS.

CLASS lcl_invoker IMPLEMENTATION.
  METHOD invoke.
    DATA li_result    TYPE REF TO if_ftd_invocation_result.
    DATA li_arguments TYPE REF TO if_ftd_input_arguments.

    CREATE OBJECT li_result TYPE lcl_invocation_result.

* todo, set arguments
*    WRITE '@KERNEL console.dir(fminput);'.

    answer->answer(
      EXPORTING
        arguments = li_arguments
      CHANGING
        result    = li_result ).

* todo, set result
    WRITE '@KERNEL fminput.importing.message.set("Hello World");'.

  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_double DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_function_testdouble.
    INTERFACES if_ftd_input_config_setter.
    INTERFACES if_ftd_output_config_setter.

    METHODS constructor IMPORTING iv_name TYPE sxco_fm_name.
  PRIVATE SECTION.
    DATA mv_name TYPE sxco_fm_name.
ENDCLASS.

CLASS lcl_double IMPLEMENTATION.
  METHOD constructor.
    ASSERT iv_name IS NOT INITIAL.
    mv_name = iv_name.
  ENDMETHOD.

  METHOD if_function_testdouble~configure_call.
    input_configuration_setter = me.
  ENDMETHOD.

  METHOD if_ftd_input_config_setter~ignore_all_parameters.
    output_configuration_setter = me.
  ENDMETHOD.

  METHOD if_ftd_output_config_setter~then_answer.
    WRITE '@KERNEL abap.FunctionModules[this.mv_name.get().trimEnd()] = (INPUT) => lcl_invoker.invoke({fminput: INPUT, answer});'.
  ENDMETHOD.
ENDCLASS.