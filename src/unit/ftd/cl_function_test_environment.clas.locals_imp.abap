
CLASS lcl_output_config_setter DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_ftd_output_config_setter.
ENDCLASS.

CLASS lcl_output_config_setter IMPLEMENTATION.
  METHOD if_ftd_output_config_setter~then_answer.
* todo
    RETURN.
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