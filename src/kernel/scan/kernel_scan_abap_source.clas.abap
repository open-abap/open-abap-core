CLASS kernel_scan_abap_source DEFINITION PUBLIC.
* handling of ABAP statement SCAN ABAP-SOURCE
  PUBLIC SECTION.
    CLASS-METHODS call IMPORTING input TYPE any.
    TYPES ty_stokesx TYPE STANDARD TABLE OF stokesx WITH DEFAULT KEY.
    TYPES ty_sstmnt TYPE STANDARD TABLE OF sstmnt WITH DEFAULT KEY.
  PRIVATE SECTION.
    CONSTANTS: BEGIN OF gc_token,
                 comment    TYPE c LENGTH 1 VALUE 'C',
                 identifier TYPE c LENGTH 1 VALUE 'I',
                 list       TYPE c LENGTH 1 VALUE 'L',
                 literal    TYPE c LENGTH 1 VALUE 'S',
                 pragma     TYPE c LENGTH 1 VALUE 'P',
               END OF gc_token.

    CONSTANTS: BEGIN OF gc_statement,
                 comment          TYPE c LENGTH 1 VALUE 'P',
                 comment_in_stmnt TYPE c LENGTH 1 VALUE 'S',
                 compute_direct   TYPE c LENGTH 1 VALUE 'C',
                 empty            TYPE c LENGTH 1 VALUE 'N',
                 macro_call       TYPE c LENGTH 1 VALUE 'D',
                 macro_definition TYPE c LENGTH 1 VALUE 'M',
                 method_direct    TYPE c LENGTH 1 VALUE 'A',
                 native_sql       TYPE c LENGTH 1 VALUE 'E',
                 pragma           TYPE c LENGTH 1 VALUE 'G',
                 standard         TYPE c LENGTH 1 VALUE 'K',
               END OF gc_statement.

    CLASS-METHODS pass1
      IMPORTING
        source        TYPE string
      EXPORTING
        et_tokens     TYPE ty_stokesx
        et_statements TYPE ty_sstmnt.

    CLASS-METHODS pass2
      CHANGING
        ct_tokens     TYPE ty_stokesx
        ct_statements TYPE ty_sstmnt.
ENDCLASS.

CLASS kernel_scan_abap_source IMPLEMENTATION.

  METHOD call.

    DATA source TYPE string.
    FIELD-SYMBOLS <tokens>     TYPE ty_stokesx.
    FIELD-SYMBOLS <statements> TYPE ty_sstmnt.

    WRITE '@KERNEL source.set(INPUT.scan_abap_source.array ? INPUT.scan_abap_source.array().map(e => e.get()).join("\n") : INPUT.scan_abap_source.get());'.
    WRITE '@KERNEL fs_tokens_.assign(INPUT.tokens_into);'.
    WRITE '@KERNEL fs_statements_.assign(INPUT.statements_into);'.

* non-goal: good performance

* build tokens in sequence of occurence in the source
* take care of chained statements
    pass1(
      EXPORTING
        source        = source
      IMPORTING
        et_tokens     = <tokens>
        et_statements = <statements> ).

* move comment tokens and add/change statements to comment type
    pass2(
      CHANGING
        ct_tokens     = <tokens>
        ct_statements = <statements> ).

  ENDMETHOD.

  METHOD pass1.
    CONSTANTS: BEGIN OF c_mode,
                 normal  TYPE i VALUE 1,
                 comment TYPE i VALUE 2,
               END OF c_mode.

    DATA character    TYPE c LENGTH 1.
    DATA row          TYPE i VALUE 1.
    DATA column       TYPE i.
    DATA index        TYPE i.
    DATA sfrom        TYPE i VALUE 1.
    DATA mode         TYPE i.
    DATA chain_tokens TYPE ty_stokesx.

    FIELD-SYMBOLS <trow> LIKE LINE OF et_tokens.
    FIELD-SYMBOLS <srow> LIKE LINE OF et_statements.

    mode = c_mode-normal.
    WHILE source IS NOT INITIAL.
      character = source(1).
      source = source+1.

      IF <trow> IS NOT ASSIGNED AND character <> '' AND character <> |\n|.
        APPEND INITIAL LINE TO et_tokens ASSIGNING <trow>.
        <trow>-row = row.
        <trow>-col = column.
        <trow>-type = gc_token-identifier.
      ELSEIF mode = c_mode-normal AND ( character = '' OR character CA |.,| ).
        UNASSIGN <trow>.
"         IF character = ','.
" *          WRITE '@KERNEL console.dir("before");'.
"           APPEND LINES OF chain_tokens TO et_tokens.
" *          WRITE '@KERNEL console.dir("after");'.
" *          WRITE lines( <tokens> ).
"         ENDIF.
      ELSEIF mode = c_mode-normal AND character = ':'.
        CLEAR chain_tokens.
        APPEND LINES OF et_tokens FROM sfrom TO chain_tokens.
        DELETE chain_tokens WHERE type = gc_token-comment.
*        WRITE '@KERNEL console.dir(chain_tokens);'.
      ENDIF.

      IF ( mode = c_mode-normal AND character CA |.,| )
          OR source = ''.
        APPEND INITIAL LINE TO et_statements ASSIGNING <srow>.
        <srow>-terminator = character.
        <srow>-from = sfrom.
        <srow>-to = lines( et_tokens ).
        sfrom = <srow>-to + 1.

        IF character = ','.
*          WRITE '@KERNEL console.dir("before");'.
          APPEND LINES OF chain_tokens TO et_tokens.
*          WRITE '@KERNEL console.dir("after");'.
*          WRITE lines( <tokens> ).
        ENDIF.
      ENDIF.

      IF character = |\n|.
        mode = c_mode-normal.
        UNASSIGN <trow>.
        row = row + 1.
        column = 0.
      ELSE.
        IF <trow> IS ASSIGNED.
          IF ( character = '*' AND column = 0 ) OR character = '"'.
            mode = c_mode-comment.
            <trow>-type = gc_token-comment.
          ENDIF.
          IF mode = c_mode-comment.
            <trow>-type = gc_token-comment.
            <trow>-str = <trow>-str && |{ character }|.
          ELSEIF character <> ':'.
            <trow>-str = <trow>-str && to_upper( |{ character }| ).
          ENDIF.
        ENDIF.
        column = column + 1.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.

  METHOD pass2.
    FIELD-SYMBOLS <ls_statement> LIKE LINE OF ct_statements.
    DATA ls_statement       LIKE LINE OF ct_statements.
    DATA ls_token           LIKE LINE OF ct_tokens.
    DATA contains_comment   TYPE abap_bool.
    DATA contains_normal    TYPE abap_bool.
    DATA lv_count           TYPE i.
    DATA lv_statement_index TYPE i.
    DATA lt_insert          LIKE ct_tokens.

    LOOP AT ct_statements ASSIGNING <ls_statement>.
      lv_statement_index = sy-tabix.

*      WRITE '@KERNEL console.dir("statement");'.
      contains_comment = abap_false.
      contains_normal = abap_false.
      LOOP AT ct_tokens INTO ls_token FROM <ls_statement>-from TO <ls_statement>-to.
        IF ls_token-type = gc_token-comment.
          contains_comment = abap_true.
        ELSE.
          contains_normal = abap_true.
        ENDIF.
*        WRITE '@KERNEL console.dir(ls_token.get().str.get());'.
      ENDLOOP.

      IF contains_comment = abap_true AND contains_normal = abap_true.
* its a mix, move comments to the front as separate statement
*        WRITE '@KERNEL console.dir("from: " + fs_ls_statement_.get().from.get());'.
*        WRITE '@KERNEL console.dir("to: " + fs_ls_statement_.get().to.get());'.
        lv_count = 0.
        CLEAR lt_insert.
        LOOP AT ct_tokens INTO ls_token FROM <ls_statement>-from TO <ls_statement>-to WHERE type = gc_token-comment.
          DELETE ct_tokens INDEX sy-tabix.
          INSERT ls_token INTO TABLE lt_insert INDEX 1.
          lv_count = lv_count + 1.
        ENDLOOP.
        LOOP AT lt_insert INTO ls_token.
          INSERT ls_token INTO TABLE ct_tokens INDEX <ls_statement>-from.
        ENDLOOP.
        CLEAR ls_statement.
        ls_statement-from = <ls_statement>-from.
        ls_statement-to = <ls_statement>-from + lv_count - 1.
        ls_statement-type = gc_statement-comment.

        <ls_statement>-from = <ls_statement>-from + lv_count.

        INSERT ls_statement INTO TABLE ct_statements INDEX lv_statement_index.
      ELSEIF contains_comment = abap_true.
        <ls_statement>-type = gc_statement-comment.
      ELSE.
        <ls_statement>-type = gc_statement-standard.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.