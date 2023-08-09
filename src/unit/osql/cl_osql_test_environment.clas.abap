CLASS cl_osql_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_osql_test_environment.

    CLASS-METHODS create
      IMPORTING
        i_dependency_list TYPE if_osql_test_environment=>ty_t_sobjnames
      RETURNING
        VALUE(r_result)   TYPE REF TO if_osql_test_environment.

  PRIVATE SECTION.
    DATA mt_tables TYPE if_osql_test_environment=>ty_t_sobjnames.
ENDCLASS.

CLASS cl_osql_test_environment IMPLEMENTATION.

  METHOD create.
    DATA lo_env TYPE REF TO cl_osql_test_environment.

    ASSERT sy-dbsys = 'sqlite'.

    CREATE OBJECT lo_env.
    lo_env->mt_tables = i_dependency_list.

* https://www.sqlite.org/lang_attach.html
* https://www.sqlite.org/lang_detach.html

    r_result = lo_env.

  ENDMETHOD.

  METHOD if_osql_test_environment~clear_doubles.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD if_osql_test_environment~destroy.
    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD if_osql_test_environment~insert_test_data.
    RETURN. " todo, implement method
  ENDMETHOD.

ENDCLASS.