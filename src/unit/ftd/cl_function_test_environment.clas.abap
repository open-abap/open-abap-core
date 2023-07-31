CLASS cl_function_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.
    " Note: open-abap function module test doubles allows creating doubles for non-existing function modules
    CLASS-METHODS create
      IMPORTING
        function_modules                 TYPE if_function_test_environment=>tt_function_dependencies
      RETURNING
        VALUE(function_test_environment) TYPE REF TO if_function_test_environment.
ENDCLASS.

CLASS cl_function_test_environment IMPLEMENTATION.

  METHOD create.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.