CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS test01       FOR TESTING RAISING cx_static_check.
    METHODS match_true   FOR TESTING RAISING cx_static_check.
    METHODS match_false  FOR TESTING RAISING cx_static_check.
    METHODS no_next      FOR TESTING RAISING cx_static_check.
    METHODS tags         FOR TESTING RAISING cx_static_check.
    METHODS find_hello   FOR TESTING RAISING cx_static_check.
    METHODS pcre         FOR TESTING RAISING cx_static_check.
    METHODS replace_oo   FOR TESTING RAISING cx_static_check.
    METHODS pcre_slashes FOR TESTING RAISING cx_static_check.
    METHODS digits       FOR TESTING RAISING cx_static_check.
    METHODS classic_slashes FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    DATA lo_regex   TYPE REF TO cl_abap_regex.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    DATA lt_results TYPE match_result_tab.
    DATA ls_result  LIKE LINE OF lt_results.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern     = 'aa'
        ignore_case = abap_true.

    lo_matcher = lo_regex->create_matcher( text = 'fooaabar' ).
    lt_results = lo_matcher->find_all( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_results )
      exp = 1 ).

    READ TABLE lt_results INDEX 1 INTO ls_result.
    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-offset
      exp = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_result-length
      exp = 2 ).

  ENDMETHOD.

  METHOD no_next.

    DATA lo_regex TYPE REF TO cl_abap_regex.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern     = '1111'
        ignore_case = abap_true.

    lo_matcher = lo_regex->create_matcher( text = '2222' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->find_next( )
      exp = abap_false ).

  ENDMETHOD.

  METHOD match_false.

    DATA lo_regex TYPE REF TO cl_abap_regex.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern     = 'aa'
        ignore_case = abap_true.

    lo_matcher = lo_regex->create_matcher( text = 'fooaabar' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->match( )
      exp = abap_false ).

  ENDMETHOD.

  METHOD match_true.

    DATA lo_regex TYPE REF TO cl_abap_regex.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern     = 'aa'
        ignore_case = abap_true.

    lo_matcher = lo_regex->create_matcher( text = 'aa' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->match( )
      exp = abap_true ).

  ENDMETHOD.

  METHOD tags.

    DATA lv_line  TYPE string.
    DATA lv_count TYPE i.
    DATA lo_tags  TYPE REF TO cl_abap_regex.

    lv_line = '<td id="id">'.

    CREATE OBJECT lo_tags
      EXPORTING
        pattern     = '<(AREA|BASE|!)'
        ignore_case = abap_false.

    FIND ALL OCCURRENCES OF REGEX lo_tags IN lv_line MATCH COUNT lv_count.

    cl_abap_unit_assert=>assert_equals(
      act = lv_count
      exp = 0 ).

  ENDMETHOD.

  METHOD find_hello.

    DATA lv_line  TYPE string.
    DATA lv_count TYPE i.
    DATA lo_tags  TYPE REF TO cl_abap_regex.

    lv_line = 'hello'.

    CREATE OBJECT lo_tags
      EXPORTING
        pattern = 'hello'.

    FIND ALL OCCURRENCES OF REGEX lo_tags IN lv_line MATCH COUNT lv_count.

    cl_abap_unit_assert=>assert_equals(
      act = lv_count
      exp = 1 ).

  ENDMETHOD.

  METHOD pcre.

    DATA lo_regex TYPE REF TO cl_abap_regex.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.

    lo_regex = cl_abap_regex=>create_pcre(
      pattern     = 'aa'
      ignore_case = abap_true ).

    lo_matcher = lo_regex->create_matcher( text = 'fooaabar' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->match( )
      exp = abap_false ).

  ENDMETHOD.

  METHOD replace_oo.

    DATA lv_line  TYPE string.
    DATA lo_regex TYPE REF TO cl_abap_regex.

    lv_line = 'hello'.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern = 'hello'.

    REPLACE FIRST OCCURRENCE OF REGEX lo_regex IN lv_line WITH ``.

    cl_abap_unit_assert=>assert_equals(
      act = lv_line
      exp = '' ).

  ENDMETHOD.

  METHOD pcre_slashes.

    DATA lo_regex    TYPE REF TO cl_abap_regex.
    DATA lv_basepath TYPE string.

    lo_regex = cl_abap_regex=>create_pcre(
      pattern     = '^(.*)\/list$'
      ignore_case = abap_true ).

    FIND FIRST OCCURRENCE OF REGEX lo_regex IN 'core/api/List' SUBMATCHES lv_basepath.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_basepath
      exp = 'core/api' ).

  ENDMETHOD.

  METHOD classic_slashes.

    DATA lo_regex    TYPE REF TO cl_abap_regex.
    DATA lv_basepath TYPE string.

    CREATE OBJECT lo_regex
      EXPORTING
        pattern     = '^(.*)\/list$'
        ignore_case = abap_true.

    FIND FIRST OCCURRENCE OF REGEX lo_regex IN 'core/api/List' SUBMATCHES lv_basepath.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_basepath
      exp = 'core/api' ).

  ENDMETHOD.

  METHOD digits.

    DATA l_offset  TYPE i.
    DATA l_counter TYPE string.
    DATA name      TYPE string.
    DATA lo_regex  TYPE REF TO cl_abap_regex.

    name = 'notFound'.
    CREATE OBJECT lo_regex EXPORTING pattern = '([[:digit:]]*)$'.
    FIND FIRST OCCURRENCE OF REGEX lo_regex IN name SUBMATCHES l_counter MATCH OFFSET l_offset.

    cl_abap_unit_assert=>assert_equals(
      act = l_counter
      exp = '' ).

    cl_abap_unit_assert=>assert_equals(
      act = l_offset
      exp = 8 ).

  ENDMETHOD.

ENDCLASS.