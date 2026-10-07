INTERFACE if_abap_testdouble_answer PUBLIC.

  METHODS answer
    IMPORTING
      method_name   TYPE abap_methname
      double_handle TYPE REF TO if_abap_testdouble_handle
      arguments     TYPE REF TO if_abap_testdouble_arguments
    CHANGING
      result        TYPE REF TO if_abap_testdouble_result
    RAISING
      cx_atd_exception_core.

ENDINTERFACE.
