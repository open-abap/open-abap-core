INTERFACE if_function_testdouble PUBLIC.

  METHODS configure_call
    RETURNING
      VALUE(input_configuration_setter) TYPE REF TO if_ftd_input_config_setter.

ENDINTERFACE.