FUNCTION convert_itf_to_stream_text.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(LF)
*"  EXPORTING
*"     REFERENCE(STREAM_LINES) TYPE  STRING_TABLE
*"  TABLES
*"      ITF_TEXT STRUCTURE  TLINE
*"      TEXT_STREAM OPTIONAL
*"----------------------------------------------------------------------

  CLEAR stream_lines.
  CLEAR text_stream.

  IF lines( itf_text ) = 0.
    RETURN.
  ENDIF.

* todo

  ASSERT 'todo' = 1.

ENDFUNCTION.