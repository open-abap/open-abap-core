CLASS cl_abap_matcher DEFINITION PUBLIC.

  PUBLIC SECTION.
    DATA regex TYPE REF TO cl_abap_regex READ-ONLY.
    DATA text TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        pattern     TYPE clike
        ignore_case TYPE abap_bool
        text        TYPE clike
        regex       TYPE REF TO cl_abap_regex OPTIONAL.

    METHODS find_all
      RETURNING
        VALUE(rt_matches) TYPE match_result_tab.

    METHODS find_next
      RETURNING
        VALUE(found) TYPE abap_bool.

    METHODS get_match
      RETURNING
        VALUE(match) TYPE match_result
      RAISING
        cx_sy_matcher.

    METHODS get_submatch
      IMPORTING
        index        TYPE i
      RETURNING
        VALUE(match) TYPE string.

    METHODS get_offset
      RETURNING
        VALUE(offset) TYPE i.

    METHODS match
      RETURNING
        VALUE(success) TYPE abap_bool.

    METHODS get_length
      RETURNING
        VALUE(length) TYPE i.

    METHODS replace_all
      IMPORTING
        newtext      TYPE clike
      RETURNING
        VALUE(count) TYPE i
      RAISING
        cx_sy_matcher.

    METHODS replace_found
      IMPORTING
        newtext        TYPE clike
      RETURNING
        VALUE(success) TYPE abap_bool
      RAISING
        cx_sy_matcher.

    METHODS replace_next
      IMPORTING
        newtext        TYPE clike
      RETURNING
        VALUE(success) TYPE abap_bool
      RAISING
        cx_sy_matcher.

  PRIVATE SECTION.
    DATA mt_matches TYPE match_result_tab.
    DATA mv_index TYPE i.
    DATA mv_pattern TYPE string.
    DATA mv_ignore_case TYPE abap_bool.

    METHODS scan
      IMPORTING
        iv_offset TYPE i DEFAULT 0.
    METHODS expand
      IMPORTING
        iv_newtext     TYPE clike
        is_match       TYPE match_result
      RETURNING
        VALUE(rv_text) TYPE string.

ENDCLASS.

CLASS cl_abap_matcher IMPLEMENTATION.

  METHOD constructor.
    mv_pattern = pattern.
    mv_ignore_case = ignore_case.
    me->text = text.
    me->regex = regex.
    scan( ).
  ENDMETHOD.

  METHOD scan.
* searches from iv_offset on, the offsets of the matches count from the start of the text
    DATA lv_rest  TYPE string.
    DATA ls_match LIKE LINE OF mt_matches.
    FIELD-SYMBOLS <ls_match> LIKE LINE OF mt_matches.
    FIELD-SYMBOLS <ls_sub> LIKE LINE OF ls_match-submatches.

    CLEAR mt_matches.
    CLEAR mv_index.
    IF iv_offset > strlen( text ).
      RETURN.
    ENDIF.
    lv_rest = text+iv_offset.

    IF regex IS BOUND.
      FIND ALL OCCURRENCES OF REGEX regex IN lv_rest RESULTS mt_matches.
    ELSEIF mv_ignore_case = abap_true.
      FIND ALL OCCURRENCES OF REGEX mv_pattern IN lv_rest RESULTS mt_matches IGNORING CASE.
    ELSE.
      FIND ALL OCCURRENCES OF REGEX mv_pattern IN lv_rest RESULTS mt_matches.
    ENDIF.

    IF iv_offset > 0.
      LOOP AT mt_matches ASSIGNING <ls_match>.
        <ls_match>-offset = <ls_match>-offset + iv_offset.
        LOOP AT <ls_match>-submatches ASSIGNING <ls_sub> WHERE offset >= 0.
          <ls_sub>-offset = <ls_sub>-offset + iv_offset.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD match.
