CLASS cl_abap_regex DEFINITION PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        pattern     TYPE clike
        ignore_case TYPE abap_bool.

    METHODS create_matcher
      IMPORTING
        text TYPE clike
      RETURNING
        VALUE(ro_matcher) TYPE REF TO cl_abap_matcher.

  PRIVATE SECTION.
    DATA mv_pattern TYPE string.
    DATA mv_ignore_case TYPE abap_bool.

ENDCLASS.

CLASS cl_abap_regex IMPLEMENTATION.

  METHOD constructor.
    mv_pattern = pattern.
    mv_ignore_case = ignore_case.
  ENDMETHOD.

  METHOD create_matcher.
    CREATE OBJECT ro_matcher
      EXPORTING
        pattern     = mv_pattern
        ignore_case = mv_ignore_case
        text        = text.
  ENDMETHOD.

ENDCLASS.