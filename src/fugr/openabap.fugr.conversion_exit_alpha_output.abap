FUNCTION conversion_exit_alpha_output.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

  output = input.

* todo, handle alpha

  SHIFT output LEFT DELETING LEADING '0'.

ENDFUNCTION.