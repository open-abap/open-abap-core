CLASS cx_sy_open_sql_error DEFINITION PUBLIC INHERITING FROM cx_sy_sql_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_open_sql_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( sqlmsg = sqlmsg ).
  ENDMETHOD.
ENDCLASS.