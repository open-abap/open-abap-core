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

    METHODS get_length
      RETURNING 
        VALUE(length) TYPE i.

  PRIVATE SECTION.
    DATA mt_matches TYPE match_result_tab.
    DATA mv_index TYPE i.

ENDCLASS.

CLASS cl_abap_matcher IMPLEMENTATION.

  METHOD constructor.
    IF ignore_case = abap_true.
      FIND ALL OCCURRENCES OF REGEX pattern IN text RESULTS mt_matches IGNORING CASE.
    ELSE.
      FIND ALL OCCURRENCES OF REGEX pattern IN text RESULTS mt_matches.
    ENDIF.
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
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_offset.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_length.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.