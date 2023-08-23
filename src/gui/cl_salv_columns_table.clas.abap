CLASS cl_salv_columns_table DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_cell_type_column
      IMPORTING value TYPE string.
    METHODS set_optimize
      IMPORTING value TYPE abap_bool DEFAULT abap_true.
    METHODS set_color_column
      IMPORTING value TYPE string.
    METHODS get_column
      IMPORTING columnname TYPE string
      RETURNING VALUE(value) TYPE REF TO cl_salv_column.
    METHODS get
      RETURNING VALUE(value) TYPE string.
    METHODS set_exception_column
      IMPORTING value TYPE any.
ENDCLASS.

CLASS cl_salv_columns_table IMPLEMENTATION.
  METHOD get_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_exception_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_cell_type_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_optimize.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_color_column.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.