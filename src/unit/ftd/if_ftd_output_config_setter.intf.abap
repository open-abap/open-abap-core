INTERFACE if_ftd_output_config_setter PUBLIC.

  METHODS then_answer
    IMPORTING
      answer      TYPE REF TO if_ftd_invocation_answer
    RETURNING
      VALUE(self) TYPE REF TO if_ftd_output_config_setter.

ENDINTERFACE.