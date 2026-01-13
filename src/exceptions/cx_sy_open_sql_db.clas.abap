CLASS cx_sy_open_sql_db DEFINITION PUBLIC INHERITING FROM cx_sy_open_sql_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_open_sql_db IMPLEMENTATION.
  METHOD constructor.
    super->constructor( sqlmsg = sqlmsg ).
  ENDMETHOD.
ENDCLASS.