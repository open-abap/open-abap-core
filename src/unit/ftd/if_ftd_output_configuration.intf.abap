INTERFACE if_ftd_output_configuration PUBLIC.

  METHODS set_exporting_parameter
    IMPORTING
      name  TYPE abap_parmname
      value TYPE any
    RETURNING
      VALUE(self) TYPE REF TO if_ftd_output_configuration
    RAISING
      cx_ftd_parameter_not_found.

ENDINTERFACE.