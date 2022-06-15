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
ENDCLASS.

CLASS kernel_scan_abap_source IMPLEMENTATION.

  METHOD call.
    CONSTANTS: BEGIN OF c_mode,
                 normal  TYPE i VALUE 1,
                 comment TYPE i VALUE 2,
               END OF c_mode.
    DATA source    TYPE string.
    DATA character TYPE c LENGTH 1.
    DATA row       TYPE i VALUE 1.
    DATA column    TYPE i.
    DATA mode      TYPE i.

    FIELD-SYMBOLS <tokens>     TYPE ty_stokesx.
    FIELD-SYMBOLS <statements> TYPE ty_sstmnt.
    FIELD-SYMBOLS <trow>       LIKE LINE OF <tokens>.
    FIELD-SYMBOLS <srow>       LIKE LINE OF <statements>.

    WRITE '@KERNEL source.set(INPUT.scan_abap_source.array ? INPUT.scan_abap_source.array().map(e => e.get()).join("\n") : INPUT.scan_abap_source.get());'.
    WRITE '@KERNEL fs_tokens_.assign(INPUT.tokens_into);'.
    WRITE '@KERNEL fs_statements_.assign(INPUT.statements_into);'.

    mode = c_mode-normal.
    WHILE source IS NOT INITIAL.
      character = source(1).
      source = source+1.

      IF <trow> IS NOT ASSIGNED AND character <> '' AND character <> |\n|.
        APPEND INITIAL LINE TO <tokens> ASSIGNING <trow>.
        <trow>-row = row.
        <trow>-col = column.
      ELSEIF mode = c_mode-normal AND ( character = '' OR character CA |.,| ).
        UNASSIGN <trow>.
      ENDIF.

      IF ( mode = c_mode-normal AND character CA |.,| )
          OR ( mode = c_mode-comment AND character = |\n| )
          OR source = ''.
        APPEND INITIAL LINE TO <statements> ASSIGNING <srow>.
        <srow>-terminator = character.
        <srow>-to = lines( <statements> ).
        IF mode = c_mode-comment.
          <srow>-type = gc_statement-comment.
        ELSE.
          <srow>-type = gc_statement-standard.
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
          ENDIF.
          IF mode = c_mode-comment.
            <trow>-str = <trow>-str && |{ character }|.
          ELSE.
            <trow>-str = <trow>-str && to_upper( |{ character }| ).
          ENDIF.
        ENDIF.
        column = column + 1.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.

ENDCLASS.