CLASS cl_abap_char_utilities DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS:
      cr_lf TYPE c LENGTH 2 VALUE '\r\n',
* https://en.wikipedia.org/wiki/Byte_order_mark, 0xEF,0xBB,0xBF
      byte_order_mark_utf8 TYPE x LENGTH 3 VALUE 'EFBBBF',
      byte_order_mark_big TYPE x LENGTH 2 VALUE 'FEFF',
      byte_order_mark_little TYPE x LENGTH 2 VALUE 'FFFE',
      horizontal_tab TYPE c LENGTH 1 VALUE '\t',
      newline TYPE c LENGTH 2 VALUE '\n'.
ENDCLASS.

CLASS cl_abap_char_utilities IMPLEMENTATION.

ENDCLASS.