* the whole text must be one match, the anchors alone are not enough as the
* runtime matches them at every line break
    DATA lo_whole  TYPE REF TO cl_abap_regex.
    DATA lv_offset TYPE i.
    DATA lv_length TYPE i.

    IF regex IS BOUND.
      lo_whole = cl_abap_regex=>create_pcre(
        pattern          = |^(?:{ mv_pattern })$|
        ignore_case      = regex->mv_ignore_case
        enable_multiline = regex->mv_multiline
        dot_all          = regex->mv_dot_all
        extended         = regex->mv_extended ).
      FIND FIRST OCCURRENCE OF REGEX lo_whole IN text MATCH OFFSET lv_offset MATCH LENGTH lv_length.
    ELSEIF mv_ignore_case = abap_true.
      FIND FIRST OCCURRENCE OF REGEX |^(?:{ mv_pattern })$| IN text
        MATCH OFFSET lv_offset MATCH LENGTH lv_length IGNORING CASE.
    ELSE.
      FIND FIRST OCCURRENCE OF REGEX |^(?:{ mv_pattern })$| IN text
        MATCH OFFSET lv_offset MATCH LENGTH lv_length.
    ENDIF.
    success = boolc( sy-subrc = 0 AND lv_offset = 0 AND lv_length = strlen( text ) ).
  ENDMETHOD.

  METHOD find_all.
    rt_matches = mt_matches.
  ENDMETHOD.

  METHOD find_next.
    mv_index = mv_index + 1.
    READ TABLE mt_matches INDEX mv_index TRANSPORTING NO FIELDS.
    found = boolc( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD get_match.
    READ TABLE mt_matches INDEX mv_index INTO match.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_sy_no_current_match.
    ENDIF.
  ENDMETHOD.

  METHOD get_submatch.
    DATA ls_match LIKE LINE OF mt_matches.
    DATA ls_submatch LIKE LINE OF ls_match-submatches.
    READ TABLE mt_matches INDEX mv_index INTO ls_match.
    READ TABLE ls_match-submatches INDEX index INTO ls_submatch.
    IF sy-subrc = 0 AND ls_submatch-offset >= 0.
      match = text+ls_submatch-offset(ls_submatch-length).
    ENDIF.
  ENDMETHOD.

  METHOD get_offset.
    DATA ls_match LIKE LINE OF mt_matches.
    READ TABLE mt_matches INDEX mv_index INTO ls_match.
    offset = ls_match-offset.
  ENDMETHOD.

  METHOD get_length.
    DATA ls_match LIKE LINE OF mt_matches.
    READ TABLE mt_matches INDEX mv_index INTO ls_match.
    length = ls_match-length.
  ENDMETHOD.

  METHOD replace_all.
    DATA lv_result TYPE string.
    DATA lv_end    TYPE i.
    DATA lv_length TYPE i.
    DATA ls_match  LIKE LINE OF mt_matches.

    LOOP AT mt_matches INTO ls_match.
      lv_length = ls_match-offset - lv_end.
      lv_result = lv_result && text+lv_end(lv_length) && expand(
        iv_newtext = newtext
        is_match   = ls_match ).
      lv_end = ls_match-offset + ls_match-length.
    ENDLOOP.
    count = lines( mt_matches ).
    text = lv_result && text+lv_end.

    scan( ).
    mv_index = lines( mt_matches ).
  ENDMETHOD.

  METHOD replace_next.
    success = find_next( ).
    IF success = abap_true.
      replace_found( newtext ).
    ENDIF.
  ENDMETHOD.

  METHOD replace_found.
    DATA ls_match       LIKE LINE OF mt_matches.
    DATA lv_replacement TYPE string.
    DATA lv_continue    TYPE i.
    DATA lv_after       TYPE i.

    READ TABLE mt_matches INDEX mv_index INTO ls_match.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_sy_no_current_match.
    ENDIF.

    lv_replacement = expand( iv_newtext = newtext
                             is_match   = ls_match ).
    lv_after = ls_match-offset + ls_match-length.
    text = text+0(ls_match-offset) && lv_replacement && text+lv_after.

* the search goes on from behind the replacement, not from the start of the text. Behind an
* empty match it skips one character, else it finds the same empty match again
    lv_continue = ls_match-offset + strlen( lv_replacement ).
    IF ls_match-length = 0.
      lv_continue = lv_continue + 1.
    ENDIF.
    scan( lv_continue ).
    success = abap_true.
  ENDMETHOD.

  METHOD expand.
* $0 or $& is the match, $1 to $9 the submatches, a backslash takes the next character as it is
    DATA lv_position TYPE i.
    DATA lv_char     TYPE c LENGTH 1.
    DATA lv_next     TYPE c LENGTH 1.
    DATA lv_index    TYPE i.
    DATA ls_sub      LIKE LINE OF is_match-submatches.

    WHILE lv_position < strlen( iv_newtext ).
      lv_char = iv_newtext+lv_position(1).
      CLEAR lv_next.
      IF lv_position + 1 < strlen( iv_newtext ).
        lv_index = lv_position + 1.
        lv_next = iv_newtext+lv_index(1).
      ENDIF.

      IF lv_char = '\' AND lv_next IS NOT INITIAL.
        rv_text = rv_text && lv_next.
        lv_position = lv_position + 2.
      ELSEIF lv_char = '$' AND ( lv_next = '0' OR lv_next = '&' ).
        rv_text = rv_text && text+is_match-offset(is_match-length).
        lv_position = lv_position + 2.
      ELSEIF lv_char = '$' AND lv_next CA '123456789'.
        lv_index = lv_next.
        READ TABLE is_match-submatches INDEX lv_index INTO ls_sub.
        IF sy-subrc = 0 AND ls_sub-offset >= 0.
          rv_text = rv_text && text+ls_sub-offset(ls_sub-length).
        ENDIF.
        lv_position = lv_position + 2.
      ELSE.
        rv_text = rv_text && lv_char.
        lv_position = lv_position + 1.
      ENDIF.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
