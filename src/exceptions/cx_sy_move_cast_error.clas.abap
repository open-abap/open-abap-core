CLASS cx_sy_move_cast_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.

  PUBLIC SECTION.
    METHODS if_message~get_text REDEFINITION.

ENDCLASS.

CLASS cx_sy_move_cast_error IMPLEMENTATION.

  METHOD if_message~get_text.
    result = 'Casting failed, types not compatible'.
  ENDMETHOD.

ENDCLASS.