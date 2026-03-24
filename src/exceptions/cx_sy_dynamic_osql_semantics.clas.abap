CLASS cx_sy_dynamic_osql_semantics DEFINITION PUBLIC INHERITING FROM cx_sy_dynamic_osql_error.
  PUBLIC SECTION.

  CONSTANTS unknown_table_name TYPE sotr_conc VALUE '11111111111111111111111111111111'.

    METHODS constructor
      IMPORTING
        token TYPE string OPTIONAL
        sqlmsg TYPE string OPTIONAL.
ENDCLASS.

CLASS cx_sy_dynamic_osql_semantics IMPLEMENTATION.
  METHOD constructor.
    super->constructor( sqlmsg = sqlmsg ).
  ENDMETHOD.
ENDCLASS.