INTERFACE if_ftd_invocation_result PUBLIC.

  METHODS get_output_configuration
    RETURNING
      VALUE(result) TYPE REF TO if_ftd_output_configuration.

  METHODS raise_classic_exception
    IMPORTING
      classic_exception TYPE abap_excpname.

  METHODS raise_exception
    IMPORTING
      exception TYPE REF TO cx_root.

ENDINTERFACE.