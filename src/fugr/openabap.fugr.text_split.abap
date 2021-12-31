FUNCTION text_split.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(LENGTH)
*"     REFERENCE(TEXT)
*"  EXPORTING
*"     VALUE(LINE)
*"     VALUE(REST)
*"----------------------------------------------------------------------

  IF strlen( text ) < 50.
    line = text.
    rest = ''.
  ELSE.
    line = text(50).
    rest = text+50.
  ENDIF.

ENDFUNCTION.