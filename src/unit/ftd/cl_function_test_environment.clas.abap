CLASS cl_function_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES if_function_test_environment.

    " Note: open-abap function module test doubles allows creating doubles for non-existing function modules
    CLASS-METHODS create
      IMPORTING
        function_modules                 TYPE if_function_test_environment=>tt_function_dependencies
      RETURNING
        VALUE(function_test_environment) TYPE REF TO if_function_test_environment.
ENDCLASS.

CLASS cl_function_test_environment IMPLEMENTATION.

  METHOD create.
    CREATE OBJECT function_test_environment TYPE cl_function_test_environment.
  ENDMETHOD.

  METHOD if_function_test_environment~get_double.
    CREATE OBJECT result TYPE lcl_double.
  ENDMETHOD.

ENDCLASS.