INTERFACE if_ftd_input_arguments PUBLIC.

  METHODS get_importing_parameter
    IMPORTING
      name          TYPE abap_parmname
    RETURNING
      VALUE(result) TYPE REF TO data
    RAISING
      cx_ftd_parameter_not_found.

ENDINTERFACE.