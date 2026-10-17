CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS text_initial FOR TESTING RAISING cx_static_check.
    METHODS get_match FOR TESTING RAISING cx_static_check.
    METHODS get_match_without_find FOR TESTING RAISING cx_static_check.
    METHODS replace_all FOR TESTING RAISING cx_static_check.
    METHODS replace_all_submatch FOR TESTING RAISING cx_static_check.
    METHODS replace_all_escape FOR TESTING RAISING cx_static_check.
    METHODS replace_next FOR TESTING RAISING cx_static_check.
    METHODS replace_next_twice FOR TESTING RAISING cx_static_check.
    METHODS replace_next_none FOR TESTING RAISING cx_static_check.
    METHODS replace_next_empty_match FOR TESTING RAISING cx_static_check.
    METHODS replace_next_from_resume FOR TESTING RAISING cx_static_check.
    METHODS replace_next_submatch FOR TESTING RAISING cx_static_check.
    METHODS match_whole_text FOR TESTING RAISING cx_static_check.
    METHODS match_ignore_case FOR TESTING RAISING cx_static_check.
    METHODS match_line_only FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD text_initial.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( 'b' )->create_matcher( text = 'abc' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'abc' ).
  ENDMETHOD.

  METHOD get_match.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    DATA ls_match   TYPE match_result.
    lo_matcher = cl_abap_regex=>create_pcre( 'b+' )->create_matcher( text = 'abbcb' ).
    lo_matcher->find_next( ).
    ls_match = lo_matcher->get_match( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_match-offset
      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_match-length
      exp = 2 ).
    lo_matcher->find_next( ).
    ls_match = lo_matcher->get_match( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_match-offset
      exp = 4 ).
  ENDMETHOD.

  METHOD get_match_without_find.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( 'b' )->create_matcher( text = 'abc' ).
    TRY.
        lo_matcher->get_match( ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_matcher.
    ENDTRY.
  ENDMETHOD.

  METHOD replace_all.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    DATA lv_count   TYPE i.
    lo_matcher = cl_abap_regex=>create_pcre( 'o' )->create_matcher( text = 'foo boo' ).
    lv_count = lo_matcher->replace_all( '0' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_count
      exp = 4 ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'f00 b00' ).
  ENDMETHOD.

  METHOD replace_all_submatch.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( '(\w+)@(\w+)' )->create_matcher( text = 'joe@home, ann@work' ).
    lo_matcher->replace_all( '$2:$1' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'home:joe, work:ann' ).
  ENDMETHOD.

  METHOD replace_all_escape.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( '[.]' )->create_matcher( text = 'a.b' ).
    lo_matcher->replace_all( '\\$0' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'a\.b' ).
  ENDMETHOD.

  METHOD replace_next.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( 'o' )->create_matcher( text = 'foo' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->replace_next( 'O' )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'fOo' ).
  ENDMETHOD.

  METHOD replace_next_twice.
* the search goes on behind the replacement, even when the replacement matches again
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( 'o' )->create_matcher( text = 'foo' ).
    lo_matcher->replace_next( 'oo' ).
    lo_matcher->replace_next( 'X' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'fooX' ).
  ENDMETHOD.

  METHOD replace_next_none.
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( 'x' )->create_matcher( text = 'foo' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->replace_next( 'X' )
      exp = abap_false ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'foo' ).
  ENDMETHOD.

  METHOD replace_next_empty_match.
* behind an empty match the search moves one character forward, so the loop ends
* and gives the same text as replace_all
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    DATA lo_all     TYPE REF TO cl_abap_matcher.
    DATA lv_count   TYPE i.
    lo_matcher = cl_abap_regex=>create_pcre( 'b*' )->create_matcher( text = 'abc' ).
    WHILE lo_matcher->replace_next( '-' ) = abap_true.
      lv_count = lv_count + 1.
      IF lv_count > 10.
        cl_abap_unit_assert=>fail( 'replace_next does not stop' ).
      ENDIF.
    ENDWHILE.
    lo_all = cl_abap_regex=>create_pcre( 'b*' )->create_matcher( text = 'abc' ).
    lo_all->replace_all( '-' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = lo_all->text ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_count
      exp = 4 ).
  ENDMETHOD.

  METHOD replace_next_from_resume.
* the next match is searched from behind the replacement, a match starting before it does not hide it
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( 'o|y|xy' )->create_matcher( text = 'oy' ).
    lo_matcher->replace_next( 'x' ).
    lo_matcher->replace_next( 'Y' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = 'xY' ).
  ENDMETHOD.

  METHOD replace_next_submatch.
* offsets of the matches behind the resume point count from the start of the text
    DATA lo_matcher TYPE REF TO cl_abap_matcher.
    lo_matcher = cl_abap_regex=>create_pcre( '(\w)(\d)' )->create_matcher( text = 'a1 b2' ).
    lo_matcher->replace_next( '$2$1' ).
    lo_matcher->replace_next( '$2$1' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_matcher->text
      exp = '1a 2b' ).
  ENDMETHOD.

  METHOD match_whole_text.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_regex=>create_pcre( 'a|ab' )->create_matcher( text = 'ab' )->match( )
      exp = abap_true ).
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_regex=>create_pcre( 'a' )->create_matcher( text = 'ab' )->match( )
      exp = abap_false ).
  ENDMETHOD.

  METHOD match_ignore_case.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_regex=>create_pcre( pattern     = 'abc'
                                        ignore_case = abap_true )->create_matcher( text = 'ABC' )->match( )
      exp = abap_true ).
  ENDMETHOD.

  METHOD match_line_only.
* one line of the text matching is not a match of the text
    DATA lv_text TYPE string.
    lv_text = |a\nb|.
    cl_abap_unit_assert=>assert_equals(
      act = cl_abap_regex=>create_pcre( 'a' )->create_matcher( text = lv_text )->match( )
      exp = abap_false ).
  ENDMETHOD.

ENDCLASS.
