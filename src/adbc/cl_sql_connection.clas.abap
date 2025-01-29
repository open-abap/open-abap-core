CLASS cl_sql_connection DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_connection
      IMPORTING
        connection_type   TYPE clike
        sharable          TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(connection) TYPE REF TO cl_sql_connection.

    " added in 7.53
    CLASS-METHODS get_abap_connection
      IMPORTING
        connection_type   TYPE clike
      RETURNING
        VALUE(connection) TYPE REF TO cl_sql_connection.

    METHODS create_statement
      RETURNING
        VALUE(statement) TYPE REF TO cl_sql_statement.
ENDCLASS.

CLASS cl_sql_connection IMPLEMENTATION.
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
      connection_type = connection_type
      sharable        = abap_true ).
  ENDMETHOD.

ENDCLASS.