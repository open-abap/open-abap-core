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
    DATA source    TYPE string.
    DATA character TYPE c LENGTH 1.
    DATA row       TYPE i VALUE 1.
    DATA column    TYPE i.
    FIELD-SYMBOLS <tokens>     TYPE ty_stokesx.
    FIELD-SYMBOLS <statements> TYPE ty_sstmnt.
    FIELD-SYMBOLS <trow>       LIKE LINE OF <tokens>.
    FIELD-SYMBOLS <srow>       LIKE LINE OF <statements>.

    WRITE '@KERNEL source.set(INPUT.scan_abap_source.array ? INPUT.scan_abap_source.array().map(e => e.get()).join("\n") : INPUT.scan_abap_source.get());'.
    WRITE '@KERNEL fs_tokens_.assign(INPUT.tokens_into);'.
    WRITE '@KERNEL fs_statements_.assign(INPUT.statements_into);'.

    WHILE source IS NOT INITIAL.
      character = source(1).

      IF <trow> IS NOT ASSIGNED AND character IS NOT INITIAL AND character <> |\n|.
        APPEND INITIAL LINE TO <tokens> ASSIGNING <trow>.
        <trow>-row = row.
        <trow>-col = column.
      ELSEIF character = '' OR character CA |.,|.
        UNASSIGN <trow>.
      ENDIF.

      IF character CA |.,|.
        APPEND INITIAL LINE TO <statements> ASSIGNING <srow>.
        <srow>-terminator = character.
        <srow>-type = 'K'.
      ENDIF.

      IF character = |\n|.
        UNASSIGN <trow>.
        row = row + 1.
        column = 0.
      ELSE.
        IF <trow> IS ASSIGNED.
          <trow>-str = <trow>-str && to_upper( character ).
        ENDIF.
        column = column + 1.
      ENDIF.

      source = source+1.
    ENDWHILE.

  ENDMETHOD.

ENDCLASS.