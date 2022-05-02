CLASS kernel_scan_abap_source DEFINITION PUBLIC.
* handling of ABAP statement SCAN ABAP-SOURCE
  PUBLIC SECTION.
    CLASS-METHODS call IMPORTING input TYPE any.
ENDCLASS.

CLASS kernel_scan_abap_source IMPLEMENTATION.

  METHOD call.
    DATA source TYPE string.
    FIELD-SYMBOLS <tokens> TYPE STANDARD TABLE OF stokesx WITH DEFAULT KEY.
    FIELD-SYMBOLS <statements> TYPE STANDARD TABLE OF sstmnt WITH DEFAULT KEY.

    WRITE '@KERNEL source.set(INPUT.scan_abap_source.array().map(e => e.get()).join("\n"));'.
    WRITE '@KERNEL fs_tokens_.assign(INPUT.tokens_into);'.
    WRITE '@KERNEL fs_statements_.assign(INPUT.statements_into);'.

    APPEND INITIAL LINE TO <statements>.
    APPEND INITIAL LINE TO <tokens>.
    APPEND INITIAL LINE TO <tokens>.

*    WRITE '@KERNEL console.dir(INPUT.with_analysis);'.
*    WRITE '@KERNEL console.dir(INPUT.with_comments);'.
*    WRITE '@KERNEL console.dir(INPUT.with_pragmas);'.
  ENDMETHOD.

ENDCLASS.