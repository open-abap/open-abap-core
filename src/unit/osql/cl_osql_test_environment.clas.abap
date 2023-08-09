CLASS cl_osql_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_osql_test_environment.

    CLASS-METHODS create
      IMPORTING
        i_dependency_list TYPE if_osql_test_environment=>ty_t_sobjnames
      RETURNING
        VALUE(r_result)   TYPE REF TO if_osql_test_environment.

  PRIVATE SECTION.
    CONSTANTS mv_schema TYPE string VALUE 'double'.

    DATA mt_tables TYPE if_osql_test_environment=>ty_t_sobjnames.
    DATA mo_sql    TYPE REF TO cl_sql_statement.

    METHODS initialize.
ENDCLASS.

CLASS cl_osql_test_environment IMPLEMENTATION.

  METHOD create.
    DATA lo_env TYPE REF TO cl_osql_test_environment.

    ASSERT sy-dbsys = 'sqlite'.

    CREATE OBJECT lo_env.
    lo_env->mt_tables = i_dependency_list.
    CREATE OBJECT lo_env->mo_sql.
    lo_env->initialize( ).

    r_result = lo_env.

  ENDMETHOD.

  METHOD initialize.

    DATA lv_table LIKE LINE OF mt_tables.

* https://www.sqlite.org/lang_attach.html
    mo_sql->execute_update( |ATTACH DATABASE ':memory:' AS { mv_schema };| ).

    LOOP AT mt_tables INTO lv_table.
      lv_table = to_lower( lv_table ).
      mo_sql->execute_update( |CREATE TABLE { mv_schema }.{ lv_table } AS SELECT * FROM { lv_table } WHERE 0;| ).
    ENDLOOP.

    if_osql_test_environment~clear_doubles( ).

* TODODOOOOO, set runtime options

  ENDMETHOD.

  METHOD if_osql_test_environment~clear_doubles.
    DATA lv_table LIKE LINE OF mt_tables.

    LOOP AT mt_tables INTO lv_table.
      lv_table = to_lower( lv_table ).
      mo_sql->execute_update( |DELETE FROM { mv_schema }.{ lv_table };| ).
    ENDLOOP.
  ENDMETHOD.

  METHOD if_osql_test_environment~destroy.

* https://www.sqlite.org/lang_detach.html
    mo_sql->execute_update( |DETACH DATABASE { mv_schema };| ).

  ENDMETHOD.

  METHOD if_osql_test_environment~insert_test_data.
    DATA lo_table_descr  TYPE REF TO cl_abap_tabledescr.
    DATA lo_struct_descr TYPE REF TO cl_abap_structdescr.
    DATA lv_table        TYPE string.

    lo_table_descr ?= cl_abap_typedescr=>describe_by_data( i_data ).
    lo_struct_descr ?= lo_table_descr->get_table_line_type( ).
    lv_table = lo_struct_descr->get_relative_name( ).

* sanity checks,
    ASSERT lv_table IS NOT INITIAL.
    READ TABLE mt_tables WITH KEY table_line = lv_table TRANSPORTING NO FIELDS.
    ASSERT sy-subrc = 0.

    INSERT (lv_table) FROM TABLE i_data.
    ASSERT sy-subrc = 0.

  ENDMETHOD.

ENDCLASS.