CLASS cl_salv_columns_table DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_optimize.
    METHODS get_column
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE REF TO cl_salv_table.
ENDCLASS.

CLASS cl_salv_columns_table IMPLEMENTATION.
  METHOD get_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_optimize.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.