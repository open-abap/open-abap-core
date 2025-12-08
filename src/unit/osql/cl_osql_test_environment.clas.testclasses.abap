CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    METHODS basic FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD basic.
    TYPES ty_tdevc TYPE STANDARD TABLE OF tdevc WITH DEFAULT KEY.

    DATA li_environment TYPE REF TO if_osql_test_environment.
    DATA lt_tables TYPE if_osql_test_environment=>ty_t_sobjnames.
    DATA lt_insert TYPE ty_tdevc.
    DATA lt_double TYPE ty_tdevc.
    DATA lt_before TYPE ty_tdevc.
    DATA lt_after  TYPE ty_tdevc.
    DATA ls_row    TYPE tdevc.

    SELECT * FROM tdevc INTO TABLE @lt_before ORDER BY PRIMARY KEY.

    APPEND 'TDEVC' TO lt_tables.
    li_environment = cl_osql_test_environment=>create( lt_tables ).
    ls_row-devclass = 'HELLO'.
    INSERT ls_row INTO TABLE lt_insert.
    li_environment->insert_test_data( lt_insert ).

    SELECT * FROM tdevc INTO TABLE @lt_double ORDER BY PRIMARY KEY.
    cl_abap_unit_assert=>assert_equals(
      act = lt_double
      exp = lt_insert ).

    li_environment->destroy( ).

* check table is back to normal
    SELECT * FROM tdevc INTO TABLE @lt_after ORDER BY PRIMARY KEY.
    cl_abap_unit_assert=>assert_equals(
      act = lt_after
      exp = lt_before ).

  ENDMETHOD.

ENDCLASS.