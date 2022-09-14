CLASS cx_sy_sql_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    DATA sqlmsg TYPE string.

    METHODS constructor
      IMPORTING
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_sql_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->sqlmsg = sqlmsg.
  ENDMETHOD.
ENDCLASS.