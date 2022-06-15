CLASS ltcl_scan DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS simple_write FOR TESTING RAISING cx_static_check.
    METHODS class_impl_def FOR TESTING RAISING cx_static_check.
    METHODS simple_indentation FOR TESTING RAISING cx_static_check.

    DATA tokens TYPE STANDARD TABLE OF stokesx WITH DEFAULT KEY.
    DATA statements TYPE STANDARD TABLE OF sstmnt WITH DEFAULT KEY.
    METHODS scan IMPORTING source TYPE string.
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

  METHOD scan.
    DATA lv TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    SPLIT source AT |\n| INTO TABLE lv.

    SCAN ABAP-SOURCE lv
      TOKENS INTO tokens
      STATEMENTS INTO statements
      WITH ANALYSIS
      WITH COMMENTS
      WITH PRAGMAS '*'.
  ENDMETHOD.

  METHOD simple_write.

    scan( 'WRITE 2.' ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( statements )
      exp = 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:WRITE,row:1,col:0\n| &&
            |str:2,row:1,col:6| ).
  ENDMETHOD.

  METHOD class_impl_def.

    scan(
      |class lcl definition.\n| &&
      |ENDCLASS.\n| &&
      |CLASS lcl IMPLEMENTATION.\n| &&
      |ENDCLASS.| ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( statements )
      exp = 4 ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:CLASS,row:1,col:0\n| &&
            |str:LCL,row:1,col:6\n| &&
            |str:DEFINITION,row:1,col:10\n| &&
            |str:ENDCLASS,row:2,col:0\n| &&
            |str:CLASS,row:3,col:0\n| &&
            |str:LCL,row:3,col:6\n| &&
            |str:IMPLEMENTATION,row:3,col:10\n| &&
            |str:ENDCLASS,row:4,col:0| ).
  ENDMETHOD.

  METHOD simple_indentation.
  ENDMETHOD.

ENDCLASS.