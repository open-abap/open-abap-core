CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    DATA mi_environment TYPE REF TO if_osql_test_environment.

    METHODS test1 FOR TESTING RAISING cx_static_check.

    METHODS setup.
    METHODS teardown.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.
    DATA lt_tables TYPE if_osql_test_environment=>ty_t_sobjnames.

    APPEND 'TDEVC' TO lt_tables.
    mi_environment = cl_osql_test_environment=>create( lt_tables ).
  ENDMETHOD.

  METHOD teardown.
    mi_environment->clear_doubles( ).
    mi_environment->destroy( ).
  ENDMETHOD.

  METHOD test1.
* todo
  ENDMETHOD.

ENDCLASS.