INTERFACE if_abap_testdouble_matcher PUBLIC.

  METHODS matches
    IMPORTING
      method_name          TYPE abap_methname
      configured_arguments TYPE REF TO if_abap_testdouble_arguments
      actual_arguments     TYPE REF TO if_abap_testdouble_arguments
    RETURNING
      VALUE(result)        TYPE abap_bool
    RAISING
      cx_atd_exception_core.

ENDINTERFACE.
