CLASS cl_abap_char_utilities DEFINITION PUBLIC.
  PUBLIC SECTION.
* https://en.wikipedia.org/wiki/Byte_order_mark, 0xEF,0xBB,0xBF
    CONSTANTS byte_order_mark_utf8   TYPE x LENGTH 3 VALUE 'EFBBBF'.
    CONSTANTS byte_order_mark_big    TYPE x LENGTH 2 VALUE 'FEFF'.
    CONSTANTS byte_order_mark_little TYPE x LENGTH 2 VALUE 'FFFE'.
    CONSTANTS charsize               TYPE i VALUE 2.
* open-abap is little endian
    CONSTANTS endian                 TYPE abap_endian VALUE 'L'.

    CONSTANTS backspace      TYPE abap_char1 VALUE %_backspace.
    CONSTANTS cr_lf          TYPE abap_cr_lf VALUE %_cr_lf.
    CONSTANTS form_feed      TYPE abap_char1 VALUE %_formfeed.
    CONSTANTS horizontal_tab TYPE abap_char1 VALUE %_horizontal_tab.
    CONSTANTS newline        TYPE abap_char1 VALUE %_newline.
    CONSTANTS vertical_tab   TYPE abap_char1 VALUE %_vertical_tab.

    CONSTANTS maxchar        TYPE abap_char1 VALUE '_'.
    CONSTANTS minchar        TYPE abap_char1 VALUE '_'.

    CLASS-METHODS class_constructor.

    CLASS-METHODS get_simple_spaces_for_cur_cp
      RETURNING
        VALUE(s_str) TYPE string.
ENDCLASS.

CLASS cl_abap_char_utilities IMPLEMENTATION.

  METHOD class_constructor.
    " WRITE '@KERNEL cl_abap_char_utilities.backspace.set("\b");'.
    " WRITE '@KERNEL cl_abap_char_utilities.cr_lf.set("\r\n");'.
    " WRITE '@KERNEL cl_abap_char_utilities.form_feed.set("\f");'.
    " WRITE '@KERNEL cl_abap_char_utilities.horizontal_tab.set("\t");'.
    WRITE '@KERNEL cl_abap_char_utilities.maxchar.set(Buffer.from("FDFF", "hex").toString());'.
    WRITE '@KERNEL cl_abap_char_utilities.minchar.set(Buffer.from("0000", "hex").toString());'.
    " WRITE '@KERNEL cl_abap_char_utilities.newline.set("\n");'.
    " WRITE '@KERNEL cl_abap_char_utilities.vertical_tab.set("\v");'.
  ENDMETHOD.

  METHOD get_simple_spaces_for_cur_cp.
    CONCATENATE ` ` horizontal_tab vertical_tab newline cr_lf(1) form_feed INTO s_str.
  ENDMETHOD.

ENDCLASS.