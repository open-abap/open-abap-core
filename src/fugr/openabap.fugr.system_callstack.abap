FUNCTION system_callstack.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(CALLSTACK) TYPE  ABAP_CALLSTACK
*"----------------------------------------------------------------------

  FIELD-SYMBOLS: <fs> LIKE LINE OF callstack.

  APPEND INITIAL LINE TO callstack ASSIGNING <fs>.
  <fs>-mainprogram = 'ZTODO'.
  <fs>-include = 'ZTODO'.
  <fs>-line = '123'.

ENDFUNCTION.
