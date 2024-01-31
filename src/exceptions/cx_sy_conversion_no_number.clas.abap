CLASS cx_sy_conversion_no_number DEFINITION PUBLIC INHERITING FROM cx_sy_conversion_error.

  PUBLIC SECTION.
    METHODS if_message~get_text REDEFINITION.

ENDCLASS.

CLASS cx_sy_conversion_no_number IMPLEMENTATION.

  METHOD if_message~get_text.
    result = 'Conversion no number'.
  ENDMETHOD.

ENDCLASS.