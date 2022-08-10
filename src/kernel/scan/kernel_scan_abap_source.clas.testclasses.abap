CLASS ltcl_scan DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS simple_write FOR TESTING RAISING cx_static_check.
    METHODS class_impl_def FOR TESTING RAISING cx_static_check.
    METHODS simple_indentation FOR TESTING RAISING cx_static_check.
    METHODS comment_line FOR TESTING RAISING cx_static_check.
    METHODS two_comment_line FOR TESTING RAISING cx_static_check.
    METHODS end_of_comment_line FOR TESTING RAISING cx_static_check.
    METHODS chained FOR TESTING RAISING cx_static_check.
    METHODS class_simple FOR TESTING RAISING cx_static_check.
    METHODS comment_sequence_end_of_line FOR TESTING RAISING cx_static_check.
    METHODS comment_sequence_full_line FOR TESTING RAISING cx_static_check.
    METHODS comment_sequence_multi FOR TESTING RAISING cx_static_check.
    METHODS comment_sequence_two FOR TESTING RAISING cx_static_check.
    METHODS some_type FOR TESTING RAISING cx_static_check.

    DATA tokens TYPE STANDARD TABLE OF stokesx WITH DEFAULT KEY.
    DATA statements TYPE STANDARD TABLE OF sstmnt WITH DEFAULT KEY.
    METHODS scan IMPORTING source TYPE string.
    METHODS dump_tokens
      IMPORTING tokens TYPE kernel_scan_abap_source=>ty_stokesx
      RETURNING VALUE(dump) TYPE string.
    METHODS dump_statements
      IMPORTING statements TYPE kernel_scan_abap_source=>ty_sstmnt
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

  METHOD dump_statements.
    DATA statement LIKE LINE OF statements.
    LOOP AT statements INTO statement.
      dump = dump && |from:{ statement-from },to:{ statement-to }|.
      IF sy-tabix < lines( statements ).
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
      act = dump_statements( statements )
      exp = 'from:1,to:2' ).

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
    scan(
      |IF foo = bar.\n| &&
      |  WRITE foo.\n| &&
      |ENDIF.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:4\n| &&
            |from:5,to:6\n| &&
            |from:7,to:7| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:IF,row:1,col:0\n| &&
            |str:FOO,row:1,col:3\n| &&
            |str:=,row:1,col:7\n| &&
            |str:BAR,row:1,col:9\n| &&
            |str:WRITE,row:2,col:2\n| &&
            |str:FOO,row:2,col:8\n| &&
            |str:ENDIF,row:3,col:0| ).
  ENDMETHOD.

  METHOD comment_line.
    scan( |* full line comment| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:1| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:* full line comment,row:1,col:0| ).
  ENDMETHOD.

  METHOD two_comment_line.
    scan(
      |* full line comment\n| &&
      |* another| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:2| ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( tokens )
      exp = 2 ).
  ENDMETHOD.

  METHOD end_of_comment_line.
    scan( |  " partial| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:1| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:" partial,row:1,col:2| ).
  ENDMETHOD.

  METHOD chained.
    scan(
      |DATA: BEGIN OF foo,\n| &&
      |  field TYPE i,\n| &&
      |END OF foo.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:DATA,row:1,col:0\n| &&
            |str:BEGIN,row:1,col:6\n| &&
            |str:OF,row:1,col:12\n| &&
            |str:FOO,row:1,col:15\n| &&
            |str:DATA,row:1,col:0\n| &&
            |str:FIELD,row:2,col:2\n| &&
            |str:TYPE,row:2,col:8\n| &&
            |str:I,row:2,col:13\n| &&
            |str:DATA,row:1,col:0\n| &&
            |str:END,row:3,col:0\n| &&
            |str:OF,row:3,col:4\n| &&
            |str:FOO,row:3,col:7| ).
  ENDMETHOD.

  METHOD comment_sequence_end_of_line.

    scan(
      |  TYPES:\n| &&
      |    "! $hiddenabc\n| &&
      |    unknown_annotation TYPE string.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:"! $hiddenabc,row:2,col:4\n| &&
            |str:TYPES,row:1,col:2\n| &&
            |str:UNKNOWN_ANNOTATION,row:3,col:4\n| &&
            |str:TYPE,row:3,col:23\n| &&
            |str:STRING,row:3,col:28| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:1\n| &&
            |from:2,to:5| ).

  ENDMETHOD.

  METHOD comment_sequence_full_line.

    scan(
      |  TYPES:\n| &&
      |* $hiddenabc\n| &&
      |    unknown_annotation TYPE string.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:* $hiddenabc,row:2,col:0\n| &&
            |str:TYPES,row:1,col:2\n| &&
            |str:UNKNOWN_ANNOTATION,row:3,col:4\n| &&
            |str:TYPE,row:3,col:23\n| &&
            |str:STRING,row:3,col:28| ).

  ENDMETHOD.

  METHOD comment_sequence_multi.

    scan(
      |TYPES:\n| &&
      |* foo\n| &&
      |    foo TYPE string,\n| &&
      |* bar\n| &&
      |    bar TYPE string.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:* foo,row:2,col:0\n| &&
            |str:TYPES,row:1,col:0\n| &&
            |str:FOO,row:3,col:4\n| &&
            |str:TYPE,row:3,col:8\n| &&
            |str:STRING,row:3,col:13\n| &&
            |str:* bar,row:4,col:0\n| &&
            |str:TYPES,row:1,col:0\n| &&
            |str:BAR,row:5,col:4\n| &&
            |str:TYPE,row:5,col:8\n| &&
            |str:STRING,row:5,col:13| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:1\n| &&
            |from:2,to:5\n| &&
            |from:6,to:6\n| &&
            |from:7,to:10| ).

  ENDMETHOD.

  METHOD comment_sequence_two.

    scan(
      |  TYPES:\n| &&
      |* first\n| &&
      |* second\n| &&
      |    unknown_annotation TYPE string.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:* first,row:2,col:0\n| &&
            |str:* second,row:3,col:0\n| &&
            |str:TYPES,row:1,col:2\n| &&
            |str:UNKNOWN_ANNOTATION,row:4,col:4\n| &&
            |str:TYPE,row:4,col:23\n| &&
            |str:STRING,row:4,col:28| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_statements( statements )
      exp = |from:1,to:2\n| &&
            |from:3,to:6| ).

  ENDMETHOD.

  METHOD class_simple.

    scan(
      |CLASS zcl_aff_test_types DEFINITION PUBLIC FINAL CREATE PUBLIC.\n| &&
      |PUBLIC SECTION.\n| &&
      |  TYPES:\n| &&
      |    "! $hiddenabc\n| &&
      |    unknown_annotation TYPE string.\n| &&
      |ENDCLASS.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:CLASS,row:1,col:0\n| &&
            |str:ZCL_AFF_TEST_TYPES,row:1,col:6\n| &&
            |str:DEFINITION,row:1,col:25\n| &&
            |str:PUBLIC,row:1,col:36\n| &&
            |str:FINAL,row:1,col:43\n| &&
            |str:CREATE,row:1,col:49\n| &&
            |str:PUBLIC,row:1,col:56\n| &&
            |str:PUBLIC,row:2,col:0\n| &&
            |str:SECTION,row:2,col:7\n| &&
            |str:"! $hiddenabc,row:4,col:4\n| &&
            |str:TYPES,row:3,col:2\n| &&
            |str:UNKNOWN_ANNOTATION,row:5,col:4\n| &&
            |str:TYPE,row:5,col:23\n| &&
            |str:STRING,row:5,col:28\n| &&
            |str:ENDCLASS,row:6,col:0| ).

  ENDMETHOD.

  METHOD some_type.
    scan(
      |* simple structure\n| &&
      |    TYPES:\n| &&
      |      "! This is a simple structure\n| &&
      |      BEGIN OF my_structure,\n| &&
      |        "! This is the first element\n| &&
      |        my_first_element  TYPE mystring,\n| &&
      |      END OF my_structure.| ).

    cl_abap_unit_assert=>assert_equals(
      act = dump_tokens( tokens )
      exp = |str:* simple structure,row:1,col:0\n| &&
            |str:"! This is a simple structure,row:3,col:6\n| &&
            |str:TYPES,row:2,col:4\n| &&
            |str:BEGIN,row:4,col:6\n| &&
            |str:OF,row:4,col:12\n| &&
            |str:MY_STRUCTURE,row:4,col:15\n| &&
            |str:"! This is the first element,row:5,col:8\n| &&
            |str:TYPES,row:2,col:4\n| &&
            |str:MY_FIRST_ELEMENT,row:6,col:8\n| &&
            |str:TYPE,row:6,col:26\n| &&
            |str:MYSTRING,row:6,col:31\n| &&
            |str:TYPES,row:2,col:4\n| &&
            |str:END,row:7,col:6\n| &&
            |str:OF,row:7,col:10\n| &&
            |str:MY_STRUCTURE,row:7,col:13| ).

* from:1,to:1
* from:2,to:2
* from:3,to:6
* from:7,to:7
* from:8,to:11
* from:12,to:15

  ENDMETHOD.

ENDCLASS.