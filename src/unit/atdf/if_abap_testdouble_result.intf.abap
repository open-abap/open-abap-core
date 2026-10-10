INTERFACE if_abap_testdouble_result PUBLIC.

  METHODS set_param_changing
    IMPORTING
      name  TYPE abap_parmname
      value TYPE any
    RAISING
      cx_atd_exception_core.

  METHODS set_param_exporting
    IMPORTING
      name  TYPE abap_parmname
      value TYPE any
    RAISING
      cx_atd_exception_core.

  METHODS set_param_returning
    IMPORTING
      value TYPE any.

  METHODS raise_exception
    IMPORTING
      exception TYPE REF TO cx_root.

ENDINTERFACE.
