CLASS cl_abap_context_info DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES ty_system_date TYPE d.
    TYPES ty_system_time TYPE t.
    TYPES ty_user_alias TYPE c LENGTH 40.

    CLASS-METHODS get_system_date
      RETURNING
        VALUE(rv_date) TYPE ty_system_date.

    CLASS-METHODS get_system_time
      RETURNING
        VALUE(rv_time) TYPE ty_system_time.

    CLASS-METHODS get_user_alias
      RETURNING
        VALUE(rv_alias) TYPE ty_user_alias.
ENDCLASS.

CLASS cl_abap_context_info IMPLEMENTATION.

  METHOD get_system_date.
    rv_date = sy-datum.
  ENDMETHOD.

  METHOD get_system_time.
    rv_time = sy-uzeit.
  ENDMETHOD.

  METHOD get_user_alias.
    rv_alias = sy-uname.
  ENDMETHOD.

ENDCLASS.
