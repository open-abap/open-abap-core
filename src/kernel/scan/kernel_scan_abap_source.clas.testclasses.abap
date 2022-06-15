CLASS ltcl_scan DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
    METHODS test2 FOR TESTING RAISING cx_static_check.
    METHODS dump_tokens
      IMPORTING tokens TYPE kernel_scan_abap_source=>ty_stokesx
      RETURNING VALUE(dump) TYPE string.
ENDCLASS.

CLASS ltcl_scan IMPLEMENTATION.

  METHOD dump_tokens.
    DATA token LIKE LINE OF tokens.
    LOOP AT tokens INTO token.
      dump = dump && |str:{ token-str },row:{ token-row },col:{ token-col }|.
      IF sy-tabix < lines( tokens ).
        dump = dump && |\n|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD test1.
    DATA tokens TYPE STANDARD TABLE OF stokesx WITH DEFAULT KEY.
    DATA statements TYPE STANDARD TABLE OF sstmnt WITH DEFAULT KEY.
    DATA source TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    APPEND 'WRITE 2.' TO source.

    SCAN ABAP-SOURCE source
      TOKENS INTO tokens
      STATEMENTS INTO statements
      WITH ANALYSIS
      WITH COMMENTS
      WITH PRAGMAS '*'.

    cl_abap_unit_assert=>assert_equals(
      act = lines( statements )
      exp = 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:WRITE,row:1,col:0\n| &&
            |str:2,row:1,col:6| ).

  ENDMETHOD.

  METHOD test2.

    DATA tokens TYPE STANDARD TABLE OF stokesx WITH DEFAULT KEY.
    DATA statements TYPE STANDARD TABLE OF sstmnt WITH DEFAULT KEY.
    DATA lv_source TYPE string.

    lv_source =
      |class lcl definition.\n| &&
      |ENDCLASS.\n| &&
      |CLASS lcl IMPLEMENTATION.\n| &&
      |ENDCLASS.|.

    SCAN ABAP-SOURCE lv_source
      TOKENS INTO tokens
      STATEMENTS INTO statements
      WITH ANALYSIS
      WITH COMMENTS
      WITH PRAGMAS '*'.

    cl_abap_unit_assert=>assert_equals(
      act = lines( statements )
      exp = 4 ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( tokens )
      exp = 8 ).

  ENDMETHOD.

ENDCLASS.