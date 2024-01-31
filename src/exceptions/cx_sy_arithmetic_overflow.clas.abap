CLASS cx_sy_arithmetic_overflow DEFINITION PUBLIC INHERITING FROM cx_sy_arithmetic_error.

  PUBLIC SECTION.
    METHODS if_message~get_text REDEFINITION.

ENDCLASS.

CLASS cx_sy_arithmetic_overflow IMPLEMENTATION.

  METHOD if_message~get_text.
    result = 'Arithmetic overflow'.
  ENDMETHOD.

ENDCLASS.