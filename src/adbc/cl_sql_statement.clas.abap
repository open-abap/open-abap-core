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
    DATA lv_connection TYPE string.
ENDCLASS.

CLASS cl_sql_statement IMPLEMENTATION.

  METHOD constructor.
    IF con_ref IS INITIAL.
      lv_connection = 'DEFAULT'.
    ELSE.
      lv_connection = con_ref->get_con_name( ).
    ENDIF.
  ENDMETHOD.

  METHOD execute_ddl.
    ASSERT 1 = 'not supported'.
  ENDMETHOD.

  METHOD execute_update.

    DATA lv_sql_message TYPE string.

    ASSERT statement IS NOT INITIAL.

    WRITE '@KERNEL if (abap.context.databaseConnections["DEFAULT"] === undefined) {'.
    lv_sql_message = 'not connected to db'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception.
    ENDIF.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   await abap.context.databaseConnections["DEFAULT"].execute(statement.get());'.
    WRITE '@KERNEL } catch(e) {'.
    WRITE '@KERNEL   lv_sql_message.set(e + "");'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception.
    ENDIF.

  ENDMETHOD.

  METHOD execute_query.
    DATA lv_sql_message TYPE string.

    ASSERT statement IS NOT INITIAL.

    WRITE '@KERNEL if (abap.context.databaseConnections["DEFAULT"] === undefined) {'.
    lv_sql_message = 'not connected to db'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception.
    ENDIF.

    CREATE OBJECT result_set.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   const res = await abap.context.databaseConnections["DEFAULT"].select({select: statement.get()});'.
*    WRITE '@KERNEL   console.dir(res.rows);'.
    WRITE '@KERNEL   result_set.get().mv_magic = res.rows;'.
    WRITE '@KERNEL } catch(e) {'.
    WRITE '@KERNEL   lv_sql_message.set(e + "");'.
    WRITE '@KERNEL }'.
    IF lv_sql_message IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_sql_exception.
    ENDIF.

  ENDMETHOD.

ENDCLASS.