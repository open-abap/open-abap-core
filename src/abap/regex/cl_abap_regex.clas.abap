CLASS cl_abap_regex DEFINITION PUBLIC.

  PUBLIC SECTION.
    DATA pattern TYPE string READ-ONLY.

* the runtime reads the mv_ variables when a regex object is used in FIND and REPLACE
    DATA mv_pattern     TYPE string. " TODO: remove this variable
    DATA mv_ignore_case TYPE abap_bool. " TODO: fix this variable, its not supposed to be there
    DATA mv_multiline   TYPE abap_bool.
    DATA mv_dot_all     TYPE abap_bool.
    DATA mv_extended    TYPE abap_bool.
    DATA mv_pcre        TYPE abap_bool.

    METHODS constructor
      IMPORTING
        pattern     TYPE clike
        ignore_case TYPE abap_bool DEFAULT abap_false.

    METHODS create_matcher
      IMPORTING
        text              TYPE clike OPTIONAL
        table             TYPE STANDARD TABLE OPTIONAL
      RETURNING
        VALUE(ro_matcher) TYPE REF TO cl_abap_matcher.

    CLASS-METHODS create_pcre
      IMPORTING
        pattern          TYPE clike
        ignore_case      TYPE abap_bool DEFAULT abap_false
        enable_jit       TYPE abap_bool DEFAULT abap_true
        enable_multiline TYPE abap_bool DEFAULT abap_false
        no_submatches    TYPE abap_bool DEFAULT abap_false
        extended         TYPE abap_bool DEFAULT abap_true
        dot_all          TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(regex)     TYPE REF TO cl_abap_regex
      RAISING
        cx_sy_regex.

  PRIVATE SECTION.

ENDCLASS.

CLASS cl_abap_regex IMPLEMENTATION.

  METHOD constructor.
    mv_pattern = pattern.
    me->pattern = pattern.
    mv_ignore_case = ignore_case.
  ENDMETHOD.

  METHOD create_pcre.
    DATA lv_valid TYPE abap_bool.
* matching runs on JavaScript regular expressions, so a pattern they cannot compile is rejected here
    lv_valid = abap_true.
    WRITE '@KERNEL try { new RegExp(typeof pattern === "string" ? pattern : pattern.get()); } catch (e) { lv_valid.set(""); }'.
    IF lv_valid = abap_false.
      RAISE EXCEPTION TYPE cx_sy_invalid_regex.
    ENDIF.

    CREATE OBJECT regex
      EXPORTING
        pattern     = pattern
        ignore_case = ignore_case.
    regex->mv_multiline = enable_multiline.
    regex->mv_dot_all = dot_all.
    regex->mv_extended = extended.
    regex->mv_pcre = abap_true.
  ENDMETHOD.

  METHOD create_matcher.
    " this is a todo,
    ASSERT table IS INITIAL.

    CREATE OBJECT ro_matcher
      EXPORTING
        pattern     = mv_pattern
        ignore_case = mv_ignore_case
        text        = text
        regex       = me.
  ENDMETHOD.

ENDCLASS.
