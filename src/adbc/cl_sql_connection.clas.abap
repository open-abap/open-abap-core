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
ENDCLASS.

CLASS cl_sql_connection IMPLEMENTATION.
  METHOD get_connection.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD get_abap_connection.
    connection = get_connection(
      connection_type = connection_type
      sharable        = abap_true ).
  ENDMETHOD.

ENDCLASS.