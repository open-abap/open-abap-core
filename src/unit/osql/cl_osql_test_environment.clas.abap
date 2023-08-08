CLASS cl_osql_test_environment DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS create
      IMPORTING
        i_dependency_list TYPE if_osql_test_environment=>ty_t_sobjnames
      RETURNING
        VALUE(r_result)   TYPE REF TO if_osql_test_environment.
ENDCLASS.

CLASS cl_osql_test_environment IMPLEMENTATION.

  METHOD create.
    ASSERT 1 = 'todo'.
    ASSERT sy-dbsys = 'sqlite'.

* https://www.sqlite.org/lang_attach.html
* https://www.sqlite.org/lang_detach.html

* table prefix map in runtime options?

    " EXEC SQL.
    " ENDEXEC.
  ENDMETHOD.

ENDCLASS.