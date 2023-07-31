INTERFACE if_ftd_invocation_result PUBLIC.

  METHODS get_output_configuration
    RETURNING
      VALUE(result) TYPE REF TO if_ftd_output_configuration.

ENDINTERFACE.