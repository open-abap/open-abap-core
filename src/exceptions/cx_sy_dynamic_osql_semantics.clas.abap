CLASS cx_sy_dynamic_osql_semantics DEFINITION PUBLIC INHERITING FROM cx_sy_dynamic_osql_error.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_dynamic_osql_semantics IMPLEMENTATION.
  METHOD constructor.
    super->constructor( sqlmsg = sqlmsg ).
  ENDMETHOD.
ENDCLASS.