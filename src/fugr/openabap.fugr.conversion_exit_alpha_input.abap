FUNCTION conversion_exit_alpha_input.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

  DATA lv_len  TYPE i.
  DATA lv_type TYPE c LENGTH 1.
  DATA lv_tmp  TYPE string.

  lv_tmp = input.
  CONDENSE lv_tmp.

  DESCRIBE FIELD input TYPE lv_type.
  IF lv_type = 'g' OR lv_type = 'D'.
    DESCRIBE FIELD output TYPE lv_type.
    IF lv_type = 'g' OR lv_type = 'D'.
      output = input.
      RETURN.
    ENDIF.
    DESCRIBE FIELD output LENGTH lv_len IN CHARACTER MODE.
  ELSE.
    DESCRIBE FIELD input LENGTH lv_len IN CHARACTER MODE.
  ENDIF.

  IF lv_tmp IS INITIAL.
    CLEAR output.
    RETURN.
  ENDIF.

  IF lv_tmp NA sy-abcde.
    DO lv_len - strlen( lv_tmp ) TIMES.
      lv_tmp = |0| && lv_tmp.
    ENDDO.
  ENDIF.

  output = lv_tmp.

ENDFUNCTION.