CLASS cl_abap_matcher DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        pattern TYPE clike
        ignore_case TYPE abap_bool
        text TYPE clike.

    METHODS find_all
      RETURNING
        VALUE(rt_matches) TYPE match_result_tab.

    METHODS find_next
      RETURNING
        VALUE(found) TYPE abap_bool.

    METHODS get_submatch
      IMPORTING
        index TYPE i
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

  PRIVATE SECTION.
    DATA mt_matches TYPE match_result_tab.
    DATA mv_index TYPE i.
    DATA mv_text TYPE string.
    DATA mv_pattern TYPE string.

ENDCLASS.

CLASS cl_abap_matcher IMPLEMENTATION.

  METHOD constructor.
    IF ignore_case = abap_true.
      FIND ALL OCCURRENCES OF REGEX pattern IN text RESULTS mt_matches IGNORING CASE.
    ELSE.
      FIND ALL OCCURRENCES OF REGEX pattern IN text RESULTS mt_matches.
    ENDIF.
    mv_pattern = pattern.
    mv_text = text.
  ENDMETHOD.

  METHOD match.
    FIND ALL OCCURRENCES OF REGEX |^{ mv_pattern }$| IN mv_text.
    success = boolc( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD find_all.
    rt_matches = mt_matches.
  ENDMETHOD.

  METHOD find_next.
    mv_index = mv_index + 1.
    READ TABLE mt_matches INDEX mv_index TRANSPORTING NO FIELDS.
    found = boolc( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD get_submatch.
    DATA ls_match LIKE LINE OF mt_matches.
    DATA ls_submatch LIKE LINE OF ls_match-submatches.
    READ TABLE mt_matches INDEX mv_index INTO ls_match.
    READ TABLE ls_match-submatches INDEX index INTO ls_submatch.
    IF sy-subrc = 0.
      match = mv_text+ls_submatch-offset(ls_submatch-length).
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

ENDCLASS.