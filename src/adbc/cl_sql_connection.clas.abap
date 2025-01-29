CLASS cl_sql_connection DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_connection
      IMPORTING
        con_name          TYPE clike
        sharable          TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(connection) TYPE REF TO cl_sql_connection.

    " added in 7.53
    CLASS-METHODS get_abap_connection
      IMPORTING
        con_name          TYPE clike
      RETURNING
        VALUE(connection) TYPE REF TO cl_sql_connection.

    METHODS create_statement
      RETURNING
        VALUE(statement) TYPE REF TO cl_sql_statement.

    METHODS get_con_name
      RETURNING
        VALUE(con_name) TYPE string.

  PRIVATE SECTION.
    DATA mv_con_name TYPE string.
ENDCLASS.

CLASS cl_sql_connection IMPLEMENTATION.
  METHOD get_con_name.
    con_name = mv_con_name.
  ENDMETHOD.

  METHOD create_statement.
    CREATE OBJECT statement.
  ENDMETHOD.

  METHOD get_connection.
    " only supported for now,
    ASSERT sharable = abap_true.
    CREATE OBJECT connection.
  ENDMETHOD.

  METHOD get_abap_connection.
    connection = get_connection(
      con_name = con_name
      sharable = abap_true ).
  ENDMETHOD.

ENDCLASS.