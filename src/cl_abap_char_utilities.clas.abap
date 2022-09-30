CLASS cl_abap_char_utilities DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS:
* https://en.wikipedia.org/wiki/Byte_order_mark, 0xEF,0xBB,0xBF
      byte_order_mark_utf8   TYPE x LENGTH 3 VALUE 'EFBBBF',
      byte_order_mark_big    TYPE x LENGTH 2 VALUE 'FEFF',
      byte_order_mark_little TYPE x LENGTH 2 VALUE 'FFFE',
      cr_lf                  TYPE c LENGTH 2 VALUE '__',
      charsize               TYPE i VALUE 2,
      horizontal_tab         TYPE c LENGTH 1 VALUE '_',
      vertical_tab           TYPE c LENGTH 1 VALUE '_',
      form_feed              TYPE c LENGTH 1 VALUE '_',
      backspace              TYPE c LENGTH 1 VALUE '_',
      minchar                TYPE c LENGTH 1 VALUE '_',
      maxchar                TYPE c LENGTH 1 VALUE '_',
      newline                TYPE c LENGTH 1 VALUE '_'.

    CLASS-METHODS class_constructor.

    CLASS-METHODS get_simple_spaces_for_cur_cp
      RETURNING
        VALUE(s_str) TYPE string.
ENDCLASS.

CLASS cl_abap_char_utilities IMPLEMENTATION.

  METHOD class_constructor.
    WRITE '@KERNEL cl_abap_char_utilities.cr_lf.set("\r\n");'.
    WRITE '@KERNEL cl_abap_char_utilities.horizontal_tab.set("\t");'.
    WRITE '@KERNEL cl_abap_char_utilities.vertical_tab.set("\v");'.
    WRITE '@KERNEL cl_abap_char_utilities.form_feed.set("\f");'.
    WRITE '@KERNEL cl_abap_char_utilities.backspace.set("\b");'.
    WRITE '@KERNEL cl_abap_char_utilities.newline.set("\n");'.
    WRITE '@KERNEL cl_abap_char_utilities.minchar.set(Buffer.from("0000", "hex").toString());'.
    WRITE '@KERNEL cl_abap_char_utilities.maxchar.set(Buffer.from("FDFF", "hex").toString());'.
  ENDMETHOD.

  METHOD get_simple_spaces_for_cur_cp.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.