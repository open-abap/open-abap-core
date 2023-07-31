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

CLASS lcl_output_config_setter DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_output_config_setter.
ENDCLASS.

CLASS lcl_output_config_setter IMPLEMENTATION.
  METHOD if_ftd_output_config_setter~then_answer.
    " todo, dont hardcode "ABC",
    WRITE '@KERNEL abap.FunctionModules["ABC"] = (INPUT) => lcl_invoker.invoke({fminput: INPUT, answer});'.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_input_config_setter DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_input_config_setter.
ENDCLASS.

CLASS lcl_input_config_setter IMPLEMENTATION.
  METHOD if_ftd_input_config_setter~ignore_all_parameters.
    CREATE OBJECT output_configuration_setter TYPE lcl_output_config_setter.
  ENDMETHOD.
ENDCLASS.

*************************************************************

CLASS lcl_double DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_function_testdouble.
ENDCLASS.

CLASS lcl_double IMPLEMENTATION.
  METHOD if_function_testdouble~configure_call.
    CREATE OBJECT input_configuration_setter TYPE lcl_input_config_setter.
  ENDMETHOD.
ENDCLASS.