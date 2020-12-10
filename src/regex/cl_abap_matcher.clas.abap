CLASS cl_abap_matcher DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        pattern TYPE clike
        text TYPE clike.

    METHODS find_all
      RETURNING
        VALUE(rt_matches) TYPE match_result_tab.

  PRIVATE SECTION.
    DATA mv_pattern TYPE string.
    DATA mv_text TYPE string.

ENDCLASS.

CLASS cl_abap_matcher IMPLEMENTATION.

  METHOD constructor.
    mv_pattern = pattern.
    mv_text = text.
  ENDMETHOD.

  METHOD find_all.

    FIND ALL OCCURRENCES OF REGEX mv_pattern IN mv_text RESULTS rt_matches.

  ENDMETHOD.

ENDCLASS.