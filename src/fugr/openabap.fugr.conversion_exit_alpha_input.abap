FUNCTION conversion_exit_alpha_input.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

  DATA lv_len TYPE i.

  output = input.
  CONDENSE output.

  DESCRIBE FIELD output LENGTH lv_len IN CHARACTER MODE.

  DO lv_len - strlen( output ) TIMES.
    output = |0| && output.
  ENDDO.

ENDFUNCTION.