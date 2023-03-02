FUNCTION conversion_exit_alpha_output.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

  output = input.

  SHIFT output LEFT DELETING LEADING '0'.
  DO strlen( input ) - strlen( output ) TIMES.
    output = output && | |.
  ENDDO.

ENDFUNCTION.