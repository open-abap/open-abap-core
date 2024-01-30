CLASS cx_sy_zerodivide DEFINITION PUBLIC INHERITING FROM cx_sy_arithmetic_error.
  PUBLIC SECTION.
    METHODS if_message~get_text REDEFINITION.
ENDCLASS.

CLASS cx_sy_zerodivide IMPLEMENTATION.

  METHOD if_message~get_text.
    result = 'Division by zero.'.
  ENDMETHOD.

ENDCLASS.