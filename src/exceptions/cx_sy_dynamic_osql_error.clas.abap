CLASS cx_sy_dynamic_osql_error DEFINITION PUBLIC INHERITING FROM cx_sy_open_sql_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid LIKE textid OPTIONAL
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_dynamic_osql_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      textid = textid
      sqlmsg = sqlmsg ).
  ENDMETHOD.
ENDCLASS.