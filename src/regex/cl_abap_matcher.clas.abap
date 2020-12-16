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

  PRIVATE SECTION.
    DATA mv_pattern TYPE string.
    DATA mv_text TYPE string.
    DATA mv_ignore_case TYPE abap_bool.

ENDCLASS.

CLASS cl_abap_matcher IMPLEMENTATION.

  METHOD constructor.
    mv_pattern = pattern.
    mv_text = text.
    mv_ignore_case = ignore_case.
  ENDMETHOD.

  METHOD find_all.

    IF mv_ignore_case = abap_true.
      FIND ALL OCCURRENCES OF REGEX mv_pattern IN mv_text RESULTS rt_matches IGNORING CASE.
    ELSE.
      FIND ALL OCCURRENCES OF REGEX mv_pattern IN mv_text RESULTS rt_matches.
    ENDIF.

  ENDMETHOD.

ENDCLASS.