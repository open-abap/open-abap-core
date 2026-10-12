INTERFACE if_function_testdouble PUBLIC.

  METHODS configure_call
    RETURNING
      VALUE(input_configuration_setter) TYPE REF TO if_ftd_input_config_setter.

  METHODS create_input_configuration
    RETURNING
      VALUE(result) TYPE REF TO if_ftd_input_configuration.

  METHODS create_output_configuration
    RETURNING
      VALUE(result) TYPE REF TO if_ftd_output_configuration.

  METHODS verify
    IMPORTING
      input_configuration          TYPE REF TO if_ftd_input_configuration OPTIONAL
    RETURNING
      VALUE(behavior_verification) TYPE REF TO if_ftd_behavior_verification.

  METHODS clear.

ENDINTERFACE.