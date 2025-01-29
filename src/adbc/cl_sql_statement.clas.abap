CLASS cl_sql_statement DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        con_ref TYPE REF TO cl_sql_connection OPTIONAL.

    METHODS execute_update
      IMPORTING
        statement TYPE string
      RAISING
        cx_sql_exception.

    METHODS execute_query
      IMPORTING
        statement         TYPE string
      RETURNING
        VALUE(result_set) TYPE REF TO cl_sql_result_set
      RAISING
        cx_sql_exception.

    METHODS execute_ddl
      IMPORTING
        statement TYPE string
      RAISING
        cx_sql_exception.

  PRIVATE SECTION.
    DATA mv_connection TYPE string.
ENDCLASS.

CLASS cl_sql_statement IMPLEMENTATION.

  METHOD constructor.
    IF con_ref IS INITIAL.
      mv_connection = 'DEFAULT'.
    ELSE.
      mv_connection = con_ref->get_con_name( ).
    ENDIF.

    ASSERT mv_connection IS NOT INITIAL.
  ENDMETHOD.

  METHOD execute_ddl.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD execute_update.

    DATA lv_sql_message TYPE string.

    ASSERT statement IS NOT INITIAL.

    WRITE '@KERNEL if (abap.context.databaseConnections[this.mv_connection.get()] === undefined) {'.
    lv_sql_message = 'not connected to db'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception.
    ENDIF.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   await abap.context.databaseConnections[this.mv_connection.get()].execute(statement.get());'.
    WRITE '@KERNEL } catch(e) {'.
    WRITE '@KERNEL   lv_sql_message.set(e + "");'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception.
    ENDIF.

  ENDMETHOD.

  METHOD execute_query.
    DATA lx_osql        TYPE REF TO cx_sy_dynamic_osql_semantics.
    DATA lv_sql_message TYPE string.

    ASSERT statement IS NOT INITIAL.
    ASSERT mv_connection IS NOT INITIAL.

    WRITE '@KERNEL if (abap.context.databaseConnections[this.mv_connection.get()] === undefined) {'.
    lv_sql_message = 'not connected to db'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception EXPORTING sql_message = lv_sql_message.
    ENDIF.

    CREATE OBJECT result_set.

    TRY.
        WRITE '@KERNEL   const res = await abap.context.databaseConnections[this.mv_connection.get()].select({select: statement.get()});'.
*    WRITE '@KERNEL   console.dir(res.rows);'.
        WRITE '@KERNEL   result_set.get().mv_magic = res.rows;'.
      CATCH cx_sy_dynamic_osql_semantics INTO lx_osql.
        RAISE EXCEPTION TYPE cx_sql_exception EXPORTING sql_message = lx_osql->sqlmsg.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.