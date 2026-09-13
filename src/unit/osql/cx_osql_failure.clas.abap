CLASS cx_osql_failure DEFINITION PUBLIC FINAL CREATE PUBLIC INHERITING FROM cx_no_check.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        reason   TYPE string OPTIONAL.

    METHODS if_message~get_text REDEFINITION.

    DATA reason TYPE string READ-ONLY.
ENDCLASS.

CLASS cx_osql_failure IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
    me->reason = reason.
  ENDMETHOD.

  METHOD if_message~get_text.
    result = reason.
  ENDMETHOD.

ENDCLASS.
