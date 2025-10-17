CLASS cl_abap_regex DEFINITION PUBLIC.

  PUBLIC SECTION.
    DATA pattern TYPE string READ-ONLY.

    DATA mv_pattern     TYPE string. " TODO: remove this variable
    DATA mv_ignore_case TYPE abap_bool. " TODO: fix this variable, its not supposed to be there

    METHODS constructor
      IMPORTING
        pattern     TYPE clike
        ignore_case TYPE abap_bool DEFAULT abap_false.

    METHODS create_matcher
      IMPORTING
        text              TYPE clike
      RETURNING
        VALUE(ro_matcher) TYPE REF TO cl_abap_matcher.

    CLASS-METHODS create_pcre
      IMPORTING
        pattern      TYPE clike
        ignore_case  TYPE abap_bool DEFAULT abap_false
        extended     TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(regex) TYPE REF TO cl_abap_regex.

  PRIVATE SECTION.

ENDCLASS.

CLASS cl_abap_regex IMPLEMENTATION.

  METHOD constructor.
    mv_pattern = pattern.
    me->pattern = pattern.
    mv_ignore_case = ignore_case.
  ENDMETHOD.

  METHOD create_pcre.
    CREATE OBJECT regex
      EXPORTING
        pattern     = pattern
        ignore_case = ignore_case.
  ENDMETHOD.

  METHOD create_matcher.
    CREATE OBJECT ro_matcher
      EXPORTING
        pattern     = mv_pattern
        ignore_case = mv_ignore_case
        text        = text.
  ENDMETHOD.

ENDCLASS.