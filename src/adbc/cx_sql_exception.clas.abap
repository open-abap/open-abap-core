CLASS cx_sql_exception DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA sql_message TYPE string.
    DATA sql_code TYPE i.
    DATA db_error TYPE flag.
    DATA internal_error TYPE sy-subrc.

    METHODS constructor
      IMPORTING
        textid      LIKE textid OPTIONAL
        sql_message TYPE string OPTIONAL
        sql_code    TYPE i OPTIONAL
        db_error    TYPE flag OPTIONAL
        previous    TYPE REF TO cx_root OPTIONAL.
ENDCLASS.

CLASS cx_sql_exception IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).

    me->sql_message = sql_message.
    me->db_error = db_error.
    me->sql_code = sql_code.
  ENDMETHOD.

ENDCLASS.