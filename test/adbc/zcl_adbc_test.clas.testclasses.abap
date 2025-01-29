CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION MEDIUM FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD test.

    DATA lo_stmt   TYPE REF TO cl_sql_statement.
    DATA lv_sql    TYPE string.
    DATA lo_result TYPE REF TO cl_sql_result_set.


    lo_stmt = cl_sql_connection=>get_abap_connection( 'PG' )->create_statement( ).

    lv_sql = |select * from films|.
    lo_result = lo_stmt->execute_query( lv_sql ).

  ENDMETHOD.
ENDCLASS.