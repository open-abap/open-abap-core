CLASS cl_conversion_exit_input DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS run.
ENDCLASS.

CLASS cl_conversion_exit_input IMPLEMENTATION.
  METHOD run.
    DATA lv_value TYPE c length 10.

    DO 16000 TIMES.
      CLEAR lv_value.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_value
        IMPORTING
          output = lv_value.
    ENDDO.
  ENDMETHOD.
ENDCLASS.