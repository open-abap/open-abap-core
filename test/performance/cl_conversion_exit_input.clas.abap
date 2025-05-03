CLASS cl_conversion_exit_input DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_conversion_exit_input IMPLEMENTATION.
  METHOD run.
    DATA lv_value TYPE c LENGTH 10.

    DO 500000 TIMES.
      lv_value = '1'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_value
        IMPORTING
          output = lv_value.
    ENDDO.
  ENDMETHOD.
ENDCLASS.