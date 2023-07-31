CLASS lcl_invoker DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS invoke
      IMPORTING
        fminput TYPE any
        answer  TYPE REF TO if_ftd_invocation_answer.
ENDCLASS.

CLASS lcl_invoker IMPLEMENTATION.
  METHOD invoke.
    WRITE '@KERNEL console.dir("hello from invoker");'.
    WRITE '@KERNEL answer.get().if_ftd_invocation_answer$answer();'.
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