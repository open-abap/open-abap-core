CLASS cl_salv_functions_list DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS set_all
      IMPORTING flag
        TYPE abap_bool OPTIONAL.

    METHODS get_functions
      RETURNING
        VALUE(sdf) TYPE string.

    METHODS set_default
      IMPORTING
        value TYPE abap_bool DEFAULT abap_true.

    METHODS add_function
      IMPORTING
        name     TYPE any
        icon     TYPE string OPTIONAL
        text     TYPE string OPTIONAL
        tooltip  TYPE string
        position TYPE any.
ENDCLASS.

CLASS cl_salv_functions_list IMPLEMENTATION.
  METHOD set_all.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD get_functions.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD set_default.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD add_function.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.