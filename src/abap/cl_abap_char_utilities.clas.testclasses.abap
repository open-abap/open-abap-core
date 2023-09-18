CLASS ltcl_char_utilities DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS test2 FOR TESTING RAISING cx_static_check.
    METHODS horizontal_tab FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_char_utilities IMPLEMENTATION.

  METHOD test1.
    DATA foo TYPE string.
    DATA tab TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    foo = |foo\nbar|.
    SPLIT foo AT cl_abap_char_utilities=>newline INTO TABLE tab.
    cl_abap_unit_assert=>assert_equals(
      act = lines( tab )
      exp = 2 ).
  ENDMETHOD.

  METHOD test2.
* check that this is not a syntax error,
    CONSTANTS foo LIKE cl_abap_char_utilities=>newline VALUE cl_abap_char_utilities=>newline.

    cl_abap_unit_assert=>assert_equals(
      act = strlen( cl_abap_char_utilities=>newline )
      exp = 1 ).
  ENDMETHOD.

  METHOD horizontal_tab.

    DATA str TYPE string.
    DATA tab TYPE string_table.

    str = |foo\tbar|.
    SPLIT str AT cl_abap_char_utilities=>horizontal_tab INTO TABLE tab.

    cl_abap_unit_assert=>assert_equals(
      act = lines( tab )
      exp = 2 ).

  ENDMETHOD.

ENDCLASS.