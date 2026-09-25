FUNCTION scms_binary_to_xstring.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(INPUT_LENGTH) TYPE  I
*"     VALUE(FIRST_LINE) TYPE  I DEFAULT 0
*"     VALUE(LAST_LINE) TYPE  I DEFAULT 0
*"  EXPORTING
*"     VALUE(BUFFER) TYPE  XSTRING
*"  TABLES
*"      BINARY_TAB
*"  EXCEPTIONS
*"      FAILED
*"----------------------------------------------------------------------

* The rows are fixed width, so the last one is padded and INPUT_LENGTH is
* where the content ends. The rows are joined as hex once, not concatenated
* one by one, which would copy the growing buffer for every row.

  DATA lt_parts TYPE STANDARD TABLE OF string WITH EMPTY KEY.
  DATA lv_part  TYPE string.
  DATA lv_hex   TYPE string.
  DATA lv_cut   TYPE i.
  DATA lv_kind  TYPE c LENGTH 1.
  FIELD-SYMBOLS <ls_row> TYPE any.
  FIELD-SYMBOLS <lv_line> TYPE any.

  CLEAR buffer.

  IF first_line <> 0 OR last_line <> 0.
    ASSERT 1 = 'todo'.
  ENDIF.

* measured on a system: 0 or a negative length gives an empty buffer
  IF input_length <= 0.
    RETURN.
  ENDIF.

  LOOP AT binary_tab ASSIGNING <ls_row>.
    DESCRIBE FIELD <ls_row> TYPE lv_kind.
    IF lv_kind = 'u'.
      ASSIGN COMPONENT 1 OF STRUCTURE <ls_row> TO <lv_line>.
    ELSE.
      ASSIGN <ls_row> TO <lv_line>.
    ENDIF.
    lv_part = <lv_line>.
    APPEND lv_part TO lt_parts.
  ENDLOOP.
  CONCATENATE LINES OF lt_parts INTO lv_hex.

* two hex characters to the byte; more than there is gives all of it
  lv_cut = input_length * 2.
  IF lv_cut < strlen( lv_hex ).
    lv_hex = lv_hex(lv_cut).
  ENDIF.

  buffer = lv_hex.

ENDFUNCTION.
