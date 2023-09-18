CLASS ltcl_sql_statement DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PUBLIC SECTION.
    METHODS bad_syntax_throws FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_sql_statement IMPLEMENTATION.
  METHOD bad_syntax_throws.
    DATA lo_sql TYPE REF TO cl_sql_statement.

    CREATE OBJECT lo_sql.
    TRY.
        lo_sql->execute_update( |hello world| ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sql_exception.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.