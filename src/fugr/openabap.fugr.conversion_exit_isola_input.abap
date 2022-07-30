FUNCTION conversion_exit_isola_input.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"        VALUE(INPUT)
*"  EXPORTING
*"        VALUE(OUTPUT)
*"  EXCEPTIONS
*"         UNKNOWN_LANGUAGE
*"----------------------------------------------------------------------

* todo

* temp workaround, classic exceptions not really handled in transpiler yet
  sy-subrc = 0.

ENDFUNCTION.