INTERFACE if_function_test_environment PUBLIC.

  TYPES tt_function_dependencies TYPE STANDARD TABLE OF sxco_fm_name WITH KEY table_line.

  METHODS get_double
    IMPORTING
      function_name TYPE sxco_fm_name
    RETURNING
      VALUE(result) TYPE REF TO if_function_testdouble.

  METHODS clear_doubles.

ENDINTERFACE.