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

* build tokens in sequence of occurence in the source
* take care of chained statements
    pass1(
      EXPORTING
        source        = source
      IMPORTING
        et_tokens     = <tokens>
        et_statements = <statements> ).

* move comment tokens and add/change satements to comment type
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
      ELSEIF mode = c_mode-normal AND ( character = '' OR character CA |.,| ).
        UNASSIGN <trow>.
        IF character = ','.
*          WRITE '@KERNEL console.dir("before");'.
          APPEND LINES OF chain_tokens TO et_tokens.
*          WRITE '@KERNEL console.dir("after");'.
*          WRITE lines( <tokens> ).
        ENDIF.
      ELSEIF mode = c_mode-normal AND character = ':'.
        CLEAR chain_tokens.
        APPEND LINES OF et_tokens FROM sfrom TO chain_tokens.
*        WRITE '@KERNEL console.dir(chain_tokens);'.
      ENDIF.

      IF ( mode = c_mode-normal AND character CA |.,| )
          OR source = ''.
        APPEND INITIAL LINE TO et_statements ASSIGNING <srow>.
        <srow>-terminator = character.
        <srow>-from = sfrom.
        <srow>-to = lines( et_tokens ).
        sfrom = <srow>-to + 1.
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
          ENDIF.
          IF mode = c_mode-comment.
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
    RETURN.
  ENDMETHOD.

ENDCLASS.