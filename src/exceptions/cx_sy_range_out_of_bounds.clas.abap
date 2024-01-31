CLASS cx_sy_range_out_of_bounds DEFINITION PUBLIC INHERITING FROM cx_sy_data_access_error.

  PUBLIC SECTION.
    METHODS if_message~get_text REDEFINITION.

ENDCLASS.

CLASS cx_sy_range_out_of_bounds IMPLEMENTATION.

  METHOD if_message~get_text.
    result = 'Range out of bounds'.
  ENDMETHOD.

ENDCLASS.