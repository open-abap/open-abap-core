CLASS cl_sql_statement DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS execute_update
      IMPORTING
        statement TYPE string
      RAISING
        cx_sql_exception.
ENDCLASS.

CLASS cl_sql_statement IMPLEMENTATION.

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

ENDCLASS.