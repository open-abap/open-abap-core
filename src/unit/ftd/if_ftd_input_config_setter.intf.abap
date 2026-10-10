INTERFACE if_ftd_input_config_setter PUBLIC.

  METHODS when
    IMPORTING
      input_configuration                TYPE REF TO if_ftd_input_configuration
    RETURNING
      VALUE(output_configuration_setter) TYPE REF TO if_ftd_output_config_setter.

  METHODS ignore_all_parameters
    RETURNING
      VALUE(output_configuration_setter) TYPE REF TO if_ftd_output_config_setter.

ENDINTERFACE.