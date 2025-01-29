CLASS cx_sql_exception DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA sql_message TYPE string.

    METHODS constructor
      IMPORTING
        textid      LIKE textid OPTIONAL
        sql_message TYPE string OPTIONAL
        previous    TYPE REF TO cx_root OPTIONAL.
ENDCLASS.

CLASS cx_sql_exception IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).

    me->sql_message = sql_message.
  ENDMETHOD.

ENDCLASS.