INTERFACE if_abap_testdouble_arguments PUBLIC.

  METHODS get_param_importing
    IMPORTING
      name         TYPE abap_parmname
    RETURNING
      VALUE(value) TYPE REF TO data
    RAISING
      cx_atd_param_not_found.

  METHODS is_importing_param_supplied
    IMPORTING
      name          TYPE abap_parmname
    RETURNING
      VALUE(result) TYPE abap_bool
    RAISING
      cx_atd_param_not_found.

  METHODS get_param_changing
    IMPORTING
      name         TYPE abap_parmname
    RETURNING
      VALUE(value) TYPE REF TO data
    RAISING
      cx_atd_param_not_found.

  METHODS is_changing_param_supplied
    IMPORTING
      name          TYPE abap_parmname
    RETURNING
      VALUE(result) TYPE abap_bool
    RAISING
      cx_atd_param_not_found.

  METHODS next_parameter
    EXPORTING
      name   TYPE abap_parmname
      kind   TYPE abap_parmkind
      ignore TYPE abap_bool
    RAISING
      cx_atd_exception_core.

  METHODS has_next_parameter
    RETURNING
      VALUE(result) TYPE abap_bool.

  METHODS reset_iterator.

  METHODS size_of
    RETURNING
      VALUE(size) TYPE i.

ENDINTERFACE.
