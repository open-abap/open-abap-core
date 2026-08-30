CLASS cx_sy_native_sql_error DEFINITION PUBLIC INHERITING FROM cx_sy_sql_error.
  PUBLIC SECTION.
    DATA sqlcode TYPE i.

    METHODS constructor
      IMPORTING
        textid  LIKE textid OPTIONAL
        sqlmsg  TYPE string OPTIONAL
        sqlcode TYPE i OPTIONAL.
ENDCLASS.

CLASS cx_sy_native_sql_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid = textid
      sqlmsg = sqlmsg ).
    me->sqlcode = sqlcode.
  ENDMETHOD.
ENDCLASS.